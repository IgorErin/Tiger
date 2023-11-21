type unique = unit ref

type t =
  | Int
  | String
  | Record of (Symbol.t * t) list * unique
  | Array of t * unique
  | Nil
  | Unit
  | Name of Symbol.t * t option ref

let is_unit = function
  | Unit -> true
  | _ -> false
;;

let is_string = function
  | String -> true
  | _ -> false
;;

let rec show =
  let open Base in
  function
  | Int -> "int"
  | String -> "String"
  | Record (ls, _) ->
    let body =
      List.map
        ~f:(fun (s, t) ->
          let s = Symbol.name s in
          let t = show t in
          Printf.sprintf "(%s : %s);" s t)
        ls
      |> String.concat ~sep:" "
    in
    "{" ^ body ^ "}"
  | Array (t, _) -> Printf.sprintf "array of %s" @@ show t
  | Nil -> "nil"
  | Unit -> "unit"
  | Name (s, _) -> Printf.sprintf "(Name  %s)" @@ Symbol.name s
;;

let rec pp f =
  let print = Format.fprintf f in
  let sprint = Format.fprintf f "%s" in
  function
  | Int -> sprint "int"
  | String -> sprint "string"
  | Record (ls, _) ->
    sprint "{";
    List.iter
      (fun (s, t) ->
        sprint "(";
        sprint (Symbol.name s);
        sprint " : ";
        pp f t;
        sprint ")")
      ls;
    sprint "}"
  | Array (t, _) ->
    sprint "array of ";
    pp f t
  | Nil -> sprint "nil"
  | Unit -> sprint "unit"
  | Name (s, _) -> print "(Name  %s)" @@ Symbol.name s
;;

let actual_type t =
  let rec loop = function
    | Name (_, opt) ->
      (match !opt with
       | Some x -> loop x
       | None -> failwith @@ Printf.sprintf "Unseted type %s" @@ show t)
    | x -> x
  in
  loop t
;;

let equal fst snd =
  (* if type is cycle actual_type goes to infinet loop *)
  match actual_type fst, actual_type snd with
  | Int, Int | String, String | Nil, Nil | Unit, Unit -> true
  | Record (_, fst), Record (_, snd) | Array (_, fst), Array (_, snd) ->
    Base.phys_equal fst snd
  | Name _, _ | _, Name _ -> failwith "Name type in equal"
  | _ -> false
;;
