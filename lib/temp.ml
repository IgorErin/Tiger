type temp = string * int [@@deriving show]
type label = string * int [@@deriving show]

let incr r = r := !r + 1
let temp_count = ref 0
let lable_count = ref 0

let new_tempn name =
  let temp = name, !temp_count in
  incr temp_count;
  temp
;;

let new_temp () = new_tempn "T"
let temp_to_string (name, number) = Printf.sprintf "%s%d" name number

let new_labeln name =
  let lable = name, !lable_count in
  incr lable_count;
  lable
;;

let new_label () = new_labeln "L"
let label_to_string (name, number) = Printf.sprintf "%s_%d" name number
