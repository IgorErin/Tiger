  $  cat ./code.tig
  /* error : integer required */
  
  3 + "var"
  $ Tiger -dparsetree ./code.tig 
  Parsetree.POpExp {left = (Parsetree.PIntExp 3); oper = `PlusOp;
    right = (Parsetree.PStringExp "var")}
