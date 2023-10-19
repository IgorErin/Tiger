type unique = unit ref

type ty =
  | Int
  | String
  | Record of (Symbol.t * ty) list * unique
  | Array of ty * unique
  | Nil
  | Unit
  | Name of Symbol.t * ty option ref
