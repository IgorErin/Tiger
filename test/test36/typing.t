  $  cat ./code.tig
  /* error : formals are fewer then actuals */
  let
  	function g (a:int , b:string):int = a
  in
  	g(3,"one",5)
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Call of g, parameters = 2, arguemnts = 3
  error: Type mismatch
