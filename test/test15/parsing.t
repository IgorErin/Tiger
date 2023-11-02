  $  cat ./code.tig
  /* error : if-then returns non unit */
  
  if 20 then 3
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PIfExp {test = (Parsetree.PIntExp 20);
    then_ = (Parsetree.PIntExp 3); else_ = None}
