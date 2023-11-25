  $  cat ./code.tig
  /* define valid mutually recursive procedures */
  let
  
  function do_nothing1(a: int, b: string)=
  		do_nothing2(a+1)
  
  function do_nothing2(d: int) =
  		do_nothing1(d, "str")
  
  in
  	do_nothing1(0, "str2")
  end
  $ Tiger -dir ./code.tig
  function("L", 3):
  (Ir.Exp
     (Ir.Call ((Ir.Name ("L", 4)),
        [(Ir.Mem (Ir.Temp ("FP", 0)));
          (Ir.BinOp (Ir.Plus,
             (Ir.Mem
                (Ir.Mem
                   (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const -4))))),
             (Ir.Const 1)))
          ]
        )))
  string (("L", 5) : "str")
  function("L", 4):
  (Ir.Exp
     (Ir.Call ((Ir.Name ("L", 3)),
        [(Ir.Mem (Ir.Temp ("FP", 0)));
          (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const -4))));
          (Ir.Name ("L", 5))]
        )))
  string (("L", 6) : "str2")
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Exp
            (Ir.Call ((Ir.Name ("L", 3)),
               [(Ir.Mem (Ir.Temp ("FP", 0))); (Ir.Const 0); (Ir.Name ("L", 6))]
               )))
          ]))
