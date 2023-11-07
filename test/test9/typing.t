  $  cat ./code.tig
  /* error : types of then - else differ */
  
  if (5>4) then 13 else  " "
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= String
  error: Type mismatch
