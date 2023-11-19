type t
type access

val new_frame : name:Temp.label -> formals:bool list -> t
val alloc_local : bool -> access
