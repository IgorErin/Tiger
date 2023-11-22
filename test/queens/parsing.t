  $  cat ./code.tig
  let
      var N := 8
  
      type intArray = array of int
  
      var row := intArray [ N ] of 0
      var col := intArray [ N ] of 0
      var diag1 := intArray [N+N-1] of 0
      var diag2 := intArray [N+N-1] of 0
  
      function printboard() =
         (for i := 0 to N-1
  	 do (for j := 0 to N-1 
  	      do print(if col[i]=j then " O" else " .");
  	     print("\n"));
           print("\n"))
  
      function try(c:int) = 
  ( 
       if c=N
       then printboard()
       else for r := 0 to N-1
  	   do if row[r]=0 & diag1[r+c]=0 & diag2[r+7-c]=0
  	           then (row[r]:=1; diag1[r+c]:=1; diag2[r+7-c]:=1;
  		         col[c]:=r;
  	                 try(c+1);
  			 row[r]:=0; diag1[r+c]:=0; diag2[r+7-c]:=0)
  
  )
   in try(0)
  end
  	
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (12, "N"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 8)};
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (13, "intArray");
            ptd_type = (Parsetree.ArrayTy (10, "int")) }
           ]);
      Parsetree.PVarDec {name = (14, "row"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (13, "intArray");
          size = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")));
          init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (15, "col"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (13, "intArray");
          size = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")));
          init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (16, "diag1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (13, "intArray");
          size =
          Parsetree.POpExp {
            left =
            Parsetree.POpExp {
              left = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")));
              oper = `PlusOp;
              right = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")))};
            oper = `MinusOp; right = (Parsetree.PIntExp 1)};
          init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (17, "diag2"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (13, "intArray");
          size =
          Parsetree.POpExp {
            left =
            Parsetree.POpExp {
              left = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")));
              oper = `PlusOp;
              right = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")))};
            oper = `MinusOp; right = (Parsetree.PIntExp 1)};
          init = (Parsetree.PIntExp 0)}};
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (18, "printboard"); pfun_params = [];
            pfun_result = None;
            pfun_body =
            (Parsetree.PSeqExp
               [Parsetree.PForExp {var = (20, "i"); escape = ref (true);
                  lb = (Parsetree.PIntExp 0);
                  hb =
                  Parsetree.POpExp {
                    left = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")));
                    oper = `MinusOp; right = (Parsetree.PIntExp 1)};
                  body =
                  (Parsetree.PSeqExp
                     [Parsetree.PForExp {var = (21, "j"); escape = ref (true);
                        lb = (Parsetree.PIntExp 0);
                        hb =
                        Parsetree.POpExp {
                          left =
                          (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")));
                          oper = `MinusOp; right = (Parsetree.PIntExp 1)};
                        body =
                        Parsetree.PCallExp {func = (0, "print");
                          args =
                          [Parsetree.PIfExp {
                             test =
                             Parsetree.POpExp {
                               left =
                               (Parsetree.PVarExp
                                  (Parsetree.PSubscriptVar (
                                     (Parsetree.PSimpleVar (15, "col")),
                                     (Parsetree.PVarExp
                                        (Parsetree.PSimpleVar (20, "i")))
                                     )));
                               oper = `EqOp;
                               right =
                               (Parsetree.PVarExp
                                  (Parsetree.PSimpleVar (21, "j")))};
                             then_ = (Parsetree.PStringExp " O");
                             else_ = (Some (Parsetree.PStringExp " ."))}
                            ]}};
                       Parsetree.PCallExp {func = (0, "print");
                         args = [(Parsetree.PStringExp "\\n")]}
                       ])};
                 Parsetree.PCallExp {func = (0, "print");
                   args = [(Parsetree.PStringExp "\\n")]}
                 ])
            };
           { Parsetree.pfun_name = (23, "try");
             pfun_params =
             [{ Parsetree.pfd_name = (24, "c"); pfd_escape = ref (true);
                pfd_type = (10, "int") }
               ];
             pfun_result = None;
             pfun_body =
             (Parsetree.PSeqExp
                [Parsetree.PIfExp {
                   test =
                   Parsetree.POpExp {
                     left =
                     (Parsetree.PVarExp (Parsetree.PSimpleVar (24, "c")));
                     oper = `EqOp;
                     right =
                     (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "N")))};
                   then_ =
                   Parsetree.PCallExp {func = (18, "printboard"); args = []};
                   else_ =
                   (Some Parsetree.PForExp {var = (25, "r");
                           escape = ref (true); lb = (Parsetree.PIntExp 0);
                           hb =
                           Parsetree.POpExp {
                             left =
                             (Parsetree.PVarExp
                                (Parsetree.PSimpleVar (12, "N")));
                             oper = `MinusOp; right = (Parsetree.PIntExp 1)};
                           body =
                           Parsetree.PIfExp {
                             test =
                             Parsetree.PIfExp {
                               test =
                               Parsetree.PIfExp {
                                 test =
                                 Parsetree.POpExp {
                                   left =
                                   (Parsetree.PVarExp
                                      (Parsetree.PSubscriptVar (
                                         (Parsetree.PSimpleVar (14, "row")),
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (25, "r")))
                                         )));
                                   oper = `EqOp; right = (Parsetree.PIntExp 0)};
                                 then_ =
                                 Parsetree.POpExp {
                                   left =
                                   (Parsetree.PVarExp
                                      (Parsetree.PSubscriptVar (
                                         (Parsetree.PSimpleVar (16, "diag1")),
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (25, "r")));
                                           oper = `PlusOp;
                                           right =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (24, "c")))}
                                         )));
                                   oper = `EqOp; right = (Parsetree.PIntExp 0)};
                                 else_ = (Some (Parsetree.PIntExp 0))};
                               then_ =
                               Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (17, "diag2")),
                                       Parsetree.POpExp {
                                         left =
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (25, "r")));
                                           oper = `PlusOp;
                                           right = (Parsetree.PIntExp 7)};
                                         oper = `MinusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (24, "c")))}
                                       )));
                                 oper = `EqOp; right = (Parsetree.PIntExp 0)};
                               else_ = (Some (Parsetree.PIntExp 0))};
                             then_ =
                             (Parsetree.PSeqExp
                                [Parsetree.PAssignExp {
                                   var =
                                   (Parsetree.PSubscriptVar (
                                      (Parsetree.PSimpleVar (14, "row")),
                                      (Parsetree.PVarExp
                                         (Parsetree.PSimpleVar (25, "r")))
                                      ));
                                   exp = (Parsetree.PIntExp 1)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (16, "diag1")),
                                       Parsetree.POpExp {
                                         left =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (25, "r")));
                                         oper = `PlusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (24, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 1)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (17, "diag2")),
                                       Parsetree.POpExp {
                                         left =
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (25, "r")));
                                           oper = `PlusOp;
                                           right = (Parsetree.PIntExp 7)};
                                         oper = `MinusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (24, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 1)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (15, "col")),
                                       (Parsetree.PVarExp
                                          (Parsetree.PSimpleVar (24, "c")))
                                       ));
                                    exp =
                                    (Parsetree.PVarExp
                                       (Parsetree.PSimpleVar (25, "r")))};
                                  Parsetree.PCallExp {func = (23, "try");
                                    args =
                                    [Parsetree.POpExp {
                                       left =
                                       (Parsetree.PVarExp
                                          (Parsetree.PSimpleVar (24, "c")));
                                       oper = `PlusOp;
                                       right = (Parsetree.PIntExp 1)}
                                      ]};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (14, "row")),
                                       (Parsetree.PVarExp
                                          (Parsetree.PSimpleVar (25, "r")))
                                       ));
                                    exp = (Parsetree.PIntExp 0)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (16, "diag1")),
                                       Parsetree.POpExp {
                                         left =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (25, "r")));
                                         oper = `PlusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (24, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 0)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (17, "diag2")),
                                       Parsetree.POpExp {
                                         left =
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (25, "r")));
                                           oper = `PlusOp;
                                           right = (Parsetree.PIntExp 7)};
                                         oper = `MinusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (24, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 0)}
                                  ]);
                             else_ = None}})}
                  ])
             }
           ])
      ];
    body =
    Parsetree.PCallExp {func = (23, "try"); args = [(Parsetree.PIntExp 0)]}}
