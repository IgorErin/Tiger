type fentry =
  { formals : Types.t list
  ; result : Types.t
  }

type venv = Types.t Symbol.table
type fenv = fentry Symbol.table
type tenv = Types.t Symbol.table

type env =
  { vars : venv
  ; funs : fenv
  ; types : tenv
  }

let enter_tr s i tbl = Symbol.enter tbl s i
let base_venv = Symbol.empty

let base_fenv =
  let open Types in
  Symbol.empty
  |> enter_tr (Symbol.symbol "print") { formals = [ Types.String ]; result = Types.Unit }
  |> enter_tr (Symbol.symbol "flush") { formals = []; result = Types.Unit }
  |> enter_tr (Symbol.symbol "getchar") { formals = []; result = Types.String }
  |> enter_tr (Symbol.symbol "ord") { formals = [ Types.String ]; result = Types.Int }
  |> enter_tr (Symbol.symbol "chr") { formals = [ Types.Int ]; result = Types.String }
  |> enter_tr (Symbol.symbol "size") { formals = [ Types.String ]; result = Types.Int }
  |> enter_tr
       (Symbol.symbol "substring")
       { formals = [ Types.String; Types.Int; Int ]; result = String }
  |> enter_tr
       (Symbol.symbol "concat")
       { formals = [ Types.String; String ]; result = String }
  |> enter_tr (Symbol.symbol "not") { formals = [ Types.Int ]; result = Types.Int }
  |> enter_tr (Symbol.symbol "exit") { formals = [ Types.Int ]; result = Types.Unit }
;;

let base_tenv =
  Symbol.empty
  |> enter_tr (Symbol.symbol "int") Types.Int
  |> enter_tr (Symbol.symbol "string") Types.String
;;

let base_env = { vars = base_venv; funs = base_fenv; types = base_tenv }
