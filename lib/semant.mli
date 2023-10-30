open Env

type expty = { exp : Translate.exp; ty : Types.t }

val transExp : env -> Parsetree.exp -> Typedtree.exp
val transDec : env -> Parsetree.dec -> Typedtree.dec * env
val transTy : env -> Parsetree.type_desc -> Types.t
val trans : Parsetree.exp -> Typedtree.exp
