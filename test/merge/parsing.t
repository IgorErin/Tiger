  $  cat ./code.tig
  let 
  
   type any = {any : int}
   var buffer := getchar()
  
  function readint(any: any) : int =
   let var i := 0
       function isdigit(s : string) : int = 
  		  ord(buffer)>=ord("0") & ord(buffer)<=ord("9")
       function skipto() =
         while buffer=" " | buffer="\n"
           do buffer := getchar()
    in (skipto();
       any.any := isdigit(buffer);
       while isdigit(buffer)
         do (i := i*10+ord(buffer)-ord("0"); buffer := getchar());
       i)
   end
  
   type list = {first: int, rest: list}
  
   function readlist() : list =
      let var any := any{any=0}
          var i := readint(any)
       in if any.any
           then list{first=i,rest=readlist()}
           else nil
      end
  
   function merge(a: list, b: list) : list =
     if a=nil then b
     else if b=nil then a
     else if a.first < b.first 
        then list{first=a.first,rest=merge(a.rest,b)}
        else list{first=b.first,rest=merge(a,b.rest)}
  
   function printint(i: int) =
    let function f(i:int) = if i>0 
  	     then (f(i/10); print(chr(i-i/10*10+ord("0"))))
     in if i<0 then (print("-"); f(-i))
        else if i>0 then f(i)
        else print("0")
    end
  
   function printlist(l: list) =
     if l=nil then print("\n")
     else (printint(l.first); print(" "); printlist(l.rest))
  
     var list1 := readlist()
     var list2 := (buffer:=getchar(); readlist())
  
  
   in printlist(merge(list1,list2))
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "any");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (0, "any"); pfd_escape = ref (true);
                 pfd_type = (1, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (2, "buffer"); escape = ref (true);
        type_ = None;
        init = Parsetree.PCallExp {func = (3, "getchar"); args = []}};
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (4, "readint");
            pfun_params =
            [{ Parsetree.pfd_name = (0, "any"); pfd_escape = ref (true);
               pfd_type = (0, "any") }
              ];
            pfun_result = (Some (1, "int"));
            pfun_body =
            Parsetree.PLetExp {
              decs =
              [Parsetree.PVarDec {name = (5, "i"); escape = ref (true);
                 type_ = None; init = (Parsetree.PIntExp 0)};
                (Parsetree.PFunctionDec
                   [{ Parsetree.pfun_name = (6, "isdigit");
                      pfun_params =
                      [{ Parsetree.pfd_name = (7, "s");
                         pfd_escape = ref (true); pfd_type = (8, "string") }
                        ];
                      pfun_result = (Some (1, "int"));
                      pfun_body =
                      Parsetree.PIfExp {
                        test =
                        Parsetree.POpExp {
                          left =
                          Parsetree.PCallExp {func = (9, "ord");
                            args =
                            [(Parsetree.PVarExp
                                (Parsetree.PSimpleVar (2, "buffer")))
                              ]};
                          oper = Parsetree.GeOp;
                          right =
                          Parsetree.PCallExp {func = (9, "ord");
                            args = [(Parsetree.PStringExp "0")]}};
                        then_ =
                        Parsetree.POpExp {
                          left =
                          Parsetree.PCallExp {func = (9, "ord");
                            args =
                            [(Parsetree.PVarExp
                                (Parsetree.PSimpleVar (2, "buffer")))
                              ]};
                          oper = Parsetree.LeOp;
                          right =
                          Parsetree.PCallExp {func = (9, "ord");
                            args = [(Parsetree.PStringExp "9")]}};
                        else_ = (Some (Parsetree.PIntExp 0))}
                      };
                     { Parsetree.pfun_name = (10, "skipto"); pfun_params = [];
                       pfun_result = None;
                       pfun_body =
                       Parsetree.PWhileExp {
                         test =
                         Parsetree.PIfExp {
                           test =
                           Parsetree.POpExp {
                             left =
                             (Parsetree.PVarExp
                                (Parsetree.PSimpleVar (2, "buffer")));
                             oper = Parsetree.EqOp;
                             right = (Parsetree.PStringExp " ")};
                           then_ = (Parsetree.PIntExp 1);
                           else_ =
                           (Some Parsetree.POpExp {
                                   left =
                                   (Parsetree.PVarExp
                                      (Parsetree.PSimpleVar (2, "buffer")));
                                   oper = Parsetree.EqOp;
                                   right = (Parsetree.PStringExp "\\n")})};
                         body =
                         Parsetree.PAssignExp {
                           var = (Parsetree.PSimpleVar (2, "buffer"));
                           exp =
                           Parsetree.PCallExp {func = (3, "getchar"); args = []}}}
                       }
                     ])
                ];
              body =
              (Parsetree.PSeqExp
                 [Parsetree.PCallExp {func = (10, "skipto"); args = []};
                   Parsetree.PAssignExp {
                     var =
                     (Parsetree.PFieldVar ((Parsetree.PSimpleVar (0, "any")),
                        (0, "any")));
                     exp =
                     Parsetree.PCallExp {func = (6, "isdigit");
                       args =
                       [(Parsetree.PVarExp (Parsetree.PSimpleVar (2, "buffer")))
                         ]}};
                   Parsetree.PWhileExp {
                     test =
                     Parsetree.PCallExp {func = (6, "isdigit");
                       args =
                       [(Parsetree.PVarExp (Parsetree.PSimpleVar (2, "buffer")))
                         ]};
                     body =
                     (Parsetree.PSeqExp
                        [Parsetree.PAssignExp {
                           var = (Parsetree.PSimpleVar (5, "i"));
                           exp =
                           Parsetree.POpExp {
                             left =
                             Parsetree.POpExp {
                               left =
                               Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PSimpleVar (5, "i")));
                                 oper = Parsetree.TimesOp;
                                 right = (Parsetree.PIntExp 10)};
                               oper = Parsetree.PlusOp;
                               right =
                               Parsetree.PCallExp {func = (9, "ord");
                                 args =
                                 [(Parsetree.PVarExp
                                     (Parsetree.PSimpleVar (2, "buffer")))
                                   ]}};
                             oper = Parsetree.MinusOp;
                             right =
                             Parsetree.PCallExp {func = (9, "ord");
                               args = [(Parsetree.PStringExp "0")]}}};
                          Parsetree.PAssignExp {
                            var = (Parsetree.PSimpleVar (2, "buffer"));
                            exp =
                            Parsetree.PCallExp {func = (3, "getchar");
                              args = []}}
                          ])};
                   (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i")))])}
            }
           ]);
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (12, "list");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (13, "first"); pfd_escape = ref (true);
                  pfd_type = (1, "int") };
                 { Parsetree.pfd_name = (14, "rest"); pfd_escape = ref (true);
                   pfd_type = (12, "list") }
                 ])
            }
           ]);
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (15, "readlist"); pfun_params = [];
            pfun_result = (Some (12, "list"));
            pfun_body =
            Parsetree.PLetExp {
              decs =
              [Parsetree.PVarDec {name = (0, "any"); escape = ref (true);
                 type_ = None;
                 init =
                 Parsetree.PRecordExp {type_ = (0, "any");
                   fields = [((0, "any"), (Parsetree.PIntExp 0))]}};
                Parsetree.PVarDec {name = (5, "i"); escape = ref (true);
                  type_ = None;
                  init =
                  Parsetree.PCallExp {func = (4, "readint");
                    args =
                    [(Parsetree.PVarExp (Parsetree.PSimpleVar (0, "any")))]}}
                ];
              body =
              Parsetree.PIfExp {
                test =
                (Parsetree.PVarExp
                   (Parsetree.PFieldVar ((Parsetree.PSimpleVar (0, "any")),
                      (0, "any"))));
                then_ =
                Parsetree.PRecordExp {type_ = (12, "list");
                  fields =
                  [((13, "first"),
                    (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i"))));
                    ((14, "rest"),
                     Parsetree.PCallExp {func = (15, "readlist"); args = []})
                    ]};
                else_ = (Some Parsetree.PNilExp)}}
            };
           { Parsetree.pfun_name = (18, "merge");
             pfun_params =
             [{ Parsetree.pfd_name = (19, "a"); pfd_escape = ref (true);
                pfd_type = (12, "list") };
               { Parsetree.pfd_name = (20, "b"); pfd_escape = ref (true);
                 pfd_type = (12, "list") }
               ];
             pfun_result = (Some (12, "list"));
             pfun_body =
             Parsetree.PIfExp {
               test =
               Parsetree.POpExp {
                 left = (Parsetree.PVarExp (Parsetree.PSimpleVar (19, "a")));
                 oper = Parsetree.EqOp; right = Parsetree.PNilExp};
               then_ = (Parsetree.PVarExp (Parsetree.PSimpleVar (20, "b")));
               else_ =
               (Some Parsetree.PIfExp {
                       test =
                       Parsetree.POpExp {
                         left =
                         (Parsetree.PVarExp (Parsetree.PSimpleVar (20, "b")));
                         oper = Parsetree.EqOp; right = Parsetree.PNilExp};
                       then_ =
                       (Parsetree.PVarExp (Parsetree.PSimpleVar (19, "a")));
                       else_ =
                       (Some Parsetree.PIfExp {
                               test =
                               Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PFieldVar (
                                       (Parsetree.PSimpleVar (19, "a")),
                                       (13, "first"))));
                                 oper = Parsetree.LtOp;
                                 right =
                                 (Parsetree.PVarExp
                                    (Parsetree.PFieldVar (
                                       (Parsetree.PSimpleVar (20, "b")),
                                       (13, "first"))))};
                               then_ =
                               Parsetree.PRecordExp {type_ = (12, "list");
                                 fields =
                                 [((13, "first"),
                                   (Parsetree.PVarExp
                                      (Parsetree.PFieldVar (
                                         (Parsetree.PSimpleVar (19, "a")),
                                         (13, "first")))));
                                   ((14, "rest"),
                                    Parsetree.PCallExp {func = (18, "merge");
                                      args =
                                      [(Parsetree.PVarExp
                                          (Parsetree.PFieldVar (
                                             (Parsetree.PSimpleVar (19, "a")),
                                             (14, "rest"))));
                                        (Parsetree.PVarExp
                                           (Parsetree.PSimpleVar (20, "b")))
                                        ]})
                                   ]};
                               else_ =
                               (Some Parsetree.PRecordExp {
                                       type_ = (12, "list");
                                       fields =
                                       [((13, "first"),
                                         (Parsetree.PVarExp
                                            (Parsetree.PFieldVar (
                                               (Parsetree.PSimpleVar (20, "b")),
                                               (13, "first")))));
                                         ((14, "rest"),
                                          Parsetree.PCallExp {
                                            func = (18, "merge");
                                            args =
                                            [(Parsetree.PVarExp
                                                (Parsetree.PSimpleVar (19, "a")));
                                              (Parsetree.PVarExp
                                                 (Parsetree.PFieldVar (
                                                    (Parsetree.PSimpleVar
                                                       (20, "b")),
                                                    (14, "rest"))))
                                              ]})
                                         ]})})})}
             };
           { Parsetree.pfun_name = (21, "printint");
             pfun_params =
             [{ Parsetree.pfd_name = (5, "i"); pfd_escape = ref (true);
                pfd_type = (1, "int") }
               ];
             pfun_result = None;
             pfun_body =
             Parsetree.PLetExp {
               decs =
               [(Parsetree.PFunctionDec
                   [{ Parsetree.pfun_name = (22, "f");
                      pfun_params =
                      [{ Parsetree.pfd_name = (5, "i");
                         pfd_escape = ref (true); pfd_type = (1, "int") }
                        ];
                      pfun_result = None;
                      pfun_body =
                      Parsetree.PIfExp {
                        test =
                        Parsetree.POpExp {
                          left =
                          (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i")));
                          oper = Parsetree.GtOp; right = (Parsetree.PIntExp 0)};
                        then_ =
                        (Parsetree.PSeqExp
                           [Parsetree.PCallExp {func = (22, "f");
                              args =
                              [Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PSimpleVar (5, "i")));
                                 oper = Parsetree.DivideOp;
                                 right = (Parsetree.PIntExp 10)}
                                ]};
                             Parsetree.PCallExp {func = (23, "print");
                               args =
                               [Parsetree.PCallExp {func = (24, "chr");
                                  args =
                                  [Parsetree.POpExp {
                                     left =
                                     (Parsetree.PVarExp
                                        (Parsetree.PSimpleVar (5, "i")));
                                     oper = Parsetree.MinusOp;
                                     right =
                                     Parsetree.POpExp {
                                       left =
                                       Parsetree.POpExp {
                                         left =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (5, "i")));
                                         oper = Parsetree.DivideOp;
                                         right =
                                         Parsetree.POpExp {
                                           left = (Parsetree.PIntExp 10);
                                           oper = Parsetree.TimesOp;
                                           right = (Parsetree.PIntExp 10)}};
                                       oper = Parsetree.PlusOp;
                                       right =
                                       Parsetree.PCallExp {func = (9, "ord");
                                         args = [(Parsetree.PStringExp "0")]}}}
                                    ]}
                                 ]}
                             ]);
                        else_ = None}
                      }
                     ])
                 ];
               body =
               Parsetree.PIfExp {
                 test =
                 Parsetree.POpExp {
                   left = (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i")));
                   oper = Parsetree.LtOp; right = (Parsetree.PIntExp 0)};
                 then_ =
                 (Parsetree.PSeqExp
                    [Parsetree.PCallExp {func = (23, "print");
                       args = [(Parsetree.PStringExp "-")]};
                      Parsetree.PCallExp {func = (22, "f");
                        args =
                        [Parsetree.POpExp {left = (Parsetree.PIntExp 0);
                           oper = Parsetree.MinusOp;
                           right =
                           (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i")))}
                          ]}
                      ]);
                 else_ =
                 (Some Parsetree.PIfExp {
                         test =
                         Parsetree.POpExp {
                           left =
                           (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i")));
                           oper = Parsetree.GtOp; right = (Parsetree.PIntExp 0)};
                         then_ =
                         Parsetree.PCallExp {func = (22, "f");
                           args =
                           [(Parsetree.PVarExp (Parsetree.PSimpleVar (5, "i")))
                             ]};
                         else_ =
                         (Some Parsetree.PCallExp {func = (23, "print");
                                 args = [(Parsetree.PStringExp "0")]})})}}
             };
           { Parsetree.pfun_name = (25, "printlist");
             pfun_params =
             [{ Parsetree.pfd_name = (26, "l"); pfd_escape = ref (true);
                pfd_type = (12, "list") }
               ];
             pfun_result = None;
             pfun_body =
             Parsetree.PIfExp {
               test =
               Parsetree.POpExp {
                 left = (Parsetree.PVarExp (Parsetree.PSimpleVar (26, "l")));
                 oper = Parsetree.EqOp; right = Parsetree.PNilExp};
               then_ =
               Parsetree.PCallExp {func = (23, "print");
                 args = [(Parsetree.PStringExp "\\n")]};
               else_ =
               (Some (Parsetree.PSeqExp
                        [Parsetree.PCallExp {func = (21, "printint");
                           args =
                           [(Parsetree.PVarExp
                               (Parsetree.PFieldVar (
                                  (Parsetree.PSimpleVar (26, "l")),
                                  (13, "first"))))
                             ]};
                          Parsetree.PCallExp {func = (23, "print");
                            args = [(Parsetree.PStringExp " ")]};
                          Parsetree.PCallExp {func = (25, "printlist");
                            args =
                            [(Parsetree.PVarExp
                                (Parsetree.PFieldVar (
                                   (Parsetree.PSimpleVar (26, "l")),
                                   (14, "rest"))))
                              ]}
                          ]))}
             }
           ]);
      Parsetree.PVarDec {name = (27, "list1"); escape = ref (true);
        type_ = None;
        init = Parsetree.PCallExp {func = (15, "readlist"); args = []}};
      Parsetree.PVarDec {name = (28, "list2"); escape = ref (true);
        type_ = None;
        init =
        (Parsetree.PSeqExp
           [Parsetree.PAssignExp {var = (Parsetree.PSimpleVar (2, "buffer"));
              exp = Parsetree.PCallExp {func = (3, "getchar"); args = []}};
             Parsetree.PCallExp {func = (15, "readlist"); args = []}])}
      ];
    body =
    Parsetree.PCallExp {func = (25, "printlist");
      args =
      [Parsetree.PCallExp {func = (18, "merge");
         args =
         [(Parsetree.PVarExp (Parsetree.PSimpleVar (27, "list1")));
           (Parsetree.PVarExp (Parsetree.PSimpleVar (28, "list2")))]}
        ]}}
