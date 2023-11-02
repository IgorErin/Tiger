  $  cat ./code.tig
  /* This is illegal, since there are two functions with the same name
      in the same (consecutive) batch of mutually recursive functions.
     See also test48 */
  let
  	function g(a:int):int = a
  	function g(a:int):int = a
  in
  	0
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PFunctionDec
        [{ Parsetree.pfun_name = (0, "g");
           pfun_params =
           [{ Parsetree.pfd_name = (1, "a"); pfd_escape = ref (true);
              pfd_type = (2, "int") }
             ];
           pfun_result = (Some (2, "int"));
           pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "a"))) };
          { Parsetree.pfun_name = (0, "g");
            pfun_params =
            [{ Parsetree.pfd_name = (1, "a"); pfd_escape = ref (true);
               pfd_type = (2, "int") }
              ];
            pfun_result = (Some (2, "int"));
            pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "a"))) }
          ])
      ];
    body = (Parsetree.PIntExp 0)}
