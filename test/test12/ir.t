  $  cat ./code.tig
  /* valid for and let */
  
  let
  	var a:= 0
  in 
  	for i:=0 to 100 do (a:=a+1;())
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)));
          (Ir.Seq
             [(Ir.Move ((Ir.Temp ("T", 2)), (Ir.Const 0)));
               (Ir.Move ((Ir.Temp ("T", 1)), (Ir.Const 100)));
               (Ir.Label ("L", 5));
               (Ir.CJump (Ir.LE, (Ir.Temp ("T", 2)), (Ir.Temp ("T", 1)),
                  ("L", 4), ("L", 3)));
               (Ir.Label ("L", 4));
               (Ir.Seq
                  [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))),
                      (Ir.BinOp (Ir.Plus, (Ir.Mem (Ir.Temp ("FP", 0))),
                         (Ir.Const 1)))
                      ));
                    (Ir.Exp (Ir.Const 0))]);
               (Ir.CJump (Ir.LT, (Ir.Temp ("T", 2)), (Ir.Const 100), ("L", 5),
                  ("L", 3)));
               (Ir.Label ("L", 3))])
          ]))
