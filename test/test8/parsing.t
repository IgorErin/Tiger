  $  cat ./code.tig
  /* correct if */
  if (10 > 20) then 30 else 40	
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PIfExp {
    test =
    (Parsetree.PSeqExp
       [Parsetree.POpExp {left = (Parsetree.PIntExp 10); oper = Parsetree.GtOp;
          right = (Parsetree.PIntExp 20)}
         ]);
    then_ = (Parsetree.PIntExp 30); else_ = (Some (Parsetree.PIntExp 40))}
