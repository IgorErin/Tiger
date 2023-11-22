  $  cat ./code.tig
  /* error : types of then - else differ */
  
  if (5>4) then 13 else  " "
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PIfExp {
    test =
    (Parsetree.PSeqExp
       [Parsetree.POpExp {left = (Parsetree.PIntExp 5); oper = `GtOp;
          right = (Parsetree.PIntExp 4)}
         ]);
    then_ = (Parsetree.PIntExp 13); else_ = (Some (Parsetree.PStringExp " "))}
