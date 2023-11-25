  $  cat ./code.tig
  /* a record type and a record variable */
  let
  	type  rectype = {name:string, age:int}
  	var rec1:rectype := rectype {name="Nobody", age=1000}
  in
  	(rec1.name := "Somebody";
  	rec1)
  end
  $ Tiger -dir ./code.tig
  string (("L", 3) : "Nobody")
  string (("L", 8) : "Somebody")
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))),
            (Ir.Eseq (
               (Ir.Seq
                  [(Ir.Seq
                      [(Ir.Move ((Ir.Temp ("T", 1)),
                          (Ir.Call ((Ir.Name ("malloc", 4)), [(Ir.Const 2)]))));
                        (Ir.Move (
                           (Ir.Mem
                              (Ir.BinOp (Ir.Plus, (Ir.Const 0),
                                 (Ir.Temp ("T", 1))))),
                           (Ir.Name ("L", 3))))
                        ]);
                    (Ir.Move (
                       (Ir.Mem
                          (Ir.BinOp (Ir.Plus, (Ir.Const 4), (Ir.Temp ("T", 1))
                             ))),
                       (Ir.Const 1000)))
                    ]),
               (Ir.Temp ("T", 1))))
            ));
          (Ir.Exp
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.Move (
                       (Ir.Eseq (
                          (Ir.Seq
                             [(Ir.CJump (Ir.EQ, (Ir.Mem (Ir.Temp ("FP", 0))),
                                 (Ir.Const 0), ("L", 6), ("L", 5)));
                               (Ir.Label ("L", 6));
                               (Ir.Exp
                                  (Ir.Call ((Ir.Name ("null_ref", 7)),
                                     [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                               (Ir.Label ("L", 5))]),
                          (Ir.Mem (Ir.Temp ("FP", 0))))),
                       (Ir.Name ("L", 8))))
                     ]),
                (Ir.Mem (Ir.Temp ("FP", 0))))))
          ]))
