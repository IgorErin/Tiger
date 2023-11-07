  $  cat ./code.tig
  /* synonyms are fine */
  
  let 
  		type a = array of int
  		type b = a
  
  		var arr1:a := b [10] of 0
  in
  		arr1[2]
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "a");
           ptd_type = (Parsetree.ArrayTy (10, "int")) };
          { Parsetree.ptd_name = (13, "b");
            ptd_type = (Parsetree.NameTy (12, "a")) }
          ]);
      Parsetree.PVarDec {name = (14, "arr1"); escape = ref (true);
        type_ = (Some (12, "a"));
        init =
        Parsetree.PArrayExp {type_ = (13, "b"); size = (Parsetree.PIntExp 10);
          init = (Parsetree.PIntExp 0)}}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (14, "arr1")),
          (Parsetree.PIntExp 2))))}
