  $  cat ./code.tig
  /* error : definition of recursive functions is interrupted */
  let
  
  function do_nothing1(a: int, b: string):int=
  		(do_nothing2(a+1);0)
  
  var d:=0
  
  function do_nothing2(d: int):string =
  		(do_nothing1(d, "str");" ")
  
  in
  	do_nothing1(0, "str2")
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PFunctionDec
        [{ Parsetree.pfun_name = (0, "do_nothing1");
           pfun_params =
           [{ Parsetree.pfd_name = (1, "a"); pfd_escape = ref (true);
              pfd_type = (2, "int") };
             { Parsetree.pfd_name = (3, "b"); pfd_escape = ref (true);
               pfd_type = (4, "string") }
             ];
           pfun_result = (Some (2, "int"));
           pfun_body =
           (Parsetree.PSeqExp
              [Parsetree.PCallExp {func = (5, "do_nothing2");
                 args =
                 [Parsetree.POpExp {
                    left = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "a")));
                    oper = Parsetree.PlusOp; right = (Parsetree.PIntExp 1)}
                   ]};
                (Parsetree.PIntExp 0)])
           }
          ]);
      Parsetree.PVarDec {name = (6, "d"); escape = ref (true); type_ = None;
        init = (Parsetree.PIntExp 0)};
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (5, "do_nothing2");
            pfun_params =
            [{ Parsetree.pfd_name = (6, "d"); pfd_escape = ref (true);
               pfd_type = (2, "int") }
              ];
            pfun_result = (Some (4, "string"));
            pfun_body =
            (Parsetree.PSeqExp
               [Parsetree.PCallExp {func = (0, "do_nothing1");
                  args =
                  [(Parsetree.PVarExp (Parsetree.PSimpleVar (6, "d")));
                    (Parsetree.PStringExp "str")]};
                 (Parsetree.PStringExp " ")])
            }
           ])
      ];
    body =
    Parsetree.PCallExp {func = (0, "do_nothing1");
      args = [(Parsetree.PIntExp 0); (Parsetree.PStringExp "str2")]}}
