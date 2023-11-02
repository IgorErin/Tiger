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
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PFunctionDec
        [{ Parsetree.pfun_name = (0, "nfactor");
           pfun_params =
           [{ Parsetree.pfd_name = (1, "n"); pfd_escape = ref (true);
              pfd_type = (2, "int") }
             ];
           pfun_result = (Some (2, "int"));
           pfun_body =
           Parsetree.PIfExp {
             test =
             Parsetree.POpExp {
               left = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "n")));
               oper = Parsetree.EqOp; right = (Parsetree.PIntExp 0)};
             then_ = (Parsetree.PIntExp 1);
             else_ =
             (Some Parsetree.POpExp {
                     left = (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "n")));
                     oper = Parsetree.TimesOp;
                     right =
                     Parsetree.PCallExp {func = (0, "nfactor");
                       args =
                       [Parsetree.POpExp {
                          left =
                          (Parsetree.PVarExp (Parsetree.PSimpleVar (1, "n")));
                          oper = Parsetree.MinusOp;
                          right = (Parsetree.PIntExp 1)}
                         ]}})}
           }
          ])
      ];
    body =
    Parsetree.PCallExp {func = (0, "nfactor"); args = [(Parsetree.PIntExp 10)]}}
