  $  cat ./code.tig
  /* error : procedure returns value */
  let
  	function g(a:int) = a
  in 
  	g(2)
  end
      
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= unit
  error: Type mismatch
