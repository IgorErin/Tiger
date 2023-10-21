type domen = Types.ty
type fentry = { formals : Types.ty list; result : Types.ty }
type venv = domen Symbol.table
type fenv = fentry Symbol.table
type tenv = domen Symbol.table

let base_venv = Symbol.empty
let base_fenv = Symbol.empty
let base_tenv = Symbol.empty
let domen_of_type x = x
let type_of_domen x = x
