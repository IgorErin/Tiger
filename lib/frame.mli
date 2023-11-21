type t
type access

val new_frame : label:Temp.label -> formals:bool list -> t
val alloc_local : frame:t -> access
val name : t -> Temp.label
val formals : t -> access list
val fp : Temp.temp
val word_size : int
val exp : access -> Ir.exp -> Ir.exp
val call_external : name:string -> args:Ir.exp list -> Ir.exp
