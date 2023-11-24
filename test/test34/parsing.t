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
        [{ Parsetree.pfun_name = (12, "g");
           pfun_params =
           [{ Parsetree.pfd_name = (13, "a"); pfd_escape = ref (true);
              pfd_type = (10, "int") };
             { Parsetree.pfd_name = (14, "b"); pfd_escape = ref (true);
               pfd_type = (11, "string") }
             ];
           pfun_result = (Some (10, "int"));
           pfun_body = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a"))) }
          ])
      ];
    body =
    Parsetree.PCallExp {func = (12, "g");
      args = [(Parsetree.PStringExp "one"); (Parsetree.PStringExp "two")]}}
  message: Types must be equal int =/= String
  error: Type mismatch
