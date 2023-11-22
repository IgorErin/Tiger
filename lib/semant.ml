module Env = struct
  type fenv = Translate.Level.t Symbol.table
  type venv = Translate.Access.t Symbol.table

  type ctx =
    { fenv : fenv
    ; venv : venv
    ; level : Translate.Level.t
    ; done_label : Temp.label option
    }

  type frag =
    | String of Temp.label * string
    | Fun of Ir.stm * Translate.Level.t

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

  let add_done ~ctx ~l = { ctx with done_label = Some l }

  let get_done ~ctx =
    ctx.done_label
    |> Core.Option.value_or_thunk ~default:(fun () -> failwith "Empty done label")
  ;;

  let level ctx = ctx.level
  let add mls item = mls := item :: !mls
  let empty : frag list ref = ref []
end

module Common = struct
  let filter_typed =
    let open Typedtree in
    function
    | TVarDec { name; init; _ } -> Some (`Var (name, init))
    | TFunctionDec x -> Some (`Fun x)
    | TTypeDec _ -> None
  ;;
end

let exp =
  let open Typedtree in
  let module P = Parsetree in
  let module T = Translate in
  let fragments : Env.frag list ref = ref [] in
  let add_fragment = Env.add fragments in
  let rec run_exp (ctx : Env.ctx) exp =
    let type_ = exp.exp_type in
    match exp.exp_desc with
    | TVarExp var -> run_var ctx var
    | TNilExp -> T.nill
    | TIntExp value -> T.int value
    | TStringExp string ->
      let lb = Temp.new_label () in
      add_fragment (String (lb, string));
      T.String.const ~lb
    | TCallExp { func; args } ->
      let fl = Env.flook ctx func in
      let cl = ctx.level in
      let args = List.map (run_exp ctx) args in
      T.fcall ~fl ~cl ~args ~t:type_
    | TOpExp { left; oper; right } ->
      let left = run_exp ctx left |> T.Exp.to_exp in
      let right = run_exp ctx right |> T.Exp.to_exp in
      (* string comprasion, etc TODO *)
      (match oper with
       | #P.arithm as oper -> T.Int.op_aritm ~left ~oper ~right
       | #P.relational as oper -> T.Int.op_rel ~left ~oper ~right)
    | TSeqExp seq ->
      let seq = seq |> List.map (run_exp ctx) |> List.map T.Exp.to_exp in
      T.seq seq
    | TAssignExp { var; exp } ->
      let var = run_var ctx var |> T.Exp.to_exp in
      let exp = run_exp ctx exp |> T.Exp.to_exp in
      T.assign ~name:var ~exp
    | TIfExp { test; then_; else_ = Some else_ } ->
      let test = run_exp ctx test |> T.Exp.to_jump in
      let then_ = run_exp ctx then_ |> T.Exp.to_exp in
      let else_ = run_exp ctx else_ |> T.Exp.to_exp in
      T.if_else ~test ~then_ ~else_
    | TIfExp { test; then_; else_ = None } ->
      let test = run_exp ctx test in
      let then_ = run_exp ctx then_ in
      T.if_ ~test ~then_
    | TWhileExp { test; body } ->
      let test = run_exp ctx test in
      let dl = Temp.new_label () in
      let ctx = Env.add_done ~ctx ~l:dl in
      let body = run_exp ctx body in
      T.while_ ~test ~body ~dl
    | TForExp { lb; hb; body; _ } ->
      let lb = run_exp ctx lb in
      let hb = run_exp ctx hb in
      let dl = Temp.new_label () in
      let ctx = Env.add_done ~ctx ~l:dl in
      let body = run_exp ctx body in
      T.for_ ~lb ~hb ~body ~dl
    | TBreakExp -> T.break ~l:(Env.get_done ~ctx)
    | TLetExp { decs; body } ->
      decs
      |> List.fold_left
           (fun ((ctx, inits) as default) next ->
             run_dec ctx next
             |> Option.map (fun (ctx, init) -> ctx, init :: inits)
             |> Option.value ~default)
           (ctx, [])
      |> fun (ctx, inits) ->
      let body = run_exp ctx body in
      let inits = List.rev inits in
      T.let_in ~inits ~body
    | TArrayExp { type_ = __; size; init } ->
      let size = run_exp ctx size in
      let init = run_exp ctx init in
      T.Array.alloc ~init ~size
    | TRecordExp { type_ = _; fields } ->
      let exps = fields |> List.map (fun (_, _, exp) -> run_exp ctx exp) in
      T.Record.alloc exps
  and run_dec ctx = function
    | TVarDec { name; init; _ } ->
      let init = run_exp ctx init in
      let access = T.alloc_local ctx.level in
      let ctx = Env.addv ctx name access in
      let exp = T.simple_var ~access ~level:ctx.level in
      Some (ctx, exp)
    | TFunctionDec ls ->
      ls
      |> List.iter (fun { fun_body; fun_params; _ } ->
        let formals = List.map (fun _ -> false) fun_params in
        let lb = Temp.new_label () in
        let lv = Translate.Level.new_level ~prev:ctx.level ~label:lb ~formals in
        let body = run_exp ctx fun_body in
        let result = T.fun_ ~level:lv ~body in
        add_fragment (Fun (result, lv)));
      None
    | TTypeDec _ -> None
  and run_var ctx var =
    let type_ = var.var_type in
    match var.var_desc with
    | TSimpleVar var ->
      let access = Env.vlook ctx var in
      let level = Env.level ctx in
      T.simple_var ~access ~level
    | TFieldVar (var, number) ->
      let var = run_var ctx var |> T.Exp.to_exp |> T.null_check in
      T.field_var ~var ~number
    | TSubscriptVar (var, exp) ->
      let exp = run_exp ctx exp in
      let var = run_var ctx var |> T.Exp.to_exp |> T.null_check in
      T.subscript_var ~var_exp:var ~index_exp:exp
  in
  ()
;;
