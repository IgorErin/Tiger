  $  cat ./code.tig
  /* error : type constraint and init value differ */
  let 
  	var a:int := " "
  in
  	a
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (12, "a"); escape = ref (true);
       type_ = (Some (10, "int")); init = (Parsetree.PStringExp " ")}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "a")))}
