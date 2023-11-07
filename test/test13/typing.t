  $  cat ./code.tig
  /* error: comparison of incompatible types */
  
  3 > "df"
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal int =/= String
  error: Type mismatch
