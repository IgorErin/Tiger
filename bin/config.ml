type config = { mutable path : string option; mutable dparsetree : bool }

let default = { path = None; dparsetree = false }
let set_path path = default.path <- Some path
let dump_parse_tree () = default.dparsetree <- true

let get_path () =
  match default.path with
  | Some path -> path
  | None -> failwith "Path not specifyed"
