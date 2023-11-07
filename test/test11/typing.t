  $  cat ./code.tig
  /* error hi expr is not int, and index variable erroneously assigned to.  */
  for i:=10 to " " do 
  	i := i - 1
  $ Tiger -dtypedtree ./code.tig 
  message: Type msut be Int
  error: Type mismatch
