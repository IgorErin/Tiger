type access = InFrame of int [@@deriving show]

type t =
  { label : Temp.label
  ; formals : access list
  ; mutable locals_count : int
  }
[@@deriving show]

let inc_locals frame = { frame with locals_count = frame.locals_count + 1 }
let word_size = 4

let alloc_access frame =
  let result = InFrame (-frame.locals_count * word_size) in
  frame.locals_count <- frame.locals_count - 1;
  result
;;

let alloc_local ~frame = alloc_access frame
let name { label; _ } = label

let new_frame ~label ~formals =
  let in_frm_count = List.length formals in
  let formals = List.mapi (fun index _ -> InFrame (-index * word_size)) formals in
  { label; formals; locals_count = in_frm_count }
;;

let formals { formals; _ } = formals
let fp = Temp.new_tempn "FP"
let rv = Temp.new_labeln "RV"

let exp ~acc:(InFrame offset) ~fp:e =
  let open Ir in
  if Int.equal 0 offset then mem e else mem @@ binop e Plus @@ const offset
;;

let create_name name = Temp.new_labeln name

let call_external ~name ~args =
  let fname = create_name name in
  Ir.(call (name fname) args)
;;

let label { label; _ } = label

let enter_exit ~fr ~stm =
  let _ = fr in
  stm
;;
