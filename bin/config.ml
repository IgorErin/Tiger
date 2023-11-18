type config =
  { mutable path : string option
  ; mutable dparsetree : bool
  ; mutable dtypedtree : bool
  }

let default = { path = None; dparsetree = false; dtypedtree = false }
let set_path path = default.path <- Some path
let set_dparsetree () = default.dparsetree <- true
let set_dtypedtree () = default.dtypedtree <- true

let get_path () =
  match default.path with
  | Some path -> path
  | None -> failwith "Path not specifyed"
;;

let is_dparsetree () = default.dparsetree
let is_dtypedtree () = default.dtypedtree
