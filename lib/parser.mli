type t 

val of_string : string -> t
val parse : t -> (Ast.t, string) Base.Either.t

