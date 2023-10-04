type var =
  | SimpleVar of Id.t
  | FieldVar of var * Id.t
  | SubscriptVar of var * exp
[@@deriving show]

and exp =
  | VarExp of var
  | NilExp
  | IntExp of int
  | StringExp of string
  | CallExp of { func : Id.t; args : exp list }
  | OpExp of { left : exp; oper : oper; right : exp }
  | SeqExp of exp list
  | AssignExp of { var : Id.t; exp : exp }
  | IfExp of { test : exp; then' : exp; else' : exp option }
  | WhileExp of { test : exp; body : exp }
  | ForExp of { var : Id.t; escape : bool ref; lo : exp; hi : exp; body : exp }
  | BreakExp
  | LetExp of { decs : dec list; body : exp }
  | ArrayExp of { typ : Id.t; size : exp; init : exp }

and oper =
  | PlusOp
  | MinusOp
  | TimesOp
  | DivideOp
  | EqOp
  | NeqOp
  | LtOp
  | LeOp
  | GtOp
  | GeOp

and dec =
  | FunctionDec of fundec list
  | VarDec of { name : Id.t; escape : bool ref; typ : Id.t option; init : exp }
  | TypeDec of typedec list

and fundec = {
  fname : Id.t;
  params : field list;
  result : Id.t option;
  body : exp;
}

and typedec = { tname : Id.t; ty : ty }
and ty = NameTy of Id.t | RecordTy of field list | ArrayTy of Id.t
and field = { name : Id.t; escape : bool ref; typ : Id.t }

let rec var_equal left right =
  match (left, right) with
  | SimpleVar l, SimpleVar r -> Id.( = ) l r
  | FieldVar (lVar, lId), FieldVar (rVar, rId) ->
      var_equal lVar rVar && Id.( = ) lId rId
  | SubscriptVar (lVar, lExp), SubscriptVar (rVar, rExp) ->
      var_equal lVar rVar && exp_equal lExp rExp
  | SimpleVar _, _ | FieldVar (_, _), _ | SubscriptVar (_, _), _ -> false

and oper_equal left right =
  match (left, right) with
  | PlusOp, PlusOp -> true
  | MinusOp, MinusOp -> true
  | TimesOp, TimesOp -> true
  | DivideOp, DivideOp -> true
  | EqOp, EqOp -> true
  | NeqOp, NeqOp -> true
  | LtOp, NeqOp -> true
  | LeOp, LeOp -> true
  | GtOp, GtOp -> true
  | GeOp, GeOp -> true
  | PlusOp, _
  | MinusOp, _
  | TimesOp, _
  | DivideOp, _
  | EqOp, _
  | NeqOp, _
  | LtOp, _
  | LeOp, _
  | GtOp, _
  | GeOp, _ ->
      false

and exp_equal left right =
  match (left, right) with
  | VarExp l, VarExp r -> var_equal l r
  | NilExp, NilExp -> true
  | _ -> false (* TODO *)

and dec_equal _ _ = false
and fundec_equal _ _ = false
and typedec_equal _ _ = false
and ty_equla _ _ = false
and field_equal _ _ = false
