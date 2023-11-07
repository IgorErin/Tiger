  $  cat ./code.tig
  /* This is illegal, since there are two types with the same name
      in the same (consecutive) batch of mutually recursive types. 
      See also test47  */
  let
  	type a = int
  	type a = string
  
  	var a: a := "" 
  in
  	a
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "a");
           ptd_type = (Parsetree.NameTy (10, "int")) };
          { Parsetree.ptd_name = (12, "a");
            ptd_type = (Parsetree.NameTy (11, "string")) }
          ]);
      Parsetree.PVarDec {name = (12, "a"); escape = ref (true);
        type_ = (Some (12, "a")); init = (Parsetree.PStringExp "")}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "a")))}
