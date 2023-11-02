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
    [Parsetree.PVarDec {name = (0, "a"); escape = ref (true);
       type_ = (Some (1, "int")); init = (Parsetree.PStringExp " ")}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "a")))}
