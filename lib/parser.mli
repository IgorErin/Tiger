type t

val of_string : string -> t
val parse : t -> (Parsetree.exp, string) Base.Either.t
