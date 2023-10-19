type t = int * string [@@deriving show]

open Base

let count = ref 0
let hashtbl = Hashtbl.create (module String)

let symbol name =
  let default () =
    let result = !count in
    count := result + 1;
    result
  in
  let result = Hashtbl.find_or_add hashtbl name ~default in
  (result, name)

let symbol name : t = (0, name)
let name (_, name) = name

type 'a table = 'a Map.M(Int).t

let empty = Map.empty (module Int)
let enter map (key, _) data = Map.set ~key ~data map
let look map (key, _) = Map.find map key
