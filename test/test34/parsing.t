  $  cat ./code.tig
  /* error : formals and actuals have different types */
  let
  	function g (a:int , b:string):int = a
  in
  	g("one", "two")
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PFunctionDec
        [{ Parsetree.pfun_name = (0, "g");
           pfun_params =
           [{ Parsetree.pfd_name = (1, "a"); pfd_escape = ref (true);
              pfd_type = (2, "int") };
             { Parsetree.pfd_name = (3, "b"); pfd_escape = ref (true);
               pfd_type = (4, "string") }
             ];
           pfun_result = (Some (2, "int"));
           pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "a"))) }
          ])
      ];
    body =
    Parsetree.PCallExp {func = (0, "g");
      args = [(Parsetree.PStringExp "one"); (Parsetree.PStringExp "two")]}}
