  $  cat ./code.tig
  let
  	type  arrtype = array of int
  	var arr1:arrtype := arrtype [10] of 0
  in
  	arr1
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))),
            (Ir.Call ((Ir.Name ("init_array", 3)),
               [(Ir.Const 0); (Ir.Const 10)]))
            ));
          (Ir.Exp (Ir.Mem (Ir.Temp ("FP", 0))))]))
