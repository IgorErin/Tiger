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
        [{ Parsetree.ptd_name = (12, "a");
           ptd_type = (Parsetree.NameTy (13, "c")) };
          { Parsetree.ptd_name = (14, "b");
            ptd_type = (Parsetree.NameTy (12, "a")) };
          { Parsetree.ptd_name = (13, "c");
            ptd_type = (Parsetree.NameTy (15, "d")) };
          { Parsetree.ptd_name = (15, "d");
            ptd_type = (Parsetree.NameTy (12, "a")) }
          ])
      ];
    body = (Parsetree.PStringExp "")}
  message: Cycl type a name
  error: Umbiguos
