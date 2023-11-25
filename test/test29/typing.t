  $  cat ./code.tig
  /* error : different array types */
  
  let
  	type arrtype1 = array of int
  	type arrtype2 = array of int
  
  	var arr1: arrtype1 := arrtype2 [10] of 0
  in
  	arr1
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal array of int =/= array of int
  error: Type mismatch
