  $  cat ./code.tig
  /* error : procedure returns value  and procedure is used in arexpr */
  let
  
  /* calculate n! */
  function nfactor(n: int) =
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
        [{ Parsetree.pfun_name = (12, "nfactor");
           pfun_params =
           [{ Parsetree.pfd_name = (13, "n"); pfd_escape = ref (true);
              pfd_type = (10, "int") }
             ];
           pfun_result = None;
           pfun_body =
           Parsetree.PIfExp {
             test =
             Parsetree.POpExp {
               left = (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "n")));
               oper = `EqOp; right = (Parsetree.PIntExp 0)};
             then_ = (Parsetree.PIntExp 1);
             else_ =
             (Some Parsetree.POpExp {
                     left =
                     (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "n")));
                     oper = `TimesOp;
                     right =
                     Parsetree.PCallExp {func = (12, "nfactor");
                       args =
                       [Parsetree.POpExp {
                          left =
                          (Parsetree.PVarExp (Parsetree.PSimpleVar (13, "n")));
                          oper = `MinusOp; right = (Parsetree.PIntExp 1)}
                         ]}})}
           }
          ])
      ];
    body =
    Parsetree.PCallExp {func = (12, "nfactor"); args = [(Parsetree.PIntExp 10)]}}
