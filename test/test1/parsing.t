  $  cat ./code.tig
  let
  	type  arrtype = array of int
  	var arr1:arrtype := arrtype [10] of 0
  in
  	arr1
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "arrtype");
           ptd_type = (Parsetree.ArrayTy (1, "int")) }
          ]);
      Parsetree.PVarDec {name = (2, "arr1"); escape = ref (true);
        type_ = (Some (0, "arrtype"));
        init =
        Parsetree.PArrayExp {type_ = (0, "arrtype");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PIntExp 0)}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (2, "arr1")))}
