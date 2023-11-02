  $  cat ./code.tig
  /* error: comparison of incompatible types */
  
  3 > "df"
  $ Tiger -dparsetree ./code.tig 
  Parsetree.POpExp {left = (Parsetree.PIntExp 3); oper = Parsetree.GtOp;
    right = (Parsetree.PStringExp "df")}
