  $  cat ./code.tig
  /* correct if */
  if (10 > 20) then 30 else 40	
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Ex
     (Ir.Eseq (
        (Ir.Seq
           [(Ir.CJump (Ir.GT, (Ir.Const 10), (Ir.Const 20), ("L", 3), (
               "L", 4)));
             (Ir.Label ("L", 3));
             (Ir.Move ((Ir.Name ("T", 1)), (Ir.Const 30)));
             (Ir.Jump ((Ir.Name ("L", 5)), [("L", 5)])); (Ir.Label ("L", 4));
             (Ir.Move ((Ir.Name ("T", 1)), (Ir.Const 40))); (Ir.Label ("L", 5))
             ]),
        (Ir.Name ("T", 1)))))
