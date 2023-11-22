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
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TFunctionDec
          [{ Typedtree.fun_name = (12, "do_nothing1");
             fun_params =
             [{ Typedtree.fd_name = (13, "a"); fd_escape = ref (true);
                fd_type = int };
               { Typedtree.fd_name = (14, "b"); fd_escape = ref (true);
                 fd_type = string }
               ];
             fun_result = unit;
             fun_body =
             { Typedtree.exp_desc =
               Typedtree.TCallExp {func = (15, "do_nothing2");
                 args =
                 [{ Typedtree.exp_desc =
                    Typedtree.TOpExp {
                      left =
                      { Typedtree.exp_desc =
                        (Typedtree.TVarExp
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (13, "a")); var_type = int });
                        exp_type = int };
                      oper = `PlusOp;
                      right =
                      { Typedtree.exp_desc = (Typedtree.TIntExp 1);
                        exp_type = int }};
                    exp_type = int }
                   ]};
               exp_type = unit }
             };
            { Typedtree.fun_name = (15, "do_nothing2");
              fun_params =
              [{ Typedtree.fd_name = (16, "d"); fd_escape = ref (true);
                 fd_type = int }
                ];
              fun_result = unit;
              fun_body =
              { Typedtree.exp_desc =
                Typedtree.TCallExp {func = (12, "do_nothing1");
                  args =
                  [{ Typedtree.exp_desc =
                     (Typedtree.TVarExp
                        { Typedtree.var_desc = (Typedtree.TSimpleVar (16, "d"));
                          var_type = int });
                     exp_type = int };
                    { Typedtree.exp_desc = (Typedtree.TStringExp "str");
                      exp_type = string }
                    ]};
                exp_type = unit }
              }
            ])
        ];
      body =
      { Typedtree.exp_desc =
        Typedtree.TCallExp {func = (12, "do_nothing1");
          args =
          [{ Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int };
            { Typedtree.exp_desc = (Typedtree.TStringExp "str2");
              exp_type = string }
            ]};
        exp_type = unit }};
    exp_type = unit }
