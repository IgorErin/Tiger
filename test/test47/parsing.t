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
        [{ Parsetree.ptd_name = (0, "a");
           ptd_type = (Parsetree.NameTy (1, "int")) }
          ]);
      Parsetree.PVarDec {name = (2, "b"); escape = ref (true); type_ = None;
        init = (Parsetree.PIntExp 4)};
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (0, "a");
            ptd_type = (Parsetree.NameTy (3, "string")) }
           ])
      ];
    body = (Parsetree.PIntExp 0)}
