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
        [{ Parsetree.ptd_name = (12, "any");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (12, "any"); pfd_escape = ref (true);
                 pfd_type = (10, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (13, "buffer"); escape = ref (true);
        type_ = None;
        init = Parsetree.PCallExp {func = (2, "getchar"); args = []}};
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (14, "readint");
            pfun_params =
            [{ Parsetree.pfd_name = (12, "any"); pfd_escape = ref (true);
               pfd_type = (12, "any") }
              ];
            pfun_result = (Some (10, "int"));
            pfun_body =
            Parsetree.PLetExp {
              decs =
              [Parsetree.PVarDec {name = (15, "i"); escape = ref (true);
                 type_ = None; init = (Parsetree.PIntExp 0)};
                (Parsetree.PFunctionDec
                   [{ Parsetree.pfun_name = (16, "isdigit");
                      pfun_params =
                      [{ Parsetree.pfd_name = (17, "s");
                         pfd_escape = ref (true); pfd_type = (11, "string") }
                        ];
                      pfun_result = (Some (10, "int"));
                      pfun_body =
                      Parsetree.PIfExp {
                        test =
                        Parsetree.POpExp {
                          left =
                          Parsetree.PCallExp {func = (3, "ord");
                            args =
                            [(Parsetree.PVarExp
                                (Parsetree.PSimpleVar (13, "buffer")))
                              ]};
                          oper = Parsetree.GeOp;
                          right =
                          Parsetree.PCallExp {func = (3, "ord");
                            args = [(Parsetree.PStringExp "0")]}};
                        then_ =
                        Parsetree.POpExp {
                          left =
                          Parsetree.PCallExp {func = (3, "ord");
                            args =
                            [(Parsetree.PVarExp
                                (Parsetree.PSimpleVar (13, "buffer")))
                              ]};
                          oper = Parsetree.LeOp;
                          right =
                          Parsetree.PCallExp {func = (3, "ord");
                            args = [(Parsetree.PStringExp "9")]}};
                        else_ = (Some (Parsetree.PIntExp 0))}
                      };
                     { Parsetree.pfun_name = (18, "skipto"); pfun_params = [];
                       pfun_result = None;
                       pfun_body =
                       Parsetree.PWhileExp {
                         test =
                         Parsetree.PIfExp {
                           test =
                           Parsetree.POpExp {
                             left =
                             (Parsetree.PVarExp
                                (Parsetree.PSimpleVar (13, "buffer")));
                             oper = Parsetree.EqOp;
                             right = (Parsetree.PStringExp " ")};
                           then_ = (Parsetree.PIntExp 1);
                           else_ =
                           (Some Parsetree.POpExp {
                                   left =
                                   (Parsetree.PVarExp
                                      (Parsetree.PSimpleVar (13, "buffer")));
                                   oper = Parsetree.EqOp;
                                   right = (Parsetree.PStringExp "\\n")})};
                         body =
                         Parsetree.PAssignExp {
                           var = (Parsetree.PSimpleVar (13, "buffer"));
                           exp =
                           Parsetree.PCallExp {func = (2, "getchar"); args = []}}}
                       }
                     ])
                ];
              body =
              (Parsetree.PSeqExp
                 [Parsetree.PCallExp {func = (18, "skipto"); args = []};
                   Parsetree.PAssignExp {
                     var =
                     (Parsetree.PFieldVar ((Parsetree.PSimpleVar (12, "any")),
                        (12, "any")));
                     exp =
                     Parsetree.PCallExp {func = (16, "isdigit");
                       args =
                       [(Parsetree.PVarExp
                           (Parsetree.PSimpleVar (13, "buffer")))
                         ]}};
                   Parsetree.PWhileExp {
                     test =
                     Parsetree.PCallExp {func = (16, "isdigit");
                       args =
                       [(Parsetree.PVarExp
                           (Parsetree.PSimpleVar (13, "buffer")))
                         ]};
                     body =
                     (Parsetree.PSeqExp
                        [Parsetree.PAssignExp {
                           var = (Parsetree.PSimpleVar (15, "i"));
                           exp =
                           Parsetree.POpExp {
                             left =
                             Parsetree.POpExp {
                               left =
                               Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PSimpleVar (15, "i")));
                                 oper = Parsetree.TimesOp;
                                 right = (Parsetree.PIntExp 10)};
                               oper = Parsetree.PlusOp;
                               right =
                               Parsetree.PCallExp {func = (3, "ord");
                                 args =
                                 [(Parsetree.PVarExp
                                     (Parsetree.PSimpleVar (13, "buffer")))
                                   ]}};
                             oper = Parsetree.MinusOp;
                             right =
                             Parsetree.PCallExp {func = (3, "ord");
                               args = [(Parsetree.PStringExp "0")]}}};
                          Parsetree.PAssignExp {
                            var = (Parsetree.PSimpleVar (13, "buffer"));
                            exp =
                            Parsetree.PCallExp {func = (2, "getchar");
                              args = []}}
                          ])};
                   (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i")))])}
            }
           ]);
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (20, "list");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (21, "first"); pfd_escape = ref (true);
                  pfd_type = (10, "int") };
                 { Parsetree.pfd_name = (22, "rest"); pfd_escape = ref (true);
                   pfd_type = (20, "list") }
                 ])
            }
           ]);
      (Parsetree.PFunctionDec
         [{ Parsetree.pfun_name = (23, "readlist"); pfun_params = [];
            pfun_result = (Some (20, "list"));
            pfun_body =
            Parsetree.PLetExp {
              decs =
              [Parsetree.PVarDec {name = (12, "any"); escape = ref (true);
                 type_ = None;
                 init =
                 Parsetree.PRecordExp {type_ = (12, "any");
                   fields = [((12, "any"), (Parsetree.PIntExp 0))]}};
                Parsetree.PVarDec {name = (15, "i"); escape = ref (true);
                  type_ = None;
                  init =
                  Parsetree.PCallExp {func = (14, "readint");
                    args =
                    [(Parsetree.PVarExp (Parsetree.PSimpleVar (12, "any")))]}}
                ];
              body =
              Parsetree.PIfExp {
                test =
                (Parsetree.PVarExp
                   (Parsetree.PFieldVar ((Parsetree.PSimpleVar (12, "any")),
                      (12, "any"))));
                then_ =
                Parsetree.PRecordExp {type_ = (20, "list");
                  fields =
                  [((21, "first"),
                    (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i"))));
                    ((22, "rest"),
                     Parsetree.PCallExp {func = (23, "readlist"); args = []})
                    ]};
                else_ = (Some Parsetree.PNilExp)}}
            };
           { Parsetree.pfun_name = (26, "merge");
             pfun_params =
             [{ Parsetree.pfd_name = (27, "a"); pfd_escape = ref (true);
                pfd_type = (20, "list") };
               { Parsetree.pfd_name = (28, "b"); pfd_escape = ref (true);
                 pfd_type = (20, "list") }
               ];
             pfun_result = (Some (20, "list"));
             pfun_body =
             Parsetree.PIfExp {
               test =
               Parsetree.POpExp {
                 left = (Parsetree.PVarExp (Parsetree.PSimpleVar (27, "a")));
                 oper = Parsetree.EqOp; right = Parsetree.PNilExp};
               then_ = (Parsetree.PVarExp (Parsetree.PSimpleVar (28, "b")));
               else_ =
               (Some Parsetree.PIfExp {
                       test =
                       Parsetree.POpExp {
                         left =
                         (Parsetree.PVarExp (Parsetree.PSimpleVar (28, "b")));
                         oper = Parsetree.EqOp; right = Parsetree.PNilExp};
                       then_ =
                       (Parsetree.PVarExp (Parsetree.PSimpleVar (27, "a")));
                       else_ =
                       (Some Parsetree.PIfExp {
                               test =
                               Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PFieldVar (
                                       (Parsetree.PSimpleVar (27, "a")),
                                       (21, "first"))));
                                 oper = Parsetree.LtOp;
                                 right =
                                 (Parsetree.PVarExp
                                    (Parsetree.PFieldVar (
                                       (Parsetree.PSimpleVar (28, "b")),
                                       (21, "first"))))};
                               then_ =
                               Parsetree.PRecordExp {type_ = (20, "list");
                                 fields =
                                 [((21, "first"),
                                   (Parsetree.PVarExp
                                      (Parsetree.PFieldVar (
                                         (Parsetree.PSimpleVar (27, "a")),
                                         (21, "first")))));
                                   ((22, "rest"),
                                    Parsetree.PCallExp {func = (26, "merge");
                                      args =
                                      [(Parsetree.PVarExp
                                          (Parsetree.PFieldVar (
                                             (Parsetree.PSimpleVar (27, "a")),
                                             (22, "rest"))));
                                        (Parsetree.PVarExp
                                           (Parsetree.PSimpleVar (28, "b")))
                                        ]})
                                   ]};
                               else_ =
                               (Some Parsetree.PRecordExp {
                                       type_ = (20, "list");
                                       fields =
                                       [((21, "first"),
                                         (Parsetree.PVarExp
                                            (Parsetree.PFieldVar (
                                               (Parsetree.PSimpleVar (28, "b")),
                                               (21, "first")))));
                                         ((22, "rest"),
                                          Parsetree.PCallExp {
                                            func = (26, "merge");
                                            args =
                                            [(Parsetree.PVarExp
                                                (Parsetree.PSimpleVar (27, "a")));
                                              (Parsetree.PVarExp
                                                 (Parsetree.PFieldVar (
                                                    (Parsetree.PSimpleVar
                                                       (28, "b")),
                                                    (22, "rest"))))
                                              ]})
                                         ]})})})}
             };
           { Parsetree.pfun_name = (29, "printint");
             pfun_params =
             [{ Parsetree.pfd_name = (15, "i"); pfd_escape = ref (true);
                pfd_type = (10, "int") }
               ];
             pfun_result = None;
             pfun_body =
             Parsetree.PLetExp {
               decs =
               [(Parsetree.PFunctionDec
                   [{ Parsetree.pfun_name = (30, "f");
                      pfun_params =
                      [{ Parsetree.pfd_name = (15, "i");
                         pfd_escape = ref (true); pfd_type = (10, "int") }
                        ];
                      pfun_result = None;
                      pfun_body =
                      Parsetree.PIfExp {
                        test =
                        Parsetree.POpExp {
                          left =
                          (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i")));
                          oper = Parsetree.GtOp; right = (Parsetree.PIntExp 0)};
                        then_ =
                        (Parsetree.PSeqExp
                           [Parsetree.PCallExp {func = (30, "f");
                              args =
                              [Parsetree.POpExp {
                                 left =
                                 (Parsetree.PVarExp
                                    (Parsetree.PSimpleVar (15, "i")));
                                 oper = Parsetree.DivideOp;
                                 right = (Parsetree.PIntExp 10)}
                                ]};
                             Parsetree.PCallExp {func = (0, "print");
                               args =
                               [Parsetree.PCallExp {func = (4, "chr");
                                  args =
                                  [Parsetree.POpExp {
                                     left =
                                     (Parsetree.PVarExp
                                        (Parsetree.PSimpleVar (15, "i")));
                                     oper = Parsetree.MinusOp;
                                     right =
                                     Parsetree.POpExp {
                                       left =
                                       Parsetree.POpExp {
                                         left =
                                         (Parsetree.PVarExp
                                            (Parsetree.PSimpleVar (15, "i")));
                                         oper = Parsetree.DivideOp;
                                         right =
                                         Parsetree.POpExp {
                                           left = (Parsetree.PIntExp 10);
                                           oper = Parsetree.TimesOp;
                                           right = (Parsetree.PIntExp 10)}};
                                       oper = Parsetree.PlusOp;
                                       right =
                                       Parsetree.PCallExp {func = (3, "ord");
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
                   left = (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i")));
                   oper = Parsetree.LtOp; right = (Parsetree.PIntExp 0)};
                 then_ =
                 (Parsetree.PSeqExp
                    [Parsetree.PCallExp {func = (0, "print");
                       args = [(Parsetree.PStringExp "-")]};
                      Parsetree.PCallExp {func = (30, "f");
                        args =
                        [Parsetree.POpExp {left = (Parsetree.PIntExp 0);
                           oper = Parsetree.MinusOp;
                           right =
                           (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i")))}
                          ]}
                      ]);
                 else_ =
                 (Some Parsetree.PIfExp {
                         test =
                         Parsetree.POpExp {
                           left =
                           (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i")));
                           oper = Parsetree.GtOp; right = (Parsetree.PIntExp 0)};
                         then_ =
                         Parsetree.PCallExp {func = (30, "f");
                           args =
                           [(Parsetree.PVarExp (Parsetree.PSimpleVar (15, "i")))
                             ]};
                         else_ =
                         (Some Parsetree.PCallExp {func = (0, "print");
                                 args = [(Parsetree.PStringExp "0")]})})}}
             };
           { Parsetree.pfun_name = (31, "printlist");
             pfun_params =
             [{ Parsetree.pfd_name = (32, "l"); pfd_escape = ref (true);
                pfd_type = (20, "list") }
               ];
             pfun_result = None;
             pfun_body =
             Parsetree.PIfExp {
               test =
               Parsetree.POpExp {
                 left = (Parsetree.PVarExp (Parsetree.PSimpleVar (32, "l")));
                 oper = Parsetree.EqOp; right = Parsetree.PNilExp};
               then_ =
               Parsetree.PCallExp {func = (0, "print");
                 args = [(Parsetree.PStringExp "\\n")]};
               else_ =
               (Some (Parsetree.PSeqExp
                        [Parsetree.PCallExp {func = (29, "printint");
                           args =
                           [(Parsetree.PVarExp
                               (Parsetree.PFieldVar (
                                  (Parsetree.PSimpleVar (32, "l")),
                                  (21, "first"))))
                             ]};
                          Parsetree.PCallExp {func = (0, "print");
                            args = [(Parsetree.PStringExp " ")]};
                          Parsetree.PCallExp {func = (31, "printlist");
                            args =
                            [(Parsetree.PVarExp
                                (Parsetree.PFieldVar (
                                   (Parsetree.PSimpleVar (32, "l")),
                                   (22, "rest"))))
                              ]}
                          ]))}
             }
           ]);
      Parsetree.PVarDec {name = (33, "list1"); escape = ref (true);
        type_ = None;
        init = Parsetree.PCallExp {func = (23, "readlist"); args = []}};
      Parsetree.PVarDec {name = (34, "list2"); escape = ref (true);
        type_ = None;
        init =
        (Parsetree.PSeqExp
           [Parsetree.PAssignExp {var = (Parsetree.PSimpleVar (13, "buffer"));
              exp = Parsetree.PCallExp {func = (2, "getchar"); args = []}};
             Parsetree.PCallExp {func = (23, "readlist"); args = []}])}
      ];
    body =
    Parsetree.PCallExp {func = (31, "printlist");
      args =
      [Parsetree.PCallExp {func = (26, "merge");
         args =
         [(Parsetree.PVarExp (Parsetree.PSimpleVar (33, "list1")));
           (Parsetree.PVarExp (Parsetree.PSimpleVar (34, "list2")))]}
        ]}}
