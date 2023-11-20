type exp =
  | Const of int
  | Name of Temp.label
  | Temp of Temp.temp
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
  | Label of Temp.label

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

let false_ = Const 0
let true_ = Const 1
let exp e = Exp e
let const c = Const c
let eseq s e = Eseq (s, e)
let name n = Name n
let label l = Label l
let temp n = Temp n
let move fst snd = Move (fst, snd)
let cjump cmp fst snd t f = CJump (cmp, fst, snd, t, f)
let binop fst op snd = BinOp (op, fst, snd)
let mem e = Mem e

let seq ls =
  let ls = List.rev ls in
  match ls with
  | [] -> failwith "Empty seq"
  | hd :: tl -> List.fold_right (fun next acc -> Seq (next, acc)) tl hd
;;
