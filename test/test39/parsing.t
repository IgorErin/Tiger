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
        [{ Parsetree.pfun_name = (12, "g");
           pfun_params =
           [{ Parsetree.pfd_name = (13, "a"); pfd_escape = ref (true);
              pfd_type = (10, "int") }
             ];
           pfun_result = (Some (10, "int"));
           pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a"))) };
          { Parsetree.pfun_name = (12, "g");
            pfun_params =
            [{ Parsetree.pfd_name = (13, "a"); pfd_escape = ref (true);
               pfd_type = (10, "int") }
              ];
            pfun_result = (Some (10, "int"));
            pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a"))) }
          ])
      ];
    body = (Parsetree.PIntExp 0)}
  message: Same name in mutual fun def: g
  error: Umbiguos
