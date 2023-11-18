type t = unit

type access =
  | InReg of int
  | InFrame of int

let new_frame ~name ~formals =
  let () = ignore name in
  let () = ignore formals in
  ()
;;

let _ = InReg 0
let _ = InFrame 0
