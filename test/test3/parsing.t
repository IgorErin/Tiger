  $  cat ./code.tig
  /* arr1 is valid since expression 0 is int = myint */
  let
  	type myint = int
  	type  arrtype = array of myint
  
  	var arr1:arrtype := arrtype [10] of 0
  in
  	arr1
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "myint");
           ptd_type = (Parsetree.NameTy (1, "int")) };
          { Parsetree.ptd_name = (2, "arrtype");
            ptd_type = (Parsetree.ArrayTy (0, "myint")) }
          ]);
      Parsetree.PVarDec {name = (3, "arr1"); escape = ref (true);
        type_ = (Some (2, "arrtype"));
        init =
        Parsetree.PArrayExp {type_ = (2, "arrtype");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PIntExp 0)}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (3, "arr1")))}
