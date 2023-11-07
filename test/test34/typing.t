  $  cat ./code.tig
  /* error : formals and actuals have different types */
  let
  	function g (a:int , b:string):int = a
  in
  	g("one", "two")
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= String
  error: Type mismatch
