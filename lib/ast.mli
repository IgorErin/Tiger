(* TODO () how to reference from tests ??? *)

type var =
  | SimpleVar of Id.t
  | FieldVar of var * Id.t
  | SubscriptVar of var * exp
[@@deriving show, eq]

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
