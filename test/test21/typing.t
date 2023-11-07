  $  cat ./code.tig
  /* error : procedure returns value  and procedure is used in arexpr */
  let
  
  /* calculate n! */
  function nfactor(n: int) =
  		if  n = 0 
  			then 1
  			else n * nfactor(n-1)
  
  in
  	nfactor(10)
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= unit
  error: Type mismatch
