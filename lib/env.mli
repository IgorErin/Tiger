(* domen *)
type domen
type fentry = { formals : domen list; result : domen }
type venv = domen Symbol.table
type fenv = fentry Symbol.table
type tenv = domen Symbol.table

val base_venv : domen Symbol.table
val base_fenv : fentry Symbol.table
val base_tenv : domen Symbol.table
val domen_of_type : Types.ty -> domen
val type_of_domen : domen -> Types.ty
