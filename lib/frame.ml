type t = unit
type access = InFrame of int

let new_frame ~name ~formals =
  let () = ignore name in
  let () = ignore formals in
  ()
;;

let alloc_local _ = InFrame 0
