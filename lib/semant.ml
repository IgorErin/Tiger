module Env = struct
  open Translate

  type venv = access Symbol.table

  type fentry =
    { level : Translate.level
    ; label : unit
    ; formals : Types.t list
    }

  type fenv = fentry Symbol.table
end
