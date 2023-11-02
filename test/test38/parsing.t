  $  cat ./code.tig
  /* This is illegal, since there are two types with the same name
      in the same (consecutive) batch of mutually recursive types. 
      See also test47  */
  let
  	type a = int
  	type a = string
  in
  	0
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "a");
           ptd_type = (Parsetree.NameTy (1, "int")) };
          { Parsetree.ptd_name = (0, "a");
            ptd_type = (Parsetree.NameTy (2, "string")) }
          ])
      ];
    body = (Parsetree.PIntExp 0)}
