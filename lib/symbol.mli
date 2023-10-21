type t [@@deriving show]

val symbol : string -> t
val name : t -> string
val equal : t -> t -> bool

type 'a table

val empty : 'a table
val enter : 'a table -> t -> 'a -> 'a table
val look : 'a table -> t -> 'a option
