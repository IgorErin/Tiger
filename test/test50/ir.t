  $  cat ./code.tig
  let 
  	type rectype = {name:string, id:int}
  
  	var a:rectype :=  nil
  in
  	a.name
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)));
          (Ir.Exp
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.CJump (Ir.EQ, (Ir.Mem (Ir.Temp ("FP", 0))),
                       (Ir.Const 0), ("L", 4), ("L", 3)));
                     (Ir.Label ("L", 4));
                     (Ir.Exp
                        (Ir.Call ((Ir.Name ("null_ref", 5)),
                           [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                     (Ir.Label ("L", 3))]),
                (Ir.Mem (Ir.Temp ("FP", 0))))))
          ]))
