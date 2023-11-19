type temp = string * int
type label = string * int

let incr r = r := !r + 1
let temp_count = ref 0
let lable_count = ref 0

let new_tempn name =
  let temp = name, !temp_count in
  incr temp_count;
  temp
;;

let new_temp () = new_tempn "temp"
let temp_to_string (name, number) = Printf.sprintf "%s_%d" name number

let new_labeln name =
  let lable = name, !lable_count in
  incr lable_count;
  lable
;;

let new_lable () = new_labeln "lable"
let lable_to_string (name, number) = Printf.sprintf "%s_%d" name number
