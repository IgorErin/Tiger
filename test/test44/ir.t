  $  cat ./code.tig
  /* valid nil initialization and assignment */
  let 
  
  	type rectype = {name:string, id:int}
  	var b:rectype := nil
  
  in
  
  	b := nil
  
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)));
          (Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0)))]))
