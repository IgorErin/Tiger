(* domen *)
type fentry = { formals : Types.ty list; result : Types.ty }
type venv = Types.ty Symbol.table
type fenv = fentry Symbol.table
type tenv = Types.ty Symbol.table
type env = { vars : venv; funs : fenv; types : tenv }

val base_venv : Types.ty Symbol.table
val base_fenv : fentry Symbol.table
val base_tenv : Types.ty Symbol.table
val base_env : env
