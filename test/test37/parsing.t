  $  cat ./code.tig
  /* redeclaration of variable; this is legal, there are two different
     variables with the same name.  The second one hides the first.  */
  let
  	var a := 0
  	var a := " "
  in
  	a
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (12, "a"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 0)};
      Parsetree.PVarDec {name = (12, "a"); escape = ref (true); type_ = None;
        init = (Parsetree.PStringExp " ")}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "a")))}
