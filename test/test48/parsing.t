  $  cat ./code.tig
  /* This is legal.  The second function "g" simply hides the first one.
     Because of the intervening variable declaration, the two "g" functions
     are not in the same  batch of mutually recursive functions. 
     See also test39 */
  let
  	function g(a:int):int = a
  	type t = int
  	function g(a:int):int = a
  in
  	0
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PFunctionDec
        [{ Parsetree.pfun_name = (12, "g");
           pfun_params =
           [{ Parsetree.pfd_name = (13, "a"); pfd_escape = ref (true);
              pfd_type = (10, "int") }
             ];
           pfun_result = (Some (10, "int"));
           pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a"))) }
          ]);
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (14, "t");
            ptd_type = (Parsetree.NameTy (10, "int")) }
           ]);
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (12, "g");
            pfun_params =
            [{ Parsetree.pfd_name = (13, "a"); pfd_escape = ref (true);
               pfd_type = (10, "int") }
              ];
            pfun_result = (Some (10, "int"));
            pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a"))) }
           ])
      ];
    body = (Parsetree.PIntExp 0)}
