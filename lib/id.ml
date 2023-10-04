type t = string [@@deriving show]

let of_string x = x
let to_string x = x
let ( = ) = String.equal
