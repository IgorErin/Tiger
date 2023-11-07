  $  cat ./code.tig
  /* This is legal.  The second type "a" simply hides the first one.
     Because of the intervening variable declaration, the two "a" types
     are not in the same  batch of mutually recursive types.
     See also test38 */
  let
  	type a = int
  	var b := 4
  	type a = string
  in
  	0
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "a");
           ptd_type = (Parsetree.NameTy (10, "int")) }
          ]);
      Parsetree.PVarDec {name = (13, "b"); escape = ref (true); type_ = None;
        init = (Parsetree.PIntExp 4)};
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (12, "a");
            ptd_type = (Parsetree.NameTy (11, "string")) }
           ])
      ];
    body = (Parsetree.PIntExp 0)}
