  $  cat ./code.tig
  /* error : procedure returns value */
  let
  	function g(a:int) = a
  in 
  	g(2)
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
           pfun_result = None;
           pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a"))) }
          ])
      ];
    body =
    Parsetree.PCallExp {func = (12, "g"); args = [(Parsetree.PIntExp 2)]}}
