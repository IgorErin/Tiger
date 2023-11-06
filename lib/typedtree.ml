type var_desc =
  | TSimpleVar of Symbol.t
  | TFieldVar of var * Symbol.t
  | TSubscriptVar of var * exp
[@@deriving show]

and var = { var_desc : var_desc; var_type : Types.t }

and exp_desc =
  | TVarExp of var
  | TNilExp
  | TIntExp of int
  | TStringExp of string
  | TCallExp of { func : Symbol.t; args : exp list }
  | TOpExp of { left : exp; oper : Parsetree.oper; right : exp }
  | TSeqExp of exp list
  | TAssignExp of { var : var; exp : exp }
  | TIfExp of { test : exp; then_ : exp; else_ : exp option }
  | TWhileExp of { test : exp; body : exp }
  | TForExp of {
      var : Symbol.t;
      escape : bool ref;
      lb : exp;
      hb : exp;
      body : exp;
    }
  | TBreakExp
  | TLetExp of { decs : dec list; body : exp }
  | TArrayExp of { type_ : Types.t; size : exp; init : exp }
  | TRecordExp of { type_ : Types.t; fields : (Symbol.t * Types.t * exp) list }
[@@deriving show]

and exp = { exp_desc : exp_desc; exp_type : Types.t }

and dec =
  | TFunctionDec of fundec list
  | TVarDec of {
      name : Symbol.t;
      escape : bool ref;
      type_ : Types.t;
      init : exp;
    }
  | TTypeDec of typedec list

and fundec = {
  fun_name : Symbol.t;
  fun_params : field list;
  fun_result : Types.t;
  fun_body : exp;
}

and typedec = { td_name : Symbol.t; td_type : Types.t }
and field = { fd_name : Symbol.t; fd_escape : bool ref; fd_type : Types.t }
