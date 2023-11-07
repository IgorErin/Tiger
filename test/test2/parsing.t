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
        [{ Parsetree.ptd_name = (12, "myint");
           ptd_type = (Parsetree.NameTy (10, "int")) };
          { Parsetree.ptd_name = (13, "arrtype");
            ptd_type = (Parsetree.ArrayTy (12, "myint")) }
          ]);
      Parsetree.PVarDec {name = (14, "arr1"); escape = ref (true);
        type_ = (Some (13, "arrtype"));
        init =
        Parsetree.PArrayExp {type_ = (13, "arrtype");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PIntExp 0)}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (14, "arr1")))}
