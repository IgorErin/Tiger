  $  cat ./code.tig
  /* error: syntax error, nil should not be preceded by type-id.  */
  let 
  	type rectype = {name:string, id:int}
  
  	var a:= rectype nil
  in
  	a
  end
  $ Tiger -dtypedtree ./code.tig 
  Parsing error.
