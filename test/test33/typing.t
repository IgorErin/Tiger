  $  cat ./code.tig
  /* error : unknown type */
  let
  	var a:= rectype {}
  in
  	0
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Record expr type unbound.
  error: unbound type: rectype
