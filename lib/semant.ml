open Ast

type expty = { exp : Translate.exp; ty : Types.ty }
type env = { vars : Env.venv; funs : Env.fenv; types : Env.tenv }

module Check = struct
  let int = function Types.Int -> Types.Int | _ -> failwith "Type must be Int"

  let unit = function
    | Types.Unit -> Types.Unit
    | _ -> failwith "Type must be Unit"

  let equal fst snd =
    if Types.equal fst snd then fst else failwith "Types must be equal"

  let equal3 fst snd thd =
    if Types.equal fst snd && Types.equal snd thd then fst
    else failwith "Types must be equal"
end

let create_unit_exp ty = { exp = (); ty }
let get_type { ty; _ } = ty
let transVar = failwith ""

let transExp env expr =
  let rec trexp = function
    | VarExp v -> transVar env v (* TODO *)
    | NilExp -> create_unit_exp Types.Nil
    | IntExp _ -> create_unit_exp Types.Int
    | StringExp _ -> create_unit_exp Types.String
    | CallExp _ -> failwith ""
    | OpExp { left; oper = _; right } ->
        let _ = trexp left |> get_type |> Check.int in
        let _ = trexp right |> get_type |> Check.int in
        create_unit_exp Types.Int
    | SeqExp ls ->
        if List.length ls = 0 then create_unit_exp Unit
        else
          (* take last exp type. mb check that before unit's ? *)
          List.rev ls |> List.hd |> trexp
    | AssignExp { var; exp } ->
        let v = transVar env var |> get_type in
        let e = trexp exp |> get_type in
        Check.equal v e |> create_unit_exp
    | IfExp { test; then'; else' } -> (
        let _ = trexp test |> get_type |> Check.int in
        let t = trexp then' |> get_type in
        match else' with
        | Some else' ->
            let e = trexp else' |> get_type in
            Check.equal t e |> create_unit_exp
        | None -> Check.unit t |> create_unit_exp)
    | WhileExp { test; body } ->
        let _ = trexp test |> get_type |> Check.int in
        let _ = trexp body |> get_type |> Check.unit in
        create_unit_exp Types.Unit
    | ForExp { var; escape = _; lo; hi; body } ->
        let var = transVar env var in
        (* TODO handle var type *)
        let lo = trexp lo |> get_type in
        let hi = trexp hi |> get_type in
        let _ = trexp body |> get_type |> Check.unit in
        Check.equal3 var lo hi |> create_unit_exp
    | BreakExp -> Types.Unit |> create_unit_exp
    | _ -> failwith "Not implemented"
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
      | _ -> failwith "Fields contain only records"
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

let transDec = failwith ""
let transTy = failwith ""
