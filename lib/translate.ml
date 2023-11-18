type exp = unit
type level
type access = level * Frame.access
type venv = access Symbol.table

type fentry =
  { level : level
  ; label : unit
  ; formals : Types.t list
  }

type fenv = fentry Symbol.table

let outermost = ()
let new_level = ()
let formals () = ()
let alloc_local () () = ()
