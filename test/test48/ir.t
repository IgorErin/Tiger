  $  cat ./code.tig
  /* This is legal.  The second function "g" simply hides the first one.
     Because of the intervening variable declaration, the two "g" functions
     are not in the same  batch of mutually recursive functions. 
     See also test39 */
  let
  	function g(a:int):int = a
  	type t = int
  	function g(a:int):int = a
  in
  	0
  end
  $ Tiger -dir ./code.tig
  function("L", 3):
  (Ir.Exp (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const -4)))))
  function("L", 4):
  (Ir.Exp (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const -4)))))
  body:
  (Translate.Exp.Nx (Ir.Seq [(Ir.Exp (Ir.Const 0))]))
