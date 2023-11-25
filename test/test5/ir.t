  $  cat ./code.tig
  /* define valid recursive types */
  let
  /* define a list */
  type intlist = {hd: int, tl: intlist} 
  
  /* define a tree */
  type tree ={key: int, children: treelist}
  
  type treelist = {hd: tree, tl: treelist}
  
  
  var lis := intlist { hd=0, tl= nil } 
  
  in
  	()
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))),
            (Ir.Eseq (
               (Ir.Seq
                  [(Ir.Seq
                      [(Ir.Move ((Ir.Temp ("T", 1)),
                          (Ir.Call ((Ir.Name ("malloc", 3)), [(Ir.Const 2)]))));
                        (Ir.Move (
                           (Ir.Mem
                              (Ir.BinOp (Ir.Plus, (Ir.Const 0),
                                 (Ir.Temp ("T", 1))))),
                           (Ir.Const 0)))
                        ]);
                    (Ir.Move (
                       (Ir.Mem
                          (Ir.BinOp (Ir.Plus, (Ir.Const 4), (Ir.Temp ("T", 1))
                             ))),
                       (Ir.Const 0)))
                    ]),
               (Ir.Temp ("T", 1))))
            ));
          (Ir.Exp (Ir.Const 0))]))
