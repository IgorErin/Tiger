  $  cat ./code.tig
  /* error : different array types */
  
  let
  	type arrtype1 = array of int
  	type arrtype2 = array of int
  
  	var arr1: arrtype1 := arrtype2 [10] of 0
  in
  	arr1
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "arrtype1");
           ptd_type = (Parsetree.ArrayTy (1, "int")) };
          { Parsetree.ptd_name = (2, "arrtype2");
            ptd_type = (Parsetree.ArrayTy (1, "int")) }
          ]);
      Parsetree.PVarDec {name = (3, "arr1"); escape = ref (true);
        type_ = (Some (0, "arrtype1"));
        init =
        Parsetree.PArrayExp {type_ = (2, "arrtype2");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PIntExp 0)}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (3, "arr1")))}
