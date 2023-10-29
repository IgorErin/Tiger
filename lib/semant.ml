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
end

let create_unit_exp ty = { exp = (); ty }

let get_type { ty; _ } =
  match ty with
  | Name (_, x) -> (
      !x |> function Some x -> x | _ -> failwith "None in name")
  | _ -> ty

let ( >> ) f g x = f x |> g

let rec transExp (env : env) exp =
  let rec trexp = function
    | PVarExp v -> trvar env.types v (* TODO *)
    | PNilExp -> create_unit_exp Types.Nil
    | PIntExp _ -> create_unit_exp Types.Int
    | PStringExp _ -> create_unit_exp Types.String
    | PCallExp { func; args } -> (
        Symbol.look env.funs func |> function
        | Some func ->
            let argst = func.formals in
            let args_types = List.map (trexp >> get_type) args in
            let _ = List.iter2 Check.equal func.formals args_types in
            create_unit_exp func.result
        | None ->
            failwith
            @@ Printf.sprintf "Undefinded function: %s"
            @@ Symbol.name func)
    | POpExp { left; oper = _; right } ->
        let _ = trexp left |> get_type |> Check.int in
        let _ = trexp right |> get_type |> Check.int in
        create_unit_exp Types.Int
    | PSeqExp ls -> (
        List.rev ls |> function
        | [] -> create_unit_exp Types.Unit
        | [ hd ] -> trexp hd
        | hd :: tl ->
            let _ = List.iter (trexp >> get_type >> Check.unit) tl in
            trexp hd)
    | PAssignExp { var; exp } -> (
        let rty = trexp exp |> get_type in
        let lty = Symbol.look env.vars var in
        match lty with
        | Some lty ->
            let _ = Check.equal lty rty in
            Types.Unit |> create_unit_exp
        | None -> failwith "Undefinded var")
    | PIfExp { test; then_; else_ = Some else_ } ->
        let _ = trexp test |> get_type |> Check.int in
        let t = trexp then_ |> get_type in
        let e = trexp else_ |> get_type in
        Check.equal_tr t e |> create_unit_exp
    | PIfExp { test; then_; else_ = None } ->
        let _ = trexp test |> get_type |> Check.int in
        let t = trexp then_ |> get_type in
        Check.unit_tr t |> create_unit_exp
    | PWhileExp { test; body } ->
        let _ = trexp test |> get_type |> Check.int in
        let _ = trexp body |> get_type |> Check.unit in
        create_unit_exp Types.Unit
    | PForExp { var; escape = _; lb; hb; body } ->
        let vart =
          let lot = trexp lb |> get_type |> Check.int in
          let hit = trexp hb |> get_type |> Check.int in
          ()
        in
        (* always int *)
        let vars = Symbol.enter env.vars var Types.Int in
        let bodyt = transExp { env with vars } body |> get_type in
        Check.unit_tr bodyt |> create_unit_exp
    | PBreakExp -> Types.Unit |> create_unit_exp
    | PLetExp { decs; body } ->
        let env = List.fold_left transDec env decs in
        transExp env body
    | PArrayExp { type_; size; init } -> (
        let _ = trexp size |> get_type |> Check.int in
        let it = trexp init |> get_type in
        let at = Symbol.look env.types type_ in
        match at with
        | Some (Types.Array (ty, _) as at) ->
            let _ = Check.equal it ty in
            at |> create_unit_exp
        | Some _ -> failwith "Must be array type."
        | None -> failwith "ArrayExp. Not found.")
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
    | SimpleVar s ->
        Symbol.look venv s
        |> (function
             | Some t -> t
             | None ->
                 failwith
                 @@ Printf.sprintf "unbound var type: %s"
                 @@ Symbol.name s)
        |> create_unit_exp
    | FieldVar (v, f) ->
        let vt = get_type @@ trvar v in
        let ft = field_type vt f in
        create_unit_exp ft
    | SubscriptVar (v, e) ->
        let _ = trexp e |> get_type |> Check.int in
        let vt = trvar v |> get_type in
        array_type vt |> create_unit_exp
  in
  trexp exp

and transDec env = function
  | PVarDec { name; escape = _; type_ = Some type_; init } ->
      let it = transExp env init |> get_type in
      let vt =
        Symbol.look env.types type_
        |> (function Some typ -> typ | None -> failwith "Unknown var type")
        |> Check.nil_record_constr it
      in
      let vars = Symbol.enter env.vars name vt in
      { env with vars }
  | PVarDec { name; escape = _; type_ = None; init } ->
      let it = transExp env init |> get_type in
      let vars = Symbol.enter env.vars name it in
      { env with vars }
  | PTypeDec [ { ptd_name; ptd_type } ] ->
      let ty = transTy env ptd_type in
      let types = Symbol.enter env.types ptd_name ty in
      { env with types }
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
        | Types.Name (_, r) -> r := Some ty
        | _ -> failwith "Name expected"
      in
      let _ = ls |> List.iter set_type in
      { env with types }
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
        List.fold_left
          (fun vars { pfd_name; pfd_type; _ } ->
            let ty = ty_of_symbol pfd_type in
            Symbol.enter vars pfd_name ty)
          env.vars params
      in
      (* travers body, check return type *)
      let _ =
        List.iter
          (fun { pfun_body; pfun_result; pfun_params; _ } ->
            (* for each funs
               1) add params and funs to env.vars
               2) check body
               3) compare body and result type *)
            let vars = mod_vars pfun_params in
            let env = { env with funs; vars } in
            let bt = transExp env pfun_body |> get_type in
            let rt = map_result pfun_result in
            Check.equal bt rt)
          ls
      in
      { env with funs }

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

let type_check exp =
  let (_ : Types.t) = transExp Env.base_env exp |> get_type in
  ()
