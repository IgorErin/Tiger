  $  cat ./code.tig
  /* This is illegal, since there are two types with the same name
      in the same (consecutive) batch of mutually recursive types. 
      See also test47  */
  let
  	type a = int
  	type a = string
  
  	var a: a := "" 
  in
  	a
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Same name in mutual type def: a
  error: Umbiguos

