  $  cat ./code.tig
  /* error: comparison of incompatible types */
  
  3 > "df"
  $ Tiger -dparsetree ./code.tig 
  Parsetree.POpExp {left = (Parsetree.PIntExp 3); oper = `GtOp;
    right = (Parsetree.PStringExp "df")}
  message: Types must be equal int =/= String
  error: Type mismatch
