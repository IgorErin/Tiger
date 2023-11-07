  $  cat ./code.tig
  /* error : body of while not unit */
  while(10 > 5) do 5+6
  $ Tiger -dtypedtree ./code.tig 
  message: Type must be Unit
  error: Type mismatch
