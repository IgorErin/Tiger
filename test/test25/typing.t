  $  cat ./code.tig
  /* error : variable not record */
  let 
  	var d:=0
  in
  	d.f 
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Attemt to get field f on int type
  error: not a record: int
