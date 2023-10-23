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
end

let create_unit_exp ty = { exp = (); ty }
let get_type { ty; _ } = ty
let transVar = failwith ""
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
        |> Check.equal_tr it
        (* and check*)
      in
      let vars = Symbol.enter env.vars name vt in
      { env with vars }
  | VarDec { name; escape = _; typ = None; init } ->
      let it = transExp env init |> get_type in
      let vars = Symbol.enter env.vars name it in
      { env with vars }
  | _ -> failwith "Not implemented"

let transTy = failwith ""
