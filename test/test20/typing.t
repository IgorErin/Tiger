  $  cat ./code.tig
  /* error: undeclared variable i */
  
  while 10 > 5 do (i+1;())
  $ Tiger -dtypedtree ./code.tig 
  error: unbound name: i
