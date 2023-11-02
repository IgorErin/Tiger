open Parsetree

type expty = { exp : Translate.exp; ty : Types.t }

open Env

module Check = struct
  let int = function Types.Int -> () | _ -> failwith "Types msut be Int"
  let unit = function Types.Unit -> () | _ -> failwith "Type must be Unit"

  let int_tr t =
    int t;
    t

  let unit_tr t =
    unit t;
    t

  let equal fst snd =
    if Types.equal fst snd then () else failwith "Types must be equal"

  let equal_tr fst snd =
    equal fst snd;
    fst

  let equal3_tr fst snd thd =
    equal fst snd;
    equal snd thd;
    fst

  let nil_record_constr fst snd =
    let open Types in
    if Types.equal fst snd then fst
    else
      match (fst, snd) with
      | Nil, (Record _ as r) | (Record _ as r), Nil -> r
      | _ -> failwith "Nil and record. Not equal types."

  let get_unique () = ref ()

  let sy_equal fst snd =
    if Symbol.equal fst snd then () else failwith "Symbol must be equal."
end

let create_unit_exp ty = { exp = (); ty }
let get_type Typedtree.{ exp_type; _ } = exp_type
let ( >> ) f g x = f x |> g
let mk_typed_exp exp_type exp_desc = Typedtree.{ exp_type; exp_desc }

let rec transExp (env : env) exp =
  let open Typedtree in
  let rec trexp = function
    | PVarExp v ->
        let var = trvar env.types v in
        let exp_type = var.var_type in
        mk_typed_exp exp_type @@ TVarExp var
    | PNilExp -> mk_typed_exp Types.Nil TNilExp
    | PIntExp v -> mk_typed_exp Types.Int @@ TIntExp v
    | PStringExp s -> mk_typed_exp Types.String @@ TStringExp s
    | PCallExp { func; args } -> (
        Symbol.look env.funs func |> function
        | Some func_sig ->
            let args = List.map trexp args in
            let () =
              List.map get_type args |> List.iter2 Check.equal func_sig.formals
            in
            let exp = TCallExp { func; args } in
            mk_typed_exp func_sig.result exp
        | None ->
            failwith
            @@ Printf.sprintf "Undefinded function: %s"
            @@ Symbol.name func)
    | POpExp { left; oper; right } ->
        let left = trexp left in
        let right = trexp right in
        let () =
          let () = left |> get_type |> Check.int in
          right |> get_type |> Check.int
        in
        let texp = TOpExp { left; oper; right } in
        mk_typed_exp Types.Int texp
    | PSeqExp ls -> (
        List.rev ls |> function
        | [] -> mk_typed_exp Types.Unit @@ TSeqExp []
        | [ hd ] -> trexp hd
        | hd :: tl ->
            let tl = List.map trexp tl in
            let () = List.iter (get_type >> Check.unit) tl in
            let hd = trexp hd in
            let texp = TSeqExp (hd :: tl) in
            mk_typed_exp (get_type hd) texp)
    | PAssignExp { var; exp } ->
        let exp = trexp exp in
        let expty = exp |> get_type in
        let var = trvar env.types var in
        let () = Check.equal var.var_type expty in
        let texp = TAssignExp { var; exp } in
        mk_typed_exp Types.Unit texp
    | PIfExp { test; then_; else_ = Some else_ } ->
        let test = trexp test in
        let then_ = trexp then_ in
        let else_ = trexp else_ in
        let () =
          let () = test |> get_type |> Check.int in
          Check.equal (get_type then_) (get_type else_)
        in
        let texp = TIfExp { test; then_; else_ = Some else_ } in
        mk_typed_exp (get_type then_) texp
    | PIfExp { test; then_; else_ = None } ->
        let test = trexp test in
        let then_ = trexp then_ in
        let () =
          let () = test |> get_type |> Check.int in
          then_ |> get_type |> Check.unit
        in
        let texp = TIfExp { test; then_; else_ = None } in
        mk_typed_exp (get_type then_) texp
    | PWhileExp { test; body } ->
        let test = trexp test in
        let body = trexp body in
        let () =
          let () = get_type test |> Check.int in
          get_type body |> Check.unit
        in
        let texp = TWhileExp { test; body } in
        mk_typed_exp Types.Unit texp
    | PForExp { var; escape; lb; hb; body } ->
        let lb = trexp lb in
        let hb = trexp hb in
        let body =
          let vars = Symbol.enter env.vars var Types.Int in
          transExp { env with vars } body
        in
        let () =
          let () = lb |> get_type |> Check.int in
          let () = hb |> get_type |> Check.int in
          body |> get_type |> Check.unit
        in
        let texp = TForExp { var; escape; lb; hb; body } in
        mk_typed_exp Types.Unit texp
    | PBreakExp ->
        (* TODO check that in for or while *)
        mk_typed_exp Types.Unit TBreakExp
    | PLetExp { decs; body } ->
        let decs, env =
          List.fold_left
            (fun (acc, env) decs ->
              let dec, env = transDec env decs in
              let new_acc = dec :: acc in
              (new_acc, env))
            ([], env) decs
        in
        let body = transExp env body in
        let texp = Typedtree.TLetExp { decs; body } in
        mk_typed_exp body.exp_type texp
    | PArrayExp { type_; size; init } -> (
        let type_ = Symbol.look env.types type_ in
        let size = trexp size in
        let init = trexp init in
        match type_ with
        | Some (Types.Array (mem_type, _) as type_) ->
            let () =
              let () = size |> get_type |> Check.int in
              init |> get_type |> Check.equal mem_type
            in
            let texp = TArrayExp { type_; size; init } in
            mk_typed_exp type_ texp
        | Some _ -> failwith "Must be array type."
        | None -> failwith "ArrayExp. Not found.")
    | PRecordExp { type_; fields } -> (
        let type_ =
          Symbol.look env.types type_ |> function
          | Some t -> t
          | _ -> failwith "Type not found."
        in
        type_ |> function
        | Types.Record (ls, _) ->
            let fields = List.map (fun (s, e) -> (s, trexp e)) fields in
            let () =
              List.iter2
                (fun (fsts, e) (snds, ty) ->
                  let () = Check.sy_equal fsts snds in
                  Check.equal ty @@ get_type e)
                fields ls
            in
            let desc = Typedtree.TRecordExp { type_; fields } in
            mk_typed_exp type_ desc
        | _ -> failwith "")
  and trvar venv v =
    let field_type t m =
      match t with
      | Types.Record (ls, _) -> (
          let sameSymbol = List.filter (fst >> Symbol.equal m) ls in
          match sameSymbol with
          | [] -> failwith "No such field" (* TODO*)
          | [ (_, t) ] -> t
          (* since fileds names must check transDec (invariant)*)
          | _ :: _ -> assert false)
      | _ -> failwith "Must be record. Fields contain only records"
    in
    let array_type = function
      | Types.Array (t, _) -> t
      | _ -> failwith "Must be array type"
    in
    let trvar = trvar venv in
    match v with
    | PSimpleVar s as var -> (
        Symbol.look venv s |> function
        | Some var_type -> { var_type; var_desc = TSimpleVar s }
        | None ->
            failwith @@ Printf.sprintf "unbound var type: %s" @@ Symbol.name s)
    | PFieldVar (v, f) ->
        let v = trvar v in
        let ft = field_type v.var_type f in
        let var_type = ft in
        let var_desc = TFieldVar (v, f) in
        { var_desc; var_type }
    | PSubscriptVar (v, e) ->
        let texp = trexp e in
        let () = texp |> get_type |> Check.int in
        let v = trvar v in
        let var_type = array_type v.var_type in
        let var_desc = TSubscriptVar (v, texp) in
        { var_type; var_desc }
  in
  trexp exp

and transDec env = function
  | PVarDec { name; escape; type_ = Some type_; init } ->
      let init = transExp env init in
      let type_ =
        Symbol.look env.types type_
        |> (function Some typ -> typ | None -> failwith "Unknown var type")
        |> Check.nil_record_constr (get_type init)
      in
      let vars = Symbol.enter env.vars name type_ in
      let desc = Typedtree.TVarDec { name; escape; type_; init } in
      (desc, { env with vars })
  | PVarDec { name; escape; type_ = None; init } ->
      let init = transExp env init in
      let type_ = get_type init in
      let vars = Symbol.enter env.vars name type_ in
      let desc = Typedtree.TVarDec { name; escape; type_; init } in
      (desc, { env with vars })
  | PTypeDec [ { ptd_name; ptd_type } ] ->
      let type_ = transTy env ptd_type in
      let types = Symbol.enter env.types ptd_name type_ in
      let desc =
        Typedtree.TTypeDec [ { td_name = ptd_name; td_type = type_ } ]
      in
      (desc, { env with types })
  | PTypeDec ls ->
      let open Types in
      let add env name t = Symbol.enter env name t in
      let names = List.map (fun { ptd_name; _ } -> ptd_name) ls in
      let types =
        List.fold_left
          (fun env tname ->
            let ty = Name (tname, ref None) in
            add env tname ty)
          env.types names
      in
      let set_type { ptd_name; ptd_type } =
        let ty = transTy { env with types } ptd_type in
        (Symbol.look types ptd_name |> function
         | Some v -> v
         | None -> failwith "Undec type")
        |> function
        | Types.Name (_, r) ->
            let () = r := Some ty in
            Typedtree.{ td_name = ptd_name; td_type = ty }
        | _ -> failwith "Name expected"
      in
      let ls = ls |> List.map set_type in
      let desc = Typedtree.TTypeDec ls in
      (desc, { env with types })
  | PFunctionDec ls ->
      let open Types in
      (* helpers*)
      let ty_of_opt = function
        | Some t -> t
        | _ -> failwith "Type not found."
      in
      let ty_of_symbol s = Symbol.look env.types s |> ty_of_opt in
      let map_result = function Some t -> ty_of_symbol t | None -> Unit in
      let map_param x = ty_of_symbol x.Parsetree.pfd_type in
      (* create env.funs be heads *)
      let funs =
        List.fold_left
          (fun funs { pfun_name; pfun_params; pfun_result; _ } ->
            let formals = List.map map_param pfun_params in
            let result = map_result pfun_result in
            Symbol.enter funs pfun_name Env.{ formals; result })
          env.funs ls
      in
      (* map params to new env.vars *)
      let mod_vars params =
        let tfields =
          List.map
            (fun { pfd_name; pfd_escape; pfd_type } ->
              let fd_type = ty_of_symbol pfd_type in
              Typedtree.{ fd_name = pfd_name; fd_escape = pfd_escape; fd_type })
            params
        in

        let vars =
          List.fold_left
            (fun vars Typedtree.{ fd_name; fd_type; _ } ->
              Symbol.enter vars fd_name fd_type)
            env.vars tfields
        in
        (vars, tfields)
      in
      (* travers body, check return type *)
      let ls =
        List.map
          (fun { pfun_body; pfun_result; pfun_params; pfun_name } ->
            (* for each funs
               1) add params and funs to env.vars
               2) check body
               3) compare body and result type *)
            let vars, fun_params = mod_vars pfun_params in
            let env = { env with funs; vars } in
            let fun_body = transExp env pfun_body in
            let fun_result = map_result pfun_result in
            let () = Check.equal (get_type fun_body) fun_result in
            Typedtree.{ fun_name = pfun_name; fun_params; fun_result; fun_body })
          ls
      in
      let desc = Typedtree.TFunctionDec ls in
      (desc, { env with funs })

and transTy env t =
  let ty_of_opt = function Some x -> x | None -> failwith "Unknown type" in
  let get_type env s = ty_of_opt @@ Symbol.look env.types s in
  let run = function
    | NameTy n -> Symbol.look env.types n |> ty_of_opt
    | RecordTy fl ->
        let fl =
          List.map
            (fun { pfd_name; pfd_type; _ } -> (pfd_name, get_type env pfd_type))
            fl
        in
        let unique = Check.get_unique () in
        Types.Record (fl, unique)
    | ArrayTy s ->
        let t = get_type env s in
        let unique = Check.get_unique () in
        Array (t, unique)
  in
  run t

let trans = transExp Env.base_env
