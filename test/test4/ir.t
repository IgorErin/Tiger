  $  cat ./code.tig
  /* define a recursive function */
  let
  
  /* calculate n! */
  function nfactor(n: int): int =
  		if  n = 0 
  			then 1
  			else n * nfactor(n-1)
  
  in
  	nfactor(10)
  end
  $ Tiger -dir ./code.tig
  function("L", 3):
  (Ir.Exp
     (Ir.Eseq (
        (Ir.Seq
           [(Ir.CJump (Ir.EQ,
               (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const -4)))),
               (Ir.Const 0), ("L", 4), ("L", 5)));
             (Ir.Label ("L", 4)); (Ir.Move ((Ir.Name ("T", 1)), (Ir.Const 1)));
             (Ir.Jump ((Ir.Name ("L", 6)), [("L", 6)])); (Ir.Label ("L", 5));
             (Ir.Move ((Ir.Name ("T", 1)),
                (Ir.BinOp (Ir.Mul,
                   (Ir.Mem
                      (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const -4)))),
                   (Ir.Call ((Ir.Name ("L", 3)),
                      [(Ir.Mem (Ir.Temp ("FP", 0)));
                        (Ir.BinOp (Ir.Minus,
                           (Ir.Mem
                              (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)),
                                 (Ir.Const -4)))),
                           (Ir.Const 1)))
                        ]
                      ))
                   ))
                ));
             (Ir.Label ("L", 6))]),
        (Ir.Name ("T", 1)))))
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Exp
            (Ir.Call ((Ir.Name ("L", 3)),
               [(Ir.Mem (Ir.Temp ("FP", 0))); (Ir.Const 10)])))
          ]))
