open Env

type expty = { exp : Translate.exp; ty : Types.t }

val transExp : env -> Parsetree.exp -> expty
val transDec : env -> Parsetree.dec -> env
val transTy : env -> Parsetree.type_desc -> Types.t
val type_check : Parsetree.exp -> unit
