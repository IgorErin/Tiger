type fentry = { formals : Types.ty list; result : Types.ty }
type venv = Types.ty Symbol.table
type fenv = fentry Symbol.table
type tenv = Types.ty Symbol.table

let base_venv = Symbol.empty
let base_fenv = Symbol.empty
let base_tenv = Symbol.empty
