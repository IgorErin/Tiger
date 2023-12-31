(* domen *)
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

val base_venv : Types.t Symbol.table
val base_fenv : fentry Symbol.table
val base_tenv : Types.t Symbol.table
val base_env : env
