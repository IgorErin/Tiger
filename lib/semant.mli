open Env

type expty = { exp : Translate.exp; ty : Types.ty }

val transExp : env -> Ast.exp -> expty
val transDec : env -> Ast.dec -> env
val transTy : env -> Ast.ty -> Types.ty
