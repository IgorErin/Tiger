  $  cat ./code.tig
  /* error : body of while not unit */
  while(10 > 5) do 5+6
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PWhileExp {
    test =
    (Parsetree.PSeqExp
       [Parsetree.POpExp {left = (Parsetree.PIntExp 10); oper = `GtOp;
          right = (Parsetree.PIntExp 5)}
         ]);
    body =
    Parsetree.POpExp {left = (Parsetree.PIntExp 5); oper = `PlusOp;
      right = (Parsetree.PIntExp 6)}}
  message: Type must be Unit
  error: Type mismatch
