open Env

type expty = { exp : Translate.exp; ty : Types.ty }

val transExp : env -> Parsetree.exp -> expty
val transDec : env -> Parsetree.dec -> env
val transTy : env -> Parsetree.ty -> Types.ty
val type_check : Parsetree.exp -> unit
