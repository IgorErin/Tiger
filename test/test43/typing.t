  $  cat ./code.tig
  /* initialize with unit and causing type mismatch in addition */
  
  let 
  	var a := ()
  in
  	a + 3
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal unit =/= int
  error: Type mismatch
