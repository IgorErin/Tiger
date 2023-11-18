type t = string

module type Sig = sig
  val lol : unit -> unit
end

module Make (X : Sig) = struct
  let lol = X.lol
end

let new_temp () = ""
let to_string str = str
let new_lable () = ""
