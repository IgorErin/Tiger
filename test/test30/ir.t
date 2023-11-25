  $  cat ./code.tig
  /* synonyms are fine */
  
  let 
  		type a = array of int
  		type b = a
  
  		var arr1:a := b [10] of 0
  in
  		arr1[2]
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))),
            (Ir.Call ((Ir.Name ("init_array", 3)),
               [(Ir.Const 0); (Ir.Const 10)]))
            ));
          (Ir.Exp
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.CJump (Ir.GE, (Ir.Const 2), (Ir.Const 0), ("L", 9),
                       ("L", 8)));
                     (Ir.Label ("L", 9));
                     (Ir.CJump (Ir.LT, (Ir.Const 2),
                        (Ir.Mem
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.EQ,
                                     (Ir.Mem (Ir.Temp ("FP", 0))),
                                     (Ir.Const 0), ("L", 5), ("L", 4)));
                                   (Ir.Label ("L", 5));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("null_ref", 6)),
                                         [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                                   (Ir.Label ("L", 4))]),
                              (Ir.Mem (Ir.Temp ("FP", 0)))))),
                        ("L", 7), ("L", 8)));
                     (Ir.Label ("L", 8));
                     (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                     (Ir.Label ("L", 7))]),
                (Ir.Mem
                   (Ir.BinOp (Ir.Plus,
                      (Ir.Eseq (
                         (Ir.Seq
                            [(Ir.CJump (Ir.EQ, (Ir.Mem (Ir.Temp ("FP", 0))),
                                (Ir.Const 0), ("L", 5), ("L", 4)));
                              (Ir.Label ("L", 5));
                              (Ir.Exp
                                 (Ir.Call ((Ir.Name ("null_ref", 6)),
                                    [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                              (Ir.Label ("L", 4))]),
                         (Ir.Mem (Ir.Temp ("FP", 0))))),
                      (Ir.BinOp (Ir.Mul, (Ir.Const 2), (Ir.Const 4))))))
                )))
          ]))
