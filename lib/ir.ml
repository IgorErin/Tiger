type exp =
  | Const of int
  | Name of Temp.label
  | Temo of Temp.temp
  | BinOp of binop * exp * exp
  | Mem of exp
  | Call of exp * exp list
  | Eseq of stm * exp

and stm =
  | Move of exp * exp
  | Exp of exp
  | Jump of exp * Temp.label list
  | CJump of relop * exp * exp * Temp.label * Temp.label
  | Seq of stm * stm
  | Lable of Temp.label

and binop =
  | Plus
  | Mminus
  | Mul
  | Div
  | And
  | Or
  | LShift
  | RShift
  | ARShift
  | XOr

and relop =
  | EQ
  | NE
  | LT
  | GT
  | LE
  | GE
  | ULT
  | ULE
  | UGT
  | UGE
