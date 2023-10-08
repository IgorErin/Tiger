type t [@@deriving show, eq]

val of_string : string -> t
val to_string : t -> string
