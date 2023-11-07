  $  cat ./code.tig
  /* error: initializing nil expressions not constrained by record type */
  let 
  	type rectype = {name:string, id:int}
  
  	var a:= nil
  in
  	a
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Nil unexpected
  error: Type mismatch
