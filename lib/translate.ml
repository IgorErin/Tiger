type exp = unit

type level = { nlevel : int }
and access = level * Frame.access

let outermost = { nlevel = 0 }

let new_level ~parent name formals =
  let formals = true :: formals in
  let faccess = Frame.new_frame ~name ~formals in
  { nlevel = Int.succ parent.nlevel }
;;

let formals () = ()
let alloc_local level esc = level, Frame.alloc_local esc
