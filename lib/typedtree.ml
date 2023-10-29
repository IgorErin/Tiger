type exp_desc =
  | TVarExp of Parsetree.var
  | TNilExp
  | TIntExp of int
  | TStringExp of string
  | TCallExp of { func : Symbol.t; args : exp list }
  | TOpExp of { left : exp; oper : Parsetree.oper; right : exp }
  | TSeqExp of exp list
  | TAssignExp of { var : Symbol.t; exp : exp }
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
  | TArrayExp of { type_ : Symbol.t; size : exp; init : exp }
[@@deriving show]

and exp = { exp_desc : exp_desc; exp_type : Types.t }

and dec =
  | TFunctionDec of fundec list
  | TVarDec of {
      name : Symbol.t;
      escape : bool ref;
      type_ : Symbol.t option;
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
