  $  cat ./code.tig
  /* error hi expr is not int, and index variable erroneously assigned to.  */
  for i:=10 to " " do 
  	i := i - 1
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PForExp {var = (1, "i"); escape = ref (true);
    lb = (Parsetree.PIntExp 10); hb = (Parsetree.PStringExp " ");
    body =
    Parsetree.PAssignExp {var = (Parsetree.PSimpleVar (1, "i"));
      exp =
      Parsetree.POpExp {
        left = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "i")));
        oper = Parsetree.MinusOp; right = (Parsetree.PIntExp 1)}}}
