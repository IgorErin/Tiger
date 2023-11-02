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
        [{ Parsetree.ptd_name = (0, "a");
           ptd_type = (Parsetree.ArrayTy (1, "int")) };
          { Parsetree.ptd_name = (2, "b");
            ptd_type = (Parsetree.NameTy (0, "a")) }
          ]);
      Parsetree.PVarDec {name = (3, "arr1"); escape = ref (true);
        type_ = (Some (0, "a"));
        init =
        Parsetree.PArrayExp {type_ = (2, "b"); size = (Parsetree.PIntExp 10);
          init = (Parsetree.PIntExp 0)}}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (3, "arr1")),
          (Parsetree.PIntExp 2))))}
