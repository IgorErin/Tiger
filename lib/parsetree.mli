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
  | IfExp of { test : exp; then_ : exp; else_ : exp option }
  | WhileExp of { test : exp; body : exp }
  | ForExp of {
      var : Symbol.t;
      escape : bool ref;
      lb : exp;
      hb : exp;
      body : exp;
    }
  | BreakExp
  | LetExp of { decs : dec list; body : exp }
  | ArrayExp of { type_ : Symbol.t; size : exp; init : exp }

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
      type_ : Symbol.t option;
      init : exp;
    }
  | TypeDec of typedec list

and fundec = {
  fname : Symbol.t;
  params : field list;
  fresult : Symbol.t option;
  body : exp;
}

and typedec = { td_name : Symbol.t; td_type : type_desc }

and type_desc =
  | NameTy of Symbol.t
  | RecordTy of field list
  | ArrayTy of Symbol.t

and field = { fd_name : Symbol.t; fd_escape : bool ref; fd_type : Symbol.t }
