open Base

type unique = unit ref [@@deriving show]

type t =
  | Int
  | String
  | Record of (Symbol.t * t) list * unique
  | Array of t * unique
  | Nil
  | Unit
  | Name of Symbol.t * t option ref
[@@deriving show]

let equal fst snd =
  match (fst, snd) with
  | Int, Int | String, String | Nil, Nil | Unit, Unit -> true
  | Record (_, fst), Record (_, snd) | Array (_, fst), Array (_, snd) ->
      phys_equal fst snd
  | Name _, _ | _, Name _ -> failwith "Name type in equal"
  | _ -> false
