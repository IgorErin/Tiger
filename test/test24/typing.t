  $  cat ./code.tig
  /* error : variable not array */
  let 
  	var d:=0
  in
  	d[3]
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Array type expected
  error: not a record: int
