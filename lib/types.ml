type unique = unit ref

type t =
  | Int
  | String
  | Record of (Symbol.t * t) list * unique
  | Array of t * unique
  | Nil
  | Unit
  | Name of Symbol.t * t option ref

let actual_type t =
  let loop = function
    | Name (_, opt) -> (
        match !opt with Some x -> x | None -> failwith "TDOO")
    | x -> x
  in
  loop t

let equal fst snd =
  match (actual_type fst, actual_type snd) with
  | Int, Int | String, String | Nil, Nil | Unit, Unit -> true
  | Record (_, fst), Record (_, snd) | Array (_, fst), Array (_, snd) ->
      Base.phys_equal fst snd
  | Name _, _ | _, Name _ -> failwith "Name type in equal"
  | _ -> false

let rec show =
  let open Base in
  function
  | Int -> "int"
  | String -> "String"
  | Record (ls, _) ->
      List.map
        ~f:(fun (s, t) ->
          let s = Symbol.name s in
          let t = show t in
          Printf.sprintf "(%s : %s)" s t)
        ls
      |> String.concat ~sep:" "
  | Array (t, _) -> Printf.sprintf "array of %s" @@ show t
  | Nil -> "nil"
  | Unit -> "unit"
  | Name (s, _) -> Printf.sprintf "(Name  %s)" @@ Symbol.name s

let rec pp f =
  let print = Format.fprintf f in
  let sprint = Format.fprintf f "%s" in
  function
  | Int -> sprint "int"
  | String -> sprint "String"
  | Record (ls, _) ->
      List.iter
        (fun (s, t) ->
          sprint "(";
          sprint (Symbol.name s);
          sprint " : ";
          pp f t;
          sprint ")")
        ls
  | Array (t, _) ->
      sprint "array of ";
      pp f t
  | Nil -> sprint "nil"
  | Unit -> sprint "unit"
  | Name (s, _) -> print "(Name  %s)" @@ Symbol.name s
