open Base

type unique = unit ref

type ty =
  | Int
  | String
  | Record of (Symbol.t * ty) list * unique
  | Array of ty * unique
  | Nil
  | Unit
  | Name of Symbol.t * ty option ref

let equal fst snd =
  match (fst, snd) with
  | Int, Int | String, String | Nil, Nil | Unit, Unit -> true
  | Record (_, fst), Record (_, snd) | Array (_, fst), Array (_, snd) ->
      phys_equal fst snd
  | Name _, Name _ -> failwith "I dont know"
  | _ -> false
