  $  cat ./code.tig
  /* valid rec comparisons */
  let 
  	type rectype = {name:string, id:int}
  	var b:rectype := nil
  in
  	(b = nil;
  	b <> nil)
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)));
          (Ir.Exp
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.Seq
                       [(Ir.CJump (Ir.EQ, (Ir.Mem (Ir.Temp ("FP", 0))),
                           (Ir.Const 0), ("L", 5), ("L", 5)));
                         (Ir.Label ("L", 5))])
                     ]),
                (Ir.Eseq (
                   (Ir.Seq
                      [(Ir.Move ((Ir.Name ("T", 1)), (Ir.Const 1)));
                        (Ir.CJump (Ir.NE, (Ir.Mem (Ir.Temp ("FP", 0))),
                           (Ir.Const 0), ("L", 3), ("L", 4)));
                        (Ir.Label ("L", 4));
                        (Ir.Move ((Ir.Name ("T", 1)), (Ir.Const 0)));
                        (Ir.Label ("L", 3))]),
                   (Ir.Name ("T", 1))))
                )))
          ]))
