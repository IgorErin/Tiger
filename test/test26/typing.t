  $  cat ./code.tig
  /* error : integer required */
  
  3 + "var"
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= String
  error: Type mismatch
