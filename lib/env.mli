type access
type ty

type enventry =
  | VarEntry of { ty : ty }
  | FunEntry of { formals : ty list; resul : ty }

val base_venv : enventry Symbol.table
val base_tenv : ty Symbol.table
