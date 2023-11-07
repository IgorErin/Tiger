  $  cat ./code.tig
  /* error : initializing exp and array type differ */
  
  let
  	type arrayty = array of int
  
  	var a := arrayty [10] of " "
  in
  	0
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= String
  error: Type mismatch
