  $  cat ./code.tig
  /* define a recursive function */
  let
  
  /* calculate n! */
  function nfactor(n: int): int =
  		if  n = 0 
  			then 1
  			else n * nfactor(n-1)
  
  in
  	nfactor(10)
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TFunctionDec
          [{ Typedtree.fun_name = (12, "nfactor");
             fun_params =
             [{ Typedtree.fd_name = (13, "n"); fd_escape = ref (true);
                fd_type = int }
               ];
             fun_result = int;
             fun_body =
             { Typedtree.exp_desc =
               Typedtree.TIfExp {
                 test =
                 { Typedtree.exp_desc =
                   Typedtree.TOpExp {
                     left =
                     { Typedtree.exp_desc =
                       (Typedtree.TVarExp
                          { Typedtree.var_desc =
                            (Typedtree.TSimpleVar (13, "n")); var_type = int });
                       exp_type = int };
                     oper = `EqOp;
                     right =
                     { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                       exp_type = int }};
                   exp_type = int };
                 then_ =
                 { Typedtree.exp_desc = (Typedtree.TIntExp 1); exp_type = int };
                 else_ =
                 (Some { Typedtree.exp_desc =
                         Typedtree.TOpExp {
                           left =
                           { Typedtree.exp_desc =
                             (Typedtree.TVarExp
                                { Typedtree.var_desc =
                                  (Typedtree.TSimpleVar (13, "n"));
                                  var_type = int });
                             exp_type = int };
                           oper = `TimesOp;
                           right =
                           { Typedtree.exp_desc =
                             Typedtree.TCallExp {func = (12, "nfactor");
                               args =
                               [{ Typedtree.exp_desc =
                                  Typedtree.TOpExp {
                                    left =
                                    { Typedtree.exp_desc =
                                      (Typedtree.TVarExp
                                         { Typedtree.var_desc =
                                           (Typedtree.TSimpleVar (13, "n"));
                                           var_type = int });
                                      exp_type = int };
                                    oper = `MinusOp;
                                    right =
                                    { Typedtree.exp_desc =
                                      (Typedtree.TIntExp 1); exp_type = int }};
                                  exp_type = int }
                                 ]};
                             exp_type = int }};
                         exp_type = int })};
               exp_type = int }
             }
            ])
        ];
      body =
      { Typedtree.exp_desc =
        Typedtree.TCallExp {func = (12, "nfactor");
          args =
          [{ Typedtree.exp_desc = (Typedtree.TIntExp 10); exp_type = int }]};
        exp_type = int }};
    exp_type = int }
