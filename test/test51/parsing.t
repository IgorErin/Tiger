  $  cat ./code.tig
  let
  	type arrtype1 = array of int
  
  	var arr1: arrtype1 := nil
  in
  	arr1[0]
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "arrtype1");
           ptd_type = (Parsetree.ArrayTy (10, "int")) }
          ]);
      Parsetree.PVarDec {name = (13, "arr1"); escape = ref (true);
        type_ = (Some (12, "arrtype1")); init = Parsetree.PNilExp}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (13, "arr1")),
          (Parsetree.PIntExp 0))))}
