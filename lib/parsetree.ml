type arithm =
  [ `PlusOp
  | `MinusOp
  | `TimesOp
  | `DivideOp
  ]
[@@deriving show]

and relational =
  [ `EqOp
  | `NeqOp
  | `LtOp
  | `LeOp
  | `GtOp
  | `GeOp
  ]
[@@deriving show]

type oper =
  [ arithm
  | relational
  ]
[@@deriving show]

type var =
  | PSimpleVar of Symbol.t
  | PFieldVar of var * Symbol.t
  | PSubscriptVar of var * exp
[@@deriving show]

and exp =
  | PVarExp of var
  | PNilExp
  | PIntExp of int
  | PStringExp of string
  | PCallExp of
      { func : Symbol.t
      ; args : exp list
      }
  | POpExp of
      { left : exp
      ; oper : oper
      ; right : exp
      }
  | PSeqExp of exp list
  | PAssignExp of
      { var : var
      ; exp : exp
      }
  | PIfExp of
      { test : exp
      ; then_ : exp
      ; else_ : exp option
      }
  | PWhileExp of
      { test : exp
      ; body : exp
      }
  | PForExp of
      { var : Symbol.t
      ; escape : bool ref
      ; lb : exp
      ; hb : exp
      ; body : exp
      }
  | PBreakExp
  | PLetExp of
      { decs : dec list
      ; body : exp
      }
  | PArrayExp of
      { type_ : Symbol.t
      ; size : exp
      ; init : exp
      }
  | PRecordExp of
      { type_ : Symbol.t
      ; fields : (Symbol.t * exp) list
      }

and dec =
  | PFunctionDec of fundec list
  | PVarDec of
      { name : Symbol.t
      ; escape : bool ref
      ; type_ : Symbol.t option
      ; init : exp
      }
  | PTypeDec of typedec list

and fundec =
  { pfun_name : Symbol.t
  ; pfun_params : field list
  ; pfun_result : Symbol.t option
  ; pfun_body : exp
  }

and typedec =
  { ptd_name : Symbol.t
  ; ptd_type : type_desc
  }

and type_desc =
  | NameTy of Symbol.t
  | RecordTy of field list
  | ArrayTy of Symbol.t

and field =
  { pfd_name : Symbol.t
  ; pfd_escape : bool ref
  ; pfd_type : Symbol.t
  }
