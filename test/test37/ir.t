  $  cat ./code.tig
  /* redeclaration of variable; this is legal, there are two different
     variables with the same name.  The second one hides the first.  */
  let
  	var a := 0
  	var a := " "
  in
  	a
  end
  $ Tiger -dir ./code.tig
  string (("L", 3) : " ")
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)));
          (Ir.Move (
             (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 4)))),
             (Ir.Name ("L", 3))));
          (Ir.Exp
             (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 4)))))
          ]))
