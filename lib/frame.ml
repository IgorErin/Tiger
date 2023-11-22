type access = InFrame of int

type t =
  { label : Temp.label
  ; formals : access list
  ; mutable locals_count : int
  }

let inc_locals frame = { frame with locals_count = frame.locals_count + 1 }

let alloc_local ~frame =
  let result = InFrame (-frame.locals_count) in
  frame.locals_count <- frame.locals_count - 1;
  result
;;

let name { label; _ } = label

let new_frame ~label ~formals =
  (* all in stack *)
  let f = { label; formals = []; locals_count = 0 } in
  List.iter
    (fun _ ->
      let _ = alloc_local ~frame:f in
      ())
    formals;
  f
;;

let formals { formals; _ } = formals
let fp = Temp.new_temp ()
let word_size = 32 (* for now *)

let exp ~acc:(InFrame offset) ~fp:e =
  let open Ir in
  mem @@ binop e Plus @@ const offset
;;

let create_name name = Temp.new_labeln name

let call_external ~name ~args =
  let fname = create_name name in
  Ir.(call (name fname) args)
;;

let label { label; _ } = label
