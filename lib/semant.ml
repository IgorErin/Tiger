module Env = struct
  type fenv = Translate.Level.t Symbol.table
  type venv = Translate.Access.t Symbol.table

  type ctx =
    { fenv : fenv
    ; venv : venv
    ; level : Translate.Level.t
    }

  let addf ctx symbol level = { ctx with fenv = Symbol.enter ctx.fenv symbol level }
  let addv ctx symbol access = { ctx with venv = Symbol.enter ctx.venv symbol access }

  let vlook ctx symbol =
    Symbol.look ctx.venv symbol
    |> Core.Option.value_or_thunk ~default:(fun () ->
      failwith @@ Printf.sprintf "Not found access for var %s" @@ Symbol.name symbol)
  ;;

  let flook ctx symbol =
    Symbol.look ctx.fenv symbol
    |> Core.Option.value_or_thunk ~default:(fun () ->
      failwith @@ Printf.sprintf "Not found access for fun %s" @@ Symbol.name symbol)
  ;;

  let level ctx = ctx.level
end

open Env

let exp =
  let open Typedtree in
  (* let rec run_exp ctx exp = 
    match exp.exp_desc with 
    | TVarExp var -> run_var var 
    | TNilExp -> ctx
    | TIntExp _ -> ctx
    | TStringExp _ -> ctx 
    | TCallExp {func; args} -> List.fold_left run_exp ctx args 
    | TOpExp{left;oper; right} -> 
      let left = run_exp ctx left in 
      let right = run_exp ctx right in 
      right 
    | TSeqExp seq -> 
      List.fold_left run_exp ctx seq 
    | TAssignExp {var; exp} -> run_exp exp ctx 
    |TIfExp {test; then_; else_ = Some else_} -> 
      let test = run_exp ctx test in 
      let then_ = run_exp ctx then_ in 
      let else_ = run_exp ctx else_ in 
      else_
    |TIfExp {test; then_; else_ = None_} -> 
      let test = run_exp ctx test in 
      let then_ = run_exp ctx then_ in 
      then_
    | TWhileExp {test; body} -> 
      let test = run_exp ctx test in 
      run_exp ctx body 
    | TForExp {lb; hb; body;_ } -> 
      let lb = run_exp ctx lb in 
      let hb = run_exp ctx hb in 
      run_exp ctx body 
    | TBreakExp -> ctx 
    | TLetExp { decs; body = _ } -> decs |> List.fold_left run_dec ctx
    | TArrayExp {type_ = __; size; init } -> 
      let size = run_exp ctx size in 
      let init = run_exp ctx init in 
    init 
    | TRecordExp {type_ = _; fields = _} -> 
      ctx  
  and run_var ctx var =
    match var.var_desc with 
    | TSimpleVar _ -> ctx 
    | TSubscriptVar (var, exp) -> 
      run_exp ctx exp; run_var ctx var 
    | TFieldVar(var, exp) -> 
      run_exp ctx exp; run_var ctx  var *)
  let rec run_exp _ _ = failwith ""
  and run_dec ctx = function
    | TFunctionDec fls ->
      fls (* TODO *)
      |> List.fold_left
           (fun ctx { fun_name; fun_params; fun_body; _ } ->
             let level =
               let formals = List.map (fun _ -> true) fun_params in
               let label = Temp.new_label () in
               Translate.Level.new_level ~prev:ctx.level ~label ~formals
             in
             let ctx = { ctx with level } in
             let ctx = Env.addf ctx fun_name level in
             let _ = run_exp ctx fun_body in
             ctx)
           ctx
    | TVarDec { name; init; _ } ->
      let _ = run_exp ctx init in
      let access = Translate.alloc_local ctx.level in
      Env.addv ctx name access
    | TTypeDec _ -> ctx
  and run_var ctx var =
    let type_ = var.var_type in
    match var.var_desc with
    | TSimpleVar var ->
      let access = Env.vlook ctx var in
      let level = Env.level ctx in
      Translate.simple_var ~access ~level
    | TFieldVar (var, number) ->
      let var = run_var ctx var |> Translate.Exp.to_exp |> Translate.null_check in
      Translate.field_var ~var ~number
    | TSubscriptVar (var, exp) ->
      let exp = run_exp ctx exp in
      let var = run_var ctx var |> Translate.Exp.to_exp |> Translate.null_check in
      Translate.subscript_var ~var_exp:var ~index_exp:exp
  in
  ()
;;
