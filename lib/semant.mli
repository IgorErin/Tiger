type expty = { exp : Translate.exp; ty : Types.ty }
type env = { vars : Env.venv; funs : Env.fenv; types : Env.tenv }

val transVar : env -> Ast.var -> expty
val transExp : env -> Ast.exp -> expty
val transDec : env -> Ast.dec -> env
val transTy : Env.tenv -> Ast.ty -> expty
