type t [@@deriving show]
type access [@@deriving show]

val new_frame : label:Temp.label -> formals:bool list -> t
val alloc_local : frame:t -> access
val name : t -> Temp.label
val formals : t -> access list
val fp : Temp.temp
val rv : Temp.temp
val word_size : int
val exp : acc:access -> fp:Ir.exp -> Ir.exp
val call_external : name:string -> args:Ir.exp list -> Ir.exp
val label : t -> Temp.label
val enter_exit : fr:t -> stm:Ir.stm -> Ir.stm
