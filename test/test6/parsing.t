  $  cat ./code.tig
  /* define valid mutually recursive procedures */
  let
  
  function do_nothing1(a: int, b: string)=
  		do_nothing2(a+1)
  
  function do_nothing2(d: int) =
  		do_nothing1(d, "str")
  
  in
  	do_nothing1(0, "str2")
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PFunctionDec
        [{ Parsetree.pfun_name = (12, "do_nothing1");
           pfun_params =
           [{ Parsetree.pfd_name = (13, "a"); pfd_escape = ref (true);
              pfd_type = (10, "int") };
             { Parsetree.pfd_name = (14, "b"); pfd_escape = ref (true);
               pfd_type = (11, "string") }
             ];
           pfun_result = None;
           pfun_body =
           Parsetree.PCallExp {func = (15, "do_nothing2");
             args =
             [Parsetree.POpExp {
                left = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "a")));
                oper = `PlusOp; right = (Parsetree.PIntExp 1)}
               ]}
           };
          { Parsetree.pfun_name = (15, "do_nothing2");
            pfun_params =
            [{ Parsetree.pfd_name = (16, "d"); pfd_escape = ref (true);
               pfd_type = (10, "int") }
              ];
            pfun_result = None;
            pfun_body =
            Parsetree.PCallExp {func = (12, "do_nothing1");
              args =
              [(Parsetree.PVarExp (Parsetree.PSimpleVar (16, "d")));
                (Parsetree.PStringExp "str")]}
            }
          ])
      ];
    body =
    Parsetree.PCallExp {func = (12, "do_nothing1");
      args = [(Parsetree.PIntExp 0); (Parsetree.PStringExp "str2")]}}
