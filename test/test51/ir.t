  $  cat ./code.tig
  let
  	type arrtype1 = array of int
  
  	var arr1: arrtype1 := nil
  in
  	arr1[0]
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)));
          (Ir.Exp
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.CJump (Ir.GE, (Ir.Const 0), (Ir.Const 0), ("L", 8),
                       ("L", 7)));
                     (Ir.Label ("L", 8));
                     (Ir.CJump (Ir.LT, (Ir.Const 0),
                        (Ir.Mem
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.EQ,
                                     (Ir.Mem (Ir.Temp ("FP", 0))),
                                     (Ir.Const 0), ("L", 4), ("L", 3)));
                                   (Ir.Label ("L", 4));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("null_ref", 5)),
                                         [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                                   (Ir.Label ("L", 3))]),
                              (Ir.Mem (Ir.Temp ("FP", 0)))))),
                        ("L", 6), ("L", 7)));
                     (Ir.Label ("L", 7));
                     (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                     (Ir.Label ("L", 6))]),
                (Ir.Mem
                   (Ir.BinOp (Ir.Plus,
                      (Ir.Eseq (
                         (Ir.Seq
                            [(Ir.CJump (Ir.EQ, (Ir.Mem (Ir.Temp ("FP", 0))),
                                (Ir.Const 0), ("L", 4), ("L", 3)));
                              (Ir.Label ("L", 4));
                              (Ir.Exp
                                 (Ir.Call ((Ir.Name ("null_ref", 5)),
                                    [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                              (Ir.Label ("L", 3))]),
                         (Ir.Mem (Ir.Temp ("FP", 0))))),
                      (Ir.BinOp (Ir.Mul, (Ir.Const 0), (Ir.Const 4))))))
                )))
          ]))
