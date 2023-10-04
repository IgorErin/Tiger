type t [@@deriving show]

val of_string : string -> t
val to_string : t -> string
val ( = ) : t -> t -> bool
