open Parsetree
open Env

type error =
  | Unbound_name of string
  | Unbound_type of string
  | Not_a_record of Types.t
  | Not_a_array of Types.t
  | Type_mismatch
  | Umbiguos
  | Unclosed_break

exception
  Error of
    { error : error
    ; message : string
    }

let show_error = function
  | Unbound_name name -> Printf.sprintf "unbound name: %s" name
  | Unbound_type type_ -> Printf.sprintf "unbound type: %s" type_
  | Not_a_record type_ -> Printf.sprintf "not a record: %s" @@ Types.show type_
  | Not_a_array type_ -> Printf.sprintf "not a record: %s" @@ Types.show type_
  | Type_mismatch -> "Type mismatch"
  | Umbiguos -> "Umbiguos"
  | Unclosed_break -> "unclosed_break"
;;

module Error = struct
  let rais_error message error = raise @@ Error { error; message }
  let break m = rais_error m Umbiguos

  let undef_fun_call sname =
    let name = Symbol.name sname in
    rais_error "undef fun call" @@ Unbound_name name
  ;;

  let bin_op left op right =
    let left = Types.show left in
    let right = Types.show right in
    let op = Parsetree.show_oper op in
    let message = Printf.sprintf "%s %s %s" left op right in
    rais_error message Type_mismatch
  ;;

  let not_a_array type_ = rais_error "Array type expected" @@ Not_a_array type_
  let not_a_record ?(m = "") type_ = rais_error m @@ Not_a_record type_

  let unbound_type ?(m = "") sname =
    let name = Symbol.name sname in
    rais_error m @@ Unbound_type name
  ;;

  let unbound_name ?(m = "") sname =
    let name = Symbol.name sname in
    rais_error m @@ Unbound_name name
  ;;

  let type_mismatch m = rais_error m Type_mismatch
  let umbiguos m = rais_error m Umbiguos
end

module Check = struct
  let int = function
    | Types.Int -> ()
    | _ -> Error.type_mismatch "Type msut be Int"
  ;;

  let unit = function
    | Types.Unit -> ()
    | _ -> Error.type_mismatch "Type must be Unit"
  ;;

  let string = function
    | Types.String -> ()
    | _ -> Error.type_mismatch "must be string"
  ;;

  let string_op = function
    | `PlusOp -> Types.String
    | `GeOp | `GtOp | `LeOp | `LtOp | `EqOp -> Types.Int
    | _ -> Error.type_mismatch "must be string op string"
  ;;

  module Op = struct
    let eq =
      let open Types in
      function
      | Int | String | Record _ | Array _ | Unit -> Int
      | t ->
        let message = Printf.sprintf "equlity on %s" @@ Types.show t in
        Error.type_mismatch message
    ;;

    let compare =
      let open Types in
      function
      | Int | String -> Int
      | t ->
        let message = Printf.sprintf "compare on %s" @@ Types.show t in
        Error.type_mismatch ""
    ;;

    let plus =
      let open Types in
      function
      | Int -> Int
      | String -> String
      | t ->
        let message = Printf.sprintf "equlity on %s" @@ Types.show t in
        Error.type_mismatch ""
    ;;

    let arithmetic =
      let open Types in
      function
      | Int -> Int
      | t ->
        let message = Printf.sprintf "equlity on %s" @@ Types.show t in
        Error.type_mismatch ""
    ;;

    let infer op type_ =
      match op with
      | `EqOp | `NeqOp -> eq type_
      | `LtOp | `LeOp | `GtOp | `GeOp -> compare type_
      | `PlusOp -> plus type_
      | `MinusOp | `TimesOp | `DivideOp -> arithmetic type_
    ;;
  end

  let int_tr t =
    int t;
    t
  ;;

  let unit_tr t =
    unit t;
    t
  ;;

  let infer_type fst snd =
    let open Types in
    match actual_type fst, actual_type snd with
    | (Record _ as r), Nil | Nil, (Record _ as r) -> r
    | _ ->
      if Types.equal fst snd
      then fst
      else (
        let fst = Types.show fst in
        let snd = Types.show snd in
        Error.type_mismatch @@ Printf.sprintf "Types must be equal %s =/= %s" fst snd)
  ;;

  let equal fst snd =
    let (_ : Types.t) = infer_type fst snd in
    ()
  ;;

  let equal3_tr fst snd thd =
    equal fst snd;
    equal snd thd;
    fst
  ;;

  let get_unique () = ref ()
  let sy_equal fst snd ~m = if Symbol.equal fst snd then () else Error.umbiguos m

  let get_field_type type_ field_name =
    let type_ = Types.actual_type type_ in
    match type_ with
    | Types.Record (ls, _) ->
      let sameSymbol =
        ls
        |> List.mapi (fun index value -> index, value)
        |> List.find_opt (fun (_, (s, _)) -> Symbol.equal s field_name)
      in
      (match sameSymbol with
       | Some (index, (_, t)) -> index, t |> Types.actual_type
       | None ->
         let m = Printf.sprintf "No such fiedl in %s" @@ Types.show type_ in
         Error.unbound_name ~m field_name)
    | actual ->
      let field_name = Symbol.name field_name in
      let type_ = Types.show type_ in
      let m = Printf.sprintf "Attemt to get field %s on %s type" field_name type_ in
      Error.not_a_record ~m actual
  ;;

  let get_array_item_type t =
    match t with
    | Types.Array (t, _) -> t
    | _ -> Error.not_a_array t
  ;;

  let not_nil_tr =
    let open Types in
    function
    | Nil -> Error.type_mismatch "Nil unexpected"
    | x -> x
  ;;

  let record_fields_umbiguous fieds =
    fieds
    |> List.map fst
    |> Core.List.find_all_dups ~compare:(fun fst snd ->
      if Symbol.equal fst snd then 0 else 1)
    |> function
    | [] -> ()
    | list ->
      let names = List.map Symbol.name list |> String.concat " " in
      let m = Printf.sprintf "Umbiguous record fields: %s" names in
      Error.umbiguos m
  ;;

  let type_cycl source =
    let open Types in
    let rec loop = function
      | Name (name, toptr) ->
        (match !toptr with
         | Some x ->
           if Base.phys_equal x source
           then (
             let m = Printf.sprintf "Cycl type %s name" @@ Symbol.name name in
             Error.umbiguos m)
           else loop x
         | None -> Error.unbound_type ~m:"Mutual rec type unset." name)
      | _ -> ()
    in
    loop source
  ;;

  let mutual_fun_names ls =
    ls
    |> List.map (fun { pfun_name; _ } -> pfun_name)
    |> Core.List.find_all_dups ~compare:Symbol.compare
    |> function
    | [] -> ()
    | hd :: _ ->
      let m = Printf.sprintf "Same name in mutual fun def: %s" @@ Symbol.name hd in
      Error.umbiguos m
  ;;

  let mutual_type_names names =
    names
    |> Core.List.find_all_dups ~compare:Symbol.compare
    |> function
    | [] -> ()
    | hd :: _ ->
      let m = Printf.sprintf "Same name in mutual type def: %s" @@ Symbol.name hd in
      Error.umbiguos m
  ;;
end

let get_type Typedtree.{ exp_type; _ } = exp_type
let ( >> ) f g x = f x |> g

let not_name =
  let open Types in
  function
  | Name _ -> false
  | _ -> true
;;

let mk_typed_exp exp_type exp_desc =
  assert (not_name exp_type);
  Typedtree.{ exp_type; exp_desc }
;;

let sum message fst snd =
  match fst, snd with
  | true, false | false, true -> true
  | true, true -> failwith message
  | false, false -> false
;;

let break_check exp =
  let open Parsetree in
  let sname = Symbol.name in
  let rec no_break m exp = if run exp = false then () else Error.break m
  and run = function
    | PVarExp var ->
      let () = run_var var in
      false
    | PNilExp | PIntExp _ | PStringExp _ -> false
    | PCallExp { args; func } ->
      let m = Printf.sprintf "in arguments of %s fun call" @@ sname func in
      let () = List.iter (no_break m) args in
      false
    | POpExp { left; oper = _; right } ->
      let fst = run left in
      let snd = run right in
      fst || snd
    | PSeqExp ls ->
      let message = "more than one break in seq experssion" in
      let count = List.fold_left (fun acc exp -> sum message acc @@ run exp) false ls in
      count
    | PAssignExp { exp; var = _ } -> run exp
    | PIfExp { test; then_; else_ } ->
      let test = run test in
      let then_ = run then_ in
      let else_ = Core.Option.value ~default:false @@ Option.map run else_ in
      else_ || then_ || test
    | PWhileExp { test; body } ->
      let _ = run body in
      run test
    | PForExp { lb; hb; body; _ } ->
      let _ = run body in
      run lb || run hb
    | PBreakExp -> true
    | PLetExp { decs; body } ->
      List.iter run_dec decs;
      run body
    | PArrayExp { size; init; _ } -> run init || run size
    | PRecordExp { fields; _ } ->
      List.fold_left
        (fun acc (name, exp) ->
          let m = Printf.sprintf "unreachable break in init of field %s" @@ sname name in
          sum m acc @@ run exp)
        false
        fields
  and run_dec = function
    | PFunctionDec ls ->
      List.iter
        (fun { pfun_body; pfun_name; _ } ->
          let m = Printf.sprintf "in dec of %s" @@ sname pfun_name in
          no_break m pfun_body)
        ls
    | PVarDec { init; name; _ } ->
      let m = Printf.sprintf "in dec of %s" @@ sname name in
      no_break m init
    | PTypeDec _ -> ()
  and run_var = function
    | PSimpleVar _ -> ()
    | PFieldVar (var, _) -> run_var var
    | PSubscriptVar (var, exp) ->
      let m = Printf.sprintf "in subscript of %s" @@ show_var var in
      no_break m exp;
      run_var var
  in
  no_break "in expression" exp
;;

let rec transExp (env : env) exp =
  let open Typedtree in
  let rec trexp pexp =
    match pexp with
    | PVarExp v ->
      let var = trvar env.vars v in
      let exp_type = var.var_type in
      assert (not_name exp_type);
      mk_typed_exp exp_type @@ TVarExp var
    | PNilExp -> mk_typed_exp Types.Nil TNilExp
    | PIntExp v -> mk_typed_exp Types.Int @@ TIntExp v
    | PStringExp s -> mk_typed_exp Types.String @@ TStringExp s
    | PCallExp { func; args } ->
      Symbol.look env.funs func
      |> (function
      | Some func_sig ->
        let args = List.map trexp args in
        let () =
          let par = List.length func_sig.formals in
          let arg = List.length args in
          if par = arg
          then List.map get_type args |> List.iter2 Check.equal func_sig.formals
          else (
            let fname = Symbol.name func in
            let m =
              Printf.sprintf "Call of %s, parameters = %d, arguemnts = %d" fname par arg
            in
            Error.type_mismatch m)
        in
        let exp = TCallExp { func; args } in
        assert (not_name func_sig.result);
        mk_typed_exp func_sig.result exp
      | None -> Error.undef_fun_call func)
    | POpExp { left; oper; right } ->
      let left = trexp left in
      let right = trexp right in
      let common_type = Check.infer_type (get_type left) (get_type right) in
      let type_ = Check.Op.infer oper common_type in
      let desc = TOpExp { left; oper; right } in
      mk_typed_exp type_ desc
    | PSeqExp ls ->
      List.rev ls
      |> (function
      | [] -> mk_typed_exp Types.Unit @@ TSeqExp []
      | [ hd ] -> trexp hd
      | hd :: tl ->
        let tl = List.map trexp tl in
        let hd = trexp hd in
        let texp = TSeqExp (hd :: tl) in
        assert (not_name @@ get_type hd);
        mk_typed_exp (get_type hd) texp)
    | PAssignExp { var; exp } ->
      let exp = trexp exp in
      let expty = exp |> get_type in
      let var = trvar env.vars var in
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
      let result_type = Check.infer_type (get_type then_) (get_type else_) in
      assert (not_name result_type);
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
      mk_typed_exp Types.Unit texp
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
    | PBreakExp -> mk_typed_exp Types.Unit TBreakExp
    | PLetExp { decs; body } ->
      let decs, env =
        List.fold_left
          (fun (acc, env) decs ->
            let dec, env = transDec env decs in
            let new_acc = dec :: acc in
            new_acc, env)
          ([], env)
          decs
      in
      let decs = List.rev decs in
      let body = transExp env body in
      let texp = Typedtree.TLetExp { decs; body } in
      assert (not_name body.exp_type);
      mk_typed_exp body.exp_type texp
    | PArrayExp { type_; size; init } ->
      let source_type_name = Symbol.name type_ in
      Symbol.look env.types type_
      |> Option.map Types.actual_type
      |> (function
      | Some (Types.Array (mem_type, _) as type_) ->
        let size = trexp size in
        let init = trexp init in
        let () =
          let () = size |> get_type |> Check.int in
          init |> get_type |> Check.equal mem_type
        in
        let texp = TArrayExp { type_; size; init } in
        mk_typed_exp type_ texp
      | Some t -> Error.not_a_array t
      | None -> Error.unbound_type ~m:"Array type not found" type_)
    | PRecordExp { type_; fields } ->
      Symbol.look env.types type_
      |> Option.map Types.actual_type
      |> (function
      | Some (Types.Record (ls, _) as type_) ->
        let fields =
          List.map2
            (fun (fsts, e) (snds, ty) ->
              let () = Check.sy_equal fsts snds ~m:"Names in record check mismatch" in
              let e = trexp e in
              let exp_type = get_type e in
              let () = Check.equal ty exp_type in
              fsts, ty, e)
            fields
            ls
        in
        let desc = Typedtree.TRecordExp { type_; fields } in
        mk_typed_exp type_ desc
      | Some actual -> Error.not_a_record actual
      | None -> Error.unbound_type ~m:"Record expr type unbound." type_)
  and trvar venv v =
    let trvar = trvar venv in
    match v with
    | PSimpleVar s as var ->
      Symbol.look venv s
      |> Option.map Types.actual_type
      |> (function
      | Some var_type -> { var_type; var_desc = TSimpleVar s }
      | None -> Error.unbound_name s)
    | PFieldVar (v, f) ->
      let v = trvar v in
      let index, ft = Check.get_field_type v.var_type f in
      let var_type = ft |> Types.actual_type in
      let var_desc = TFieldVar (v, index) in
      { var_desc; var_type }
    | PSubscriptVar (v, e) ->
      let texp = trexp e in
      let () = texp |> get_type |> Check.int in
      let v = trvar v in
      let var_type = Check.get_array_item_type @@ Types.actual_type v.var_type in
      let var_desc = TSubscriptVar (v, texp) in
      { var_type; var_desc }
  in
  trexp exp

and transDec env = function
  | PVarDec { name; escape; type_ = Some type_; init } ->
    let init = transExp env init in
    let type_ =
      Symbol.look env.types type_
      |> (function
           | Some typ -> typ
           | None ->
             let var_name = Symbol.name name in
             let m = Printf.sprintf "Anbound var (%s) type annotation" var_name in
             Error.unbound_type ~m type_)
      |> Check.infer_type (get_type init)
    in
    let vars = Symbol.enter env.vars name type_ in
    let desc = Typedtree.TVarDec { name; escape; type_; init } in
    desc, { env with vars }
  | PVarDec { name; escape; type_ = None; init } ->
    let init = transExp env init in
    let type_ = get_type init |> Check.not_nil_tr in
    let vars = Symbol.enter env.vars name type_ in
    let desc = Typedtree.TVarDec { name; escape; type_; init } in
    desc, { env with vars }
  | PTypeDec ls ->
    let open Types in
    let add env name t = Symbol.enter env name t in
    let names = List.map (fun { ptd_name; _ } -> ptd_name) ls in
    let () = Check.mutual_type_names names in
    let types =
      List.fold_left
        (fun env tname ->
          let ty = Name (tname, ref None) in
          add env tname ty)
        env.types
        names
    in
    let set_type { ptd_name; ptd_type } =
      Symbol.look types ptd_name
      |> (function
           | Some v -> v
           | None -> Error.unbound_type ptd_name)
      |> function
      | Types.Name (name, r) as named ->
        assert (Symbol.equal name ptd_name);
        let type_ = transTy { env with types } ptd_type in
        let () = r := Some type_ in
        Typedtree.{ td_name = ptd_name; td_type = type_ }
      | actual ->
        let actual = Types.show actual in
        let current = Symbol.name ptd_name in
        let m =
          Printf.sprintf
            "Expected Name, actual = %s. Processing of %s fail"
            actual
            current
        in
        Error.type_mismatch m
    in
    let decs = ls |> List.map set_type in
    let () = List.iter (fun Typedtree.{ td_type; _ } -> Check.type_cycl td_type) decs in
    let desc = Typedtree.TTypeDec decs in
    desc, { env with types }
  | PFunctionDec ls ->
    let open Types in
    let ty_of_symbol s =
      Symbol.look env.types s
      |> Core.Option.value_or_thunk ~default:(fun () -> Error.unbound_type s)
      |> Types.actual_type
    in
    let type_of_result x =
      x
      |> (function
           | Some t -> ty_of_symbol t
           | None -> Unit)
      |> Types.actual_type
    in
    let type_of_parm x = ty_of_symbol x.Parsetree.pfd_type in
    let () = Check.mutual_fun_names ls in
    let funs =
      List.fold_left
        (fun funs { pfun_name; pfun_params; pfun_result; _ } ->
          let formals = List.map type_of_parm pfun_params in
          let result = type_of_result pfun_result in
          Symbol.enter funs pfun_name Env.{ formals; result })
        env.funs
        ls
    in
    let get_fields params =
      List.map
        (fun { pfd_name; pfd_escape; pfd_type } ->
          let fd_type = ty_of_symbol pfd_type in
          Typedtree.{ fd_name = pfd_name; fd_escape = pfd_escape; fd_type })
        params
    in
    let new_vars_env tfields =
      List.fold_left
        (fun vars Typedtree.{ fd_name; fd_type; _ } -> Symbol.enter vars fd_name fd_type)
        env.vars
        tfields
    in
    let ls =
      List.map
        (fun { pfun_body; pfun_result; pfun_params; pfun_name } ->
          let fun_params = get_fields pfun_params in
          let vars = new_vars_env fun_params in
          let env = { env with funs; vars } in
          let fun_body = transExp env pfun_body in
          let fun_result = type_of_result pfun_result in
          let () = Check.equal (get_type fun_body) fun_result in
          Typedtree.{ fun_name = pfun_name; fun_params; fun_result; fun_body })
        ls
    in
    let desc = Typedtree.TFunctionDec ls in
    desc, { env with funs }

and transTy env t =
  let get_type s =
    Symbol.look env.types s
    |> Core.Option.value_or_thunk ~default:(fun () -> Error.unbound_type s)
  in
  let run = function
    | NameTy n -> get_type n
    | RecordTy fl ->
      let fl =
        List.map (fun { pfd_name; pfd_type; _ } -> pfd_name, get_type pfd_type) fl
      in
      Check.record_fields_umbiguous fl;
      Types.Record (fl, Check.get_unique ())
    | ArrayTy s -> Array (get_type s, Check.get_unique ())
  in
  run t
;;

let trans pexp =
  break_check pexp;
  transExp Env.base_env pexp
;;
