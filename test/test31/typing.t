  $  cat ./code.tig
  /* error : type constraint and init value differ */
  let 
  	var a:int := " "
  in
  	a
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal String =/= int
  error: Type mismatch
