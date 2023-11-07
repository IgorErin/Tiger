  $  cat ./code.tig
  /* error : formals are more then actuals */
  let
  	function g (a:int , b:string):int = a
  in
  	g("one")
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Call of g, parameters = 2, arguemnts = 1
  error: Type mismatch
