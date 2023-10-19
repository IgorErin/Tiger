(* TODO () how to reference from tests ??? *)

type var =
  | SimpleVar of Symbol.t
  | FieldVar of var * Symbol.t
  | SubscriptVar of var * exp
[@@deriving show]

and exp =
  | VarExp of var
  | NilExp
  | IntExp of int
  | StringExp of string
  | CallExp of { func : Symbol.t; args : exp list }
  | OpExp of { left : exp; oper : oper; right : exp }
  | SeqExp of exp list
  | AssignExp of { var : Symbol.t; exp : exp }
  | IfExp of { test : exp; then' : exp; else' : exp option }
  | WhileExp of { test : exp; body : exp }
  | ForExp of {
      var : Symbol.t;
      escape : bool ref;
      lo : exp;
      hi : exp;
      body : exp;
    }
  | BreakExp
  | LetExp of { decs : dec list; body : exp }
  | ArrayExp of { typ : Symbol.t; size : exp; init : exp }

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
  | VarDec of {
      name : Symbol.t;
      escape : bool ref;
      typ : Symbol.t option;
      init : exp;
    }
  | TypeDec of typedec list

and fundec = {
  fname : Symbol.t;
  params : field list;
  result : Symbol.t option;
  body : exp;
}

and typedec = { tname : Symbol.t; ty : ty }
and ty = NameTy of Symbol.t | RecordTy of field list | ArrayTy of Symbol.t
and field = { name : Symbol.t; escape : bool ref; typ : Symbol.t }
