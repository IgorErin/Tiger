type venv = Env.enventry
type tenv = Types.ty Symbol.table
type expty = { exp : Translate.exp; ty : Types.ty }

val transVar : venv -> tenv -> Ast.var -> expty
val transExp : venv -> tenv -> Ast.exp -> expty
val transDec : venv -> tenv -> Ast.dec -> venv * tenv
val transTy : tenv -> Ast.ty -> expty
