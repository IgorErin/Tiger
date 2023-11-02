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
    [Parsetree.PVarDec {name = (0, "N"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 8)};
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (1, "intArray");
            ptd_type = (Parsetree.ArrayTy (2, "int")) }
           ]);
      Parsetree.PVarDec {name = (3, "row"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (1, "intArray");
          size = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
          init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (4, "col"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (1, "intArray");
          size = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
          init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (5, "diag1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (1, "intArray");
          size =
          Parsetree.POpExp {
            left =
            Parsetree.POpExp {
              left = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
              oper = Parsetree.PlusOp;
              right = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")))};
            oper = Parsetree.MinusOp; right = (Parsetree.PIntExp 1)};
          init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (6, "diag2"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (1, "intArray");
          size =
          Parsetree.POpExp {
            left =
            Parsetree.POpExp {
              left = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
              oper = Parsetree.PlusOp;
              right = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")))};
            oper = Parsetree.MinusOp; right = (Parsetree.PIntExp 1)};
          init = (Parsetree.PIntExp 0)}};
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (7, "printboard"); pfun_params = [];
            pfun_result = None;
            pfun_body =
            (Parsetree.PSeqExp
               [Parsetree.PForExp {var = (9, "i"); escape = ref (true);
                  lb = (Parsetree.PIntExp 0);
                  hb =
                  Parsetree.POpExp {
                    left = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
                    oper = Parsetree.MinusOp; right = (Parsetree.PIntExp 1)};
                  body =
                  (Parsetree.PSeqExp
                     [Parsetree.PForExp {var = (10, "j"); escape = ref (true);
                        lb = (Parsetree.PIntExp 0);
                        hb =
                        Parsetree.POpExp {
                          left =
                          (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
                          oper = Parsetree.MinusOp;
                          right = (Parsetree.PIntExp 1)};
                        body =
                        Parsetree.PCallExp {func = (11, "print");
                          args =
                          [Parsetree.PIfExp {
                             test =
                             Parsetree.POpExp {
                               left =
                               (Parsetree.PVarExp
                                  (Parsetree.PSubscriptVar (
                                     (Parsetree.PSimpleVar (4, "col")),
                                     (Parsetree.PVarExp
                                        (Parsetree.PSimpleVar (9, "i")))
                                     )));
                               oper = Parsetree.EqOp;
                               right =
                               (Parsetree.PVarExp
                                  (Parsetree.PSimpleVar (10, "j")))};
                             then_ = (Parsetree.PStringExp " O");
                             else_ = (Some (Parsetree.PStringExp " ."))}
                            ]}};
                       Parsetree.PCallExp {func = (11, "print");
                         args = [(Parsetree.PStringExp "\\n")]}
                       ])};
                 Parsetree.PCallExp {func = (11, "print");
                   args = [(Parsetree.PStringExp "\\n")]}
                 ])
            };
           { Parsetree.pfun_name = (13, "try");
             pfun_params =
             [{ Parsetree.pfd_name = (14, "c"); pfd_escape = ref (true);
                pfd_type = (2, "int") }
               ];
             pfun_result = None;
             pfun_body =
             (Parsetree.PSeqExp
                [Parsetree.PIfExp {
                   test =
                   Parsetree.POpExp {
                     left =
                     (Parsetree.PVarExp (Parsetree.PSimpleVar (14, "c")));
                     oper = Parsetree.EqOp;
                     right =
                     (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")))};
                   then_ =
                   Parsetree.PCallExp {func = (7, "printboard"); args = []};
                   else_ =
                   (Some Parsetree.PForExp {var = (15, "r");
                           escape = ref (true); lb = (Parsetree.PIntExp 0);
                           hb =
                           Parsetree.POpExp {
                             left =
                             (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "N")));
                             oper = Parsetree.MinusOp;
                             right = (Parsetree.PIntExp 1)};
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
                                         (Parsetree.PSimpleVar (3, "row")),
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (15, "r")))
                                         )));
                                   oper = Parsetree.EqOp;
                                   right = (Parsetree.PIntExp 0)};
                                 then_ =
                                 Parsetree.POpExp {
                                   left =
                                   (Parsetree.PVarExp
                                      (Parsetree.PSubscriptVar (
                                         (Parsetree.PSimpleVar (5, "diag1")),
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (15, "r")));
                                           oper = Parsetree.PlusOp;
                                           right =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (14, "c")))}
                                         )));
                                   oper = Parsetree.EqOp;
                                   right = (Parsetree.PIntExp 0)};
                                 else_ = (Some (Parsetree.PIntExp 0))};
                               then_ =
                               Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (6, "diag2")),
                                       Parsetree.POpExp {
                                         left =
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (15, "r")));
                                           oper = Parsetree.PlusOp;
                                           right = (Parsetree.PIntExp 7)};
                                         oper = Parsetree.MinusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (14, "c")))}
                                       )));
                                 oper = Parsetree.EqOp;
                                 right = (Parsetree.PIntExp 0)};
                               else_ = (Some (Parsetree.PIntExp 0))};
                             then_ =
                             (Parsetree.PSeqExp
                                [Parsetree.PAssignExp {
                                   var =
                                   (Parsetree.PSubscriptVar (
                                      (Parsetree.PSimpleVar (3, "row")),
                                      (Parsetree.PVarExp
                                         (Parsetree.PSimpleVar (15, "r")))
                                      ));
                                   exp = (Parsetree.PIntExp 1)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (5, "diag1")),
                                       Parsetree.POpExp {
                                         left =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (15, "r")));
                                         oper = Parsetree.PlusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (14, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 1)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (6, "diag2")),
                                       Parsetree.POpExp {
                                         left =
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (15, "r")));
                                           oper = Parsetree.PlusOp;
                                           right = (Parsetree.PIntExp 7)};
                                         oper = Parsetree.MinusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (14, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 1)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (4, "col")),
                                       (Parsetree.PVarExp
                                          (Parsetree.PSimpleVar (14, "c")))
                                       ));
                                    exp =
                                    (Parsetree.PVarExp
                                       (Parsetree.PSimpleVar (15, "r")))};
                                  Parsetree.PCallExp {func = (13, "try");
                                    args =
                                    [Parsetree.POpExp {
                                       left =
                                       (Parsetree.PVarExp
                                          (Parsetree.PSimpleVar (14, "c")));
                                       oper = Parsetree.PlusOp;
                                       right = (Parsetree.PIntExp 1)}
                                      ]};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (3, "row")),
                                       (Parsetree.PVarExp
                                          (Parsetree.PSimpleVar (15, "r")))
                                       ));
                                    exp = (Parsetree.PIntExp 0)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (5, "diag1")),
                                       Parsetree.POpExp {
                                         left =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (15, "r")));
                                         oper = Parsetree.PlusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (14, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 0)};
                                  Parsetree.PAssignExp {
                                    var =
                                    (Parsetree.PSubscriptVar (
                                       (Parsetree.PSimpleVar (6, "diag2")),
                                       Parsetree.POpExp {
                                         left =
                                         Parsetree.POpExp {
                                           left =
                                           (Parsetree.PVarExp
                                              (Parsetree.PSimpleVar (15, "r")));
                                           oper = Parsetree.PlusOp;
                                           right = (Parsetree.PIntExp 7)};
                                         oper = Parsetree.MinusOp;
                                         right =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (14, "c")))}
                                       ));
                                    exp = (Parsetree.PIntExp 0)}
                                  ]);
                             else_ = None}})}
                  ])
             }
           ])
      ];
    body =
    Parsetree.PCallExp {func = (13, "try"); args = [(Parsetree.PIntExp 0)]}}
