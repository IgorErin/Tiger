open Ast

type expty = { exp : Translate.exp; ty : Types.ty }
type env = { vars : Env.venv; funs : Env.fenv; types : Env.tenv }

module Check = struct
  let int = function Types.Int -> Types.Int | _ -> failwith "Type must be Int"

  let unit = function
    | Types.Unit -> Types.Unit
    | _ -> failwith "Type must be Unit"

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
let get_type { ty; _ } = ty
let transVar _ = failwith ""
let ( >> ) f g x = f x |> g

let rec transExp (env : env) _ =
  let rec trexp = function
    | VarExp v -> trvar env.types v (* TODO *)
    | NilExp -> create_unit_exp Types.Nil
    | IntExp _ -> create_unit_exp Types.Int
    | StringExp _ -> create_unit_exp Types.String
    | CallExp { func; args } -> (
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
    | OpExp { left; oper = _; right } ->
        let _ = trexp left |> get_type |> Check.int in
        let _ = trexp right |> get_type |> Check.int in
        create_unit_exp Types.Int
    | SeqExp ls ->
        if List.length ls = 0 then create_unit_exp Unit
        else
          (* take last exp type. mb check that before unit's ? *)
          List.rev ls |> List.hd |> trexp
    | AssignExp { var; exp } -> (
        let rty = trexp exp |> get_type in
        let lty = Symbol.look env.vars var in
        match lty with
        | Some lty ->
            let _ = Check.equal lty rty in
            Types.Unit |> create_unit_exp
        | None -> failwith "TODO")
    | IfExp { test; then'; else' } -> (
        let _ = trexp test |> get_type |> Check.int in
        let t = trexp then' |> get_type in
        match else' with
        | Some else' ->
            let e = trexp else' |> get_type in
            Check.equal_tr t e |> create_unit_exp
        | None -> Check.unit t |> create_unit_exp)
    | WhileExp { test; body } ->
        let _ = trexp test |> get_type |> Check.int in
        let _ = trexp body |> get_type |> Check.unit in
        create_unit_exp Types.Unit
    | ForExp { var; escape = _; lo; hi; body } ->
        let vart =
          let lot = trexp lo |> get_type in
          let hit = trexp hi |> get_type in
          Check.equal_tr lot hit
        in
        let vars = Symbol.enter env.vars var vart in
        let bodyt = transExp { env with vars } body |> get_type in
        Check.unit bodyt |> create_unit_exp
    | BreakExp -> Types.Unit |> create_unit_exp
    | LetExp { decs = _; body = _ } -> failwith "TODO decs"
    | ArrayExp { typ; size; init } -> (
        let _ = trexp size |> get_type |> Check.int in
        let it = trexp init |> get_type in
        let at = Symbol.look env.types typ in
        match at with
        | Some (Types.Array (ty, _) as at) ->
            let _ = Check.equal it ty in
            at |> create_unit_exp
        | Some _ -> failwith "Must be array type."
        | None -> failwith "Array type. Not found.")
  and trvar venv v =
    let field_type t m =
      match t with
      | Types.Record (ls, _) -> (
          let sameSymbol = List.filter (fun (s, _) -> Symbol.equal s m) ls in
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

  failwith ""

and transDec env = function
  | VarDec { name; escape = _; typ = Some typ; init } ->
      let it = transExp env init |> get_type in
      let vt =
        Symbol.look env.types typ
        |> (function Some typ -> typ | None -> failwith "Unknown var type")
        |> Check.nil_record_constr it
      in
      let vars = Symbol.enter env.vars name vt in
      { env with vars }
  | VarDec { name; escape = _; typ = None; init } ->
      let it = transExp env init |> get_type in
      let vars = Symbol.enter env.vars name it in
      { env with vars }
  | TypeDec [ { tname; ty } ] ->
      let ty = transTy env ty in
      let types = Symbol.enter env.types tname ty in
      { env with types }
  | TypeDec ls ->
      let open Types in
      let add env name t = Symbol.enter env name t in
      let names = List.map (fun { tname; ty = _ } -> tname) ls in
      let types =
        List.fold_left
          (fun env tname ->
            let ty = Name (tname, ref None) in
            add env tname ty)
          env.types names
      in
      failwith "TODO(rec types ???)"
  | FunctionDec ls ->
      let open Types in
      (* helpers*)
      let ty_of_opt = function
        | Some t -> t
        | _ -> failwith "Type not found."
      in
      let ty_of_symbol s = Symbol.look env.types s |> ty_of_opt in
      let map_result = function Some t -> ty_of_symbol t | None -> Unit in
      let map_param x = ty_of_symbol x.Ast.typ in
      (* create env.funs be heads *)
      let funs =
        List.fold_left
          (fun funs { fname; params; result; _ } ->
            let formals = List.map map_param params in
            let result = map_result result in
            Symbol.enter funs fname Env.{ formals; result })
          env.funs ls
      in
      (* map params to new env.vars *)
      let mod_vars params =
        List.fold_left
          (fun vars { name; typ; _ } ->
            let ty = ty_of_symbol typ in
            Symbol.enter vars name ty)
          env.vars params
      in
      (* travers body, check return type *)
      let _ =
        List.iter
          (fun { body; result; params; _ } ->
            (* for each funs
               1) add params and funs to env.vars
               2) check body
               3) compare body and result type *)
            let vars = mod_vars params in
            let env = { env with funs; vars } in
            let bt = transExp env body |> get_type in
            let rt = map_result result in
            Check.equal bt rt)
          ls
      in
      { env with funs }

and transTy env t =
  let ty_of_opt = function Some x -> x | None -> failwith "Unknon type" in
  let get_type env s = ty_of_opt @@ Symbol.look env.types s in
  (* simplify code *)
  let run = function
    | NameTy n -> (
        Symbol.look env.types n |> function
        | Some x -> x
        | None -> failwith "Unknon type")
    | RecordTy fl ->
        let fl =
          List.map (fun { name; typ; _ } -> (name, get_type env typ)) fl
        in
        let unique = Check.get_unique () in
        Types.Record (fl, unique)
    | ArrayTy s ->
        let t = get_type env s in
        let unique = Check.get_unique () in
        Array (t, unique)
  in
  run t
