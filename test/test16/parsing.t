  $  cat ./code.tig
  /* error: mutually recursive types thet do not pass through record or array */
  let 
  
  type a=c
  type b=a
  type c=d
  type d=a
  
  in
   ""
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "a");
           ptd_type = (Parsetree.NameTy (1, "c")) };
          { Parsetree.ptd_name = (2, "b");
            ptd_type = (Parsetree.NameTy (0, "a")) };
          { Parsetree.ptd_name = (1, "c");
            ptd_type = (Parsetree.NameTy (3, "d")) };
          { Parsetree.ptd_name = (3, "d");
            ptd_type = (Parsetree.NameTy (0, "a")) }
          ])
      ];
    body = (Parsetree.PStringExp "")}
