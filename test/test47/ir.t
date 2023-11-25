  $  cat ./code.tig
  /* This is legal.  The second type "a" simply hides the first one.
     Because of the intervening variable declaration, the two "a" types
     are not in the same  batch of mutually recursive types.
     See also test38 */
  let
  	type a = int
  	var b := 4
  	type a = string
  in
  	0
  end
  $ Tiger -dir ./code.tig
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 4)));
          (Ir.Exp (Ir.Const 0))]))
