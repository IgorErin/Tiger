  $  cat ./code.tig
  /* error : if-then returns non unit */
  
  if 20 then 3
  $ Tiger -dtypedtree ./code.tig 
  message: Type must be Unit
  error: Type mismatch
