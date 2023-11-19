open Env

type error =
  | Unbound_name of string
  | Unbound_type of string
  | Not_a_record of Types.t
  | Not_a_array of Types.t
  | Type_mismatch
  | Umbiguos
  | Unclosed_break

val show_error : error -> string

exception
  Error of
    { error : error
    ; message : string
    }

val transExp : env -> Parsetree.exp -> Typedtree.exp
val transDec : env -> Parsetree.dec -> Typedtree.dec * env
val transTy : env -> Parsetree.type_desc -> Types.t
val trans : Parsetree.exp -> Typedtree.exp
