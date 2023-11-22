  $  cat ./code.tig
  /* error: undeclared variable i */
  
  while 10 > 5 do (i+1;())
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PWhileExp {
    test =
    Parsetree.POpExp {left = (Parsetree.PIntExp 10); oper = `GtOp;
      right = (Parsetree.PIntExp 5)};
    body =
    (Parsetree.PSeqExp
       [Parsetree.POpExp {
          left = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "i")));
          oper = `PlusOp; right = (Parsetree.PIntExp 1)};
         (Parsetree.PSeqExp [])])}
