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
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "any"); td_type = {(any : int)} }]);
        Typedtree.TVarDec {name = (13, "buffer"); escape = ref (true);
          type_ = string;
          init =
          { Typedtree.exp_desc =
            Typedtree.TCallExp {func = (2, "getchar"); args = []};
            exp_type = string }};
        (Typedtree.TFunctionDec
           [{ Typedtree.fun_name = (14, "readint");
              fun_params =
              [{ Typedtree.fd_name = (12, "any"); fd_escape = ref (true);
                 fd_type = {(any : int)} }
                ];
              fun_result = int;
              fun_body =
              { Typedtree.exp_desc =
                Typedtree.TLetExp {
                  decs =
                  [Typedtree.TVarDec {name = (15, "i"); escape = ref (true);
                     type_ = int;
                     init =
                     { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                       exp_type = int }};
                    (Typedtree.TFunctionDec
                       [{ Typedtree.fun_name = (16, "isdigit");
                          fun_params =
                          [{ Typedtree.fd_name = (17, "s");
                             fd_escape = ref (true); fd_type = string }
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
                                    Typedtree.TCallExp {func = (3, "ord");
                                      args =
                                      [{ Typedtree.exp_desc =
                                         (Typedtree.TVarExp
                                            { Typedtree.var_desc =
                                              (Typedtree.TSimpleVar
                                                 (13, "buffer"));
                                              var_type = string });
                                         exp_type = string }
                                        ]};
                                    exp_type = int };
                                  oper = Parsetree.GeOp;
                                  right =
                                  { Typedtree.exp_desc =
                                    Typedtree.TCallExp {func = (3, "ord");
                                      args =
                                      [{ Typedtree.exp_desc =
                                         (Typedtree.TStringExp "0");
                                         exp_type = string }
                                        ]};
                                    exp_type = int }};
                                exp_type = int };
                              then_ =
                              { Typedtree.exp_desc =
                                Typedtree.TOpExp {
                                  left =
                                  { Typedtree.exp_desc =
                                    Typedtree.TCallExp {func = (3, "ord");
                                      args =
                                      [{ Typedtree.exp_desc =
                                         (Typedtree.TVarExp
                                            { Typedtree.var_desc =
                                              (Typedtree.TSimpleVar
                                                 (13, "buffer"));
                                              var_type = string });
                                         exp_type = string }
                                        ]};
                                    exp_type = int };
                                  oper = Parsetree.LeOp;
                                  right =
                                  { Typedtree.exp_desc =
                                    Typedtree.TCallExp {func = (3, "ord");
                                      args =
                                      [{ Typedtree.exp_desc =
                                         (Typedtree.TStringExp "9");
                                         exp_type = string }
                                        ]};
                                    exp_type = int }};
                                exp_type = int };
                              else_ =
                              (Some { Typedtree.exp_desc =
                                      (Typedtree.TIntExp 0); exp_type = int })};
                            exp_type = int }
                          };
                         { Typedtree.fun_name = (18, "skipto");
                           fun_params = []; fun_result = unit;
                           fun_body =
                           { Typedtree.exp_desc =
                             Typedtree.TWhileExp {
                               test =
                               { Typedtree.exp_desc =
                                 Typedtree.TIfExp {
                                   test =
                                   { Typedtree.exp_desc =
                                     Typedtree.TOpExp {
                                       left =
                                       { Typedtree.exp_desc =
                                         (Typedtree.TVarExp
                                            { Typedtree.var_desc =
                                              (Typedtree.TSimpleVar
                                                 (13, "buffer"));
                                              var_type = string });
                                         exp_type = string };
                                       oper = Parsetree.EqOp;
                                       right =
                                       { Typedtree.exp_desc =
                                         (Typedtree.TStringExp " ");
                                         exp_type = string }};
                                     exp_type = int };
                                   then_ =
                                   { Typedtree.exp_desc = (Typedtree.TIntExp 1);
                                     exp_type = int };
                                   else_ =
                                   (Some { Typedtree.exp_desc =
                                           Typedtree.TOpExp {
                                             left =
                                             { Typedtree.exp_desc =
                                               (Typedtree.TVarExp
                                                  { Typedtree.var_desc =
                                                    (Typedtree.TSimpleVar
                                                       (13, "buffer"));
                                                    var_type = string });
                                               exp_type = string };
                                             oper = Parsetree.EqOp;
                                             right =
                                             { Typedtree.exp_desc =
                                               (Typedtree.TStringExp "\\n");
                                               exp_type = string }};
                                           exp_type = int })};
                                 exp_type = int };
                               body =
                               { Typedtree.exp_desc =
                                 Typedtree.TAssignExp {
                                   var =
                                   { Typedtree.var_desc =
                                     (Typedtree.TSimpleVar (13, "buffer"));
                                     var_type = string };
                                   exp =
                                   { Typedtree.exp_desc =
                                     Typedtree.TCallExp {func = (2, "getchar");
                                       args = []};
                                     exp_type = string }};
                                 exp_type = unit }};
                             exp_type = unit }
                           }
                         ])
                    ];
                  body =
                  { Typedtree.exp_desc =
                    (Typedtree.TSeqExp
                       [{ Typedtree.exp_desc =
                          (Typedtree.TVarExp
                             { Typedtree.var_desc =
                               (Typedtree.TSimpleVar (15, "i")); var_type = int
                               });
                          exp_type = int };
                         { Typedtree.exp_desc =
                           Typedtree.TWhileExp {
                             test =
                             { Typedtree.exp_desc =
                               Typedtree.TCallExp {func = (16, "isdigit");
                                 args =
                                 [{ Typedtree.exp_desc =
                                    (Typedtree.TVarExp
                                       { Typedtree.var_desc =
                                         (Typedtree.TSimpleVar (13, "buffer"));
                                         var_type = string });
                                    exp_type = string }
                                   ]};
                               exp_type = int };
                             body =
                             { Typedtree.exp_desc =
                               (Typedtree.TSeqExp
                                  [{ Typedtree.exp_desc =
                                     Typedtree.TAssignExp {
                                       var =
                                       { Typedtree.var_desc =
                                         (Typedtree.TSimpleVar (13, "buffer"));
                                         var_type = string };
                                       exp =
                                       { Typedtree.exp_desc =
                                         Typedtree.TCallExp {
                                           func = (2, "getchar"); args = []};
                                         exp_type = string }};
                                     exp_type = unit };
                                    { Typedtree.exp_desc =
                                      Typedtree.TAssignExp {
                                        var =
                                        { Typedtree.var_desc =
                                          (Typedtree.TSimpleVar (15, "i"));
                                          var_type = int };
                                        exp =
                                        { Typedtree.exp_desc =
                                          Typedtree.TOpExp {
                                            left =
                                            { Typedtree.exp_desc =
                                              Typedtree.TOpExp {
                                                left =
                                                { Typedtree.exp_desc =
                                                  Typedtree.TOpExp {
                                                    left =
                                                    { Typedtree.exp_desc =
                                                      (Typedtree.TVarExp
                                                         { Typedtree.var_desc =
                                                           (Typedtree.TSimpleVar
                                                              (15, "i"));
                                                           var_type = int });
                                                      exp_type = int };
                                                    oper = Parsetree.TimesOp;
                                                    right =
                                                    { Typedtree.exp_desc =
                                                      (Typedtree.TIntExp 10);
                                                      exp_type = int }};
                                                  exp_type = int };
                                                oper = Parsetree.PlusOp;
                                                right =
                                                { Typedtree.exp_desc =
                                                  Typedtree.TCallExp {
                                                    func = (3, "ord");
                                                    args =
                                                    [{ Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (13, "buffer"));
                                                            var_type = string });
                                                       exp_type = string }
                                                      ]};
                                                  exp_type = int }};
                                              exp_type = int };
                                            oper = Parsetree.MinusOp;
                                            right =
                                            { Typedtree.exp_desc =
                                              Typedtree.TCallExp {
                                                func = (3, "ord");
                                                args =
                                                [{ Typedtree.exp_desc =
                                                   (Typedtree.TStringExp "0");
                                                   exp_type = string }
                                                  ]};
                                              exp_type = int }};
                                          exp_type = int }};
                                      exp_type = unit }
                                    ]);
                               exp_type = unit }};
                           exp_type = unit };
                         { Typedtree.exp_desc =
                           Typedtree.TAssignExp {
                             var =
                             { Typedtree.var_desc =
                               (Typedtree.TFieldVar (
                                  { Typedtree.var_desc =
                                    (Typedtree.TSimpleVar (12, "any"));
                                    var_type = {(any : int)} },
                                  (12, "any")));
                               var_type = int };
                             exp =
                             { Typedtree.exp_desc =
                               Typedtree.TCallExp {func = (16, "isdigit");
                                 args =
                                 [{ Typedtree.exp_desc =
                                    (Typedtree.TVarExp
                                       { Typedtree.var_desc =
                                         (Typedtree.TSimpleVar (13, "buffer"));
                                         var_type = string });
                                    exp_type = string }
                                   ]};
                               exp_type = int }};
                           exp_type = unit };
                         { Typedtree.exp_desc =
                           Typedtree.TCallExp {func = (18, "skipto"); args = []};
                           exp_type = unit }
                         ]);
                    exp_type = int }};
                exp_type = int }
              }
             ]);
        (Typedtree.TTypeDec
           [{ Typedtree.td_name = (20, "list");
              td_type = {(first : int)(rest : (Name  list))} }
             ]);
        (Typedtree.TFunctionDec
           [{ Typedtree.fun_name = (23, "readlist"); fun_params = [];
              fun_result = {(first : int)(rest : (Name  list))};
              fun_body =
              { Typedtree.exp_desc =
                Typedtree.TLetExp {
                  decs =
                  [Typedtree.TVarDec {name = (12, "any"); escape = ref (true);
                     type_ = {(any : int)};
                     init =
                     { Typedtree.exp_desc =
                       Typedtree.TRecordExp {type_ = {(any : int)};
                         fields =
                         [((12, "any"), int,
                           { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                             exp_type = int })
                           ]};
                       exp_type = {(any : int)} }};
                    Typedtree.TVarDec {name = (15, "i"); escape = ref (true);
                      type_ = int;
                      init =
                      { Typedtree.exp_desc =
                        Typedtree.TCallExp {func = (14, "readint");
                          args =
                          [{ Typedtree.exp_desc =
                             (Typedtree.TVarExp
                                { Typedtree.var_desc =
                                  (Typedtree.TSimpleVar (12, "any"));
                                  var_type = {(any : int)} });
                             exp_type = {(any : int)} }
                            ]};
                        exp_type = int }}
                    ];
                  body =
                  { Typedtree.exp_desc =
                    Typedtree.TIfExp {
                      test =
                      { Typedtree.exp_desc =
                        (Typedtree.TVarExp
                           { Typedtree.var_desc =
                             (Typedtree.TFieldVar (
                                { Typedtree.var_desc =
                                  (Typedtree.TSimpleVar (12, "any"));
                                  var_type = {(any : int)} },
                                (12, "any")));
                             var_type = int });
                        exp_type = int };
                      then_ =
                      { Typedtree.exp_desc =
                        Typedtree.TRecordExp {
                          type_ = {(first : int)(rest : (Name  list))};
                          fields =
                          [((21, "first"), int,
                            { Typedtree.exp_desc =
                              (Typedtree.TVarExp
                                 { Typedtree.var_desc =
                                   (Typedtree.TSimpleVar (15, "i"));
                                   var_type = int });
                              exp_type = int });
                            ((22, "rest"), (Name  list),
                             { Typedtree.exp_desc =
                               Typedtree.TCallExp {func = (23, "readlist");
                                 args = []};
                               exp_type = {(first : int)(rest : (Name  list))}
                               })
                            ]};
                        exp_type = {(first : int)(rest : (Name  list))} };
                      else_ =
                      (Some { Typedtree.exp_desc = Typedtree.TNilExp;
                              exp_type = nil })};
                    exp_type = {(first : int)(rest : (Name  list))} }};
                exp_type = {(first : int)(rest : (Name  list))} }
              };
             { Typedtree.fun_name = (26, "merge");
               fun_params =
               [{ Typedtree.fd_name = (27, "a"); fd_escape = ref (true);
                  fd_type = {(first : int)(rest : (Name  list))} };
                 { Typedtree.fd_name = (28, "b"); fd_escape = ref (true);
                   fd_type = {(first : int)(rest : (Name  list))} }
                 ];
               fun_result = {(first : int)(rest : (Name  list))};
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
                              (Typedtree.TSimpleVar (27, "a"));
                              var_type = {(first : int)(rest : (Name  list))} });
                         exp_type = {(first : int)(rest : (Name  list))} };
                       oper = Parsetree.EqOp;
                       right =
                       { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil
                         }};
                     exp_type = int };
                   then_ =
                   { Typedtree.exp_desc =
                     (Typedtree.TVarExp
                        { Typedtree.var_desc = (Typedtree.TSimpleVar (28, "b"));
                          var_type = {(first : int)(rest : (Name  list))} });
                     exp_type = {(first : int)(rest : (Name  list))} };
                   else_ =
                   (Some { Typedtree.exp_desc =
                           Typedtree.TIfExp {
                             test =
                             { Typedtree.exp_desc =
                               Typedtree.TOpExp {
                                 left =
                                 { Typedtree.exp_desc =
                                   (Typedtree.TVarExp
                                      { Typedtree.var_desc =
                                        (Typedtree.TSimpleVar (28, "b"));
                                        var_type =
                                        {(first : int)(rest : (Name  list))} });
                                   exp_type =
                                   {(first : int)(rest : (Name  list))} };
                                 oper = Parsetree.EqOp;
                                 right =
                                 { Typedtree.exp_desc = Typedtree.TNilExp;
                                   exp_type = nil }};
                               exp_type = int };
                             then_ =
                             { Typedtree.exp_desc =
                               (Typedtree.TVarExp
                                  { Typedtree.var_desc =
                                    (Typedtree.TSimpleVar (27, "a"));
                                    var_type =
                                    {(first : int)(rest : (Name  list))} });
                               exp_type = {(first : int)(rest : (Name  list))}
                               };
                             else_ =
                             (Some { Typedtree.exp_desc =
                                     Typedtree.TIfExp {
                                       test =
                                       { Typedtree.exp_desc =
                                         Typedtree.TOpExp {
                                           left =
                                           { Typedtree.exp_desc =
                                             (Typedtree.TVarExp
                                                { Typedtree.var_desc =
                                                  (Typedtree.TFieldVar (
                                                     { Typedtree.var_desc =
                                                       (Typedtree.TSimpleVar
                                                          (27, "a"));
                                                       var_type =
                                                       {(first : int)(rest : (Name  list))}
                                                       },
                                                     (21, "first")));
                                                  var_type = int });
                                             exp_type = int };
                                           oper = Parsetree.LtOp;
                                           right =
                                           { Typedtree.exp_desc =
                                             (Typedtree.TVarExp
                                                { Typedtree.var_desc =
                                                  (Typedtree.TFieldVar (
                                                     { Typedtree.var_desc =
                                                       (Typedtree.TSimpleVar
                                                          (28, "b"));
                                                       var_type =
                                                       {(first : int)(rest : (Name  list))}
                                                       },
                                                     (21, "first")));
                                                  var_type = int });
                                             exp_type = int }};
                                         exp_type = int };
                                       then_ =
                                       { Typedtree.exp_desc =
                                         Typedtree.TRecordExp {
                                           type_ =
                                           {(first : int)(rest : (Name  list))};
                                           fields =
                                           [((21, "first"), int,
                                             { Typedtree.exp_desc =
                                               (Typedtree.TVarExp
                                                  { Typedtree.var_desc =
                                                    (Typedtree.TFieldVar (
                                                       { Typedtree.var_desc =
                                                         (Typedtree.TSimpleVar
                                                            (27, "a"));
                                                         var_type =
                                                         {(first : int)(rest : (Name  list))}
                                                         },
                                                       (21, "first")));
                                                    var_type = int });
                                               exp_type = int });
                                             ((22, "rest"), (Name  list),
                                              { Typedtree.exp_desc =
                                                Typedtree.TCallExp {
                                                  func = (26, "merge");
                                                  args =
                                                  [{ Typedtree.exp_desc =
                                                     (Typedtree.TVarExp
                                                        { Typedtree.var_desc =
                                                          (Typedtree.TFieldVar (
                                                             { Typedtree.var_desc =
                                                               (Typedtree.TSimpleVar
                                                                  (27, "a"));
                                                               var_type =
                                                               {(first : int)(rest : (Name  list))}
                                                               },
                                                             (22, "rest")));
                                                          var_type =
                                                          {(first : int)(rest : (Name  list))}
                                                          });
                                                     exp_type =
                                                     {(first : int)(rest : (Name  list))}
                                                     };
                                                    { Typedtree.exp_desc =
                                                      (Typedtree.TVarExp
                                                         { Typedtree.var_desc =
                                                           (Typedtree.TSimpleVar
                                                              (28, "b"));
                                                           var_type =
                                                           {(first : int)(rest : (Name  list))}
                                                           });
                                                      exp_type =
                                                      {(first : int)(rest : (Name  list))}
                                                      }
                                                    ]};
                                                exp_type =
                                                {(first : int)(rest : (Name  list))}
                                                })
                                             ]};
                                         exp_type =
                                         {(first : int)(rest : (Name  list))} };
                                       else_ =
                                       (Some { Typedtree.exp_desc =
                                               Typedtree.TRecordExp {
                                                 type_ =
                                                 {(first : int)(rest : (Name  list))};
                                                 fields =
                                                 [((21, "first"), int,
                                                   { Typedtree.exp_desc =
                                                     (Typedtree.TVarExp
                                                        { Typedtree.var_desc =
                                                          (Typedtree.TFieldVar (
                                                             { Typedtree.var_desc =
                                                               (Typedtree.TSimpleVar
                                                                  (28, "b"));
                                                               var_type =
                                                               {(first : int)(rest : (Name  list))}
                                                               },
                                                             (21, "first")));
                                                          var_type = int });
                                                     exp_type = int });
                                                   ((22, "rest"), (Name  list),
                                                    { Typedtree.exp_desc =
                                                      Typedtree.TCallExp {
                                                        func = (26, "merge");
                                                        args =
                                                        [{ Typedtree.exp_desc =
                                                           (Typedtree.TVarExp
                                                              { Typedtree.var_desc =
                                                                (Typedtree.TSimpleVar
                                                                   (27, "a"));
                                                                var_type =
                                                                {(first : int)(rest : (Name  list))}
                                                                });
                                                           exp_type =
                                                           {(first : int)(rest : (Name  list))}
                                                           };
                                                          { Typedtree.exp_desc =
                                                            (Typedtree.TVarExp
                                                               { Typedtree.var_desc =
                                                                 (Typedtree.TFieldVar (
                                                                    { Typedtree.var_desc =
                                                                      (
                                                                      Typedtree.TSimpleVar
                                                                      (28, "b"));
                                                                      var_type =
                                                                      {(first : int)(rest : (Name  list))}
                                                                      },
                                                                    (22, "rest")
                                                                    ));
                                                                 var_type =
                                                                 {(first : int)(rest : (Name  list))}
                                                                 });
                                                            exp_type =
                                                            {(first : int)(rest : (Name  list))}
                                                            }
                                                          ]};
                                                      exp_type =
                                                      {(first : int)(rest : (Name  list))}
                                                      })
                                                   ]};
                                               exp_type =
                                               {(first : int)(rest : (Name  list))}
                                               })};
                                     exp_type =
                                     {(first : int)(rest : (Name  list))} })};
                           exp_type = {(first : int)(rest : (Name  list))} })};
                 exp_type = {(first : int)(rest : (Name  list))} }
               };
             { Typedtree.fun_name = (29, "printint");
               fun_params =
               [{ Typedtree.fd_name = (15, "i"); fd_escape = ref (true);
                  fd_type = int }
                 ];
               fun_result = unit;
               fun_body =
               { Typedtree.exp_desc =
                 Typedtree.TLetExp {
                   decs =
                   [(Typedtree.TFunctionDec
                       [{ Typedtree.fun_name = (30, "f");
                          fun_params =
                          [{ Typedtree.fd_name = (15, "i");
                             fd_escape = ref (true); fd_type = int }
                            ];
                          fun_result = unit;
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
                                         (Typedtree.TSimpleVar (15, "i"));
                                         var_type = int });
                                    exp_type = int };
                                  oper = Parsetree.GtOp;
                                  right =
                                  { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                                    exp_type = int }};
                                exp_type = int };
                              then_ =
                              { Typedtree.exp_desc =
                                (Typedtree.TSeqExp
                                   [{ Typedtree.exp_desc =
                                      Typedtree.TCallExp {func = (0, "print");
                                        args =
                                        [{ Typedtree.exp_desc =
                                           Typedtree.TCallExp {
                                             func = (4, "chr");
                                             args =
                                             [{ Typedtree.exp_desc =
                                                Typedtree.TOpExp {
                                                  left =
                                                  { Typedtree.exp_desc =
                                                    (Typedtree.TVarExp
                                                       { Typedtree.var_desc =
                                                         (Typedtree.TSimpleVar
                                                            (15, "i"));
                                                         var_type = int });
                                                    exp_type = int };
                                                  oper = Parsetree.MinusOp;
                                                  right =
                                                  { Typedtree.exp_desc =
                                                    Typedtree.TOpExp {
                                                      left =
                                                      { Typedtree.exp_desc =
                                                        Typedtree.TOpExp {
                                                          left =
                                                          { Typedtree.exp_desc =
                                                            (Typedtree.TVarExp
                                                               { Typedtree.var_desc =
                                                                 (Typedtree.TSimpleVar
                                                                    (15, "i"));
                                                                 var_type = int
                                                                 });
                                                            exp_type = int };
                                                          oper =
                                                          Parsetree.DivideOp;
                                                          right =
                                                          { Typedtree.exp_desc =
                                                            Typedtree.TOpExp {
                                                              left =
                                                              { Typedtree.exp_desc =
                                                                (Typedtree.TIntExp
                                                                   10);
                                                                exp_type = int
                                                                };
                                                              oper =
                                                              Parsetree.TimesOp;
                                                              right =
                                                              { Typedtree.exp_desc =
                                                                (Typedtree.TIntExp
                                                                   10);
                                                                exp_type = int
                                                                }};
                                                            exp_type = int }};
                                                        exp_type = int };
                                                      oper = Parsetree.PlusOp;
                                                      right =
                                                      { Typedtree.exp_desc =
                                                        Typedtree.TCallExp {
                                                          func = (3, "ord");
                                                          args =
                                                          [{ Typedtree.exp_desc =
                                                             (Typedtree.TStringExp
                                                                "0");
                                                             exp_type = string
                                                             }
                                                            ]};
                                                        exp_type = int }};
                                                    exp_type = int }};
                                                exp_type = int }
                                               ]};
                                           exp_type = string }
                                          ]};
                                      exp_type = unit };
                                     { Typedtree.exp_desc =
                                       Typedtree.TCallExp {func = (30, "f");
                                         args =
                                         [{ Typedtree.exp_desc =
                                            Typedtree.TOpExp {
                                              left =
                                              { Typedtree.exp_desc =
                                                (Typedtree.TVarExp
                                                   { Typedtree.var_desc =
                                                     (Typedtree.TSimpleVar
                                                        (15, "i"));
                                                     var_type = int });
                                                exp_type = int };
                                              oper = Parsetree.DivideOp;
                                              right =
                                              { Typedtree.exp_desc =
                                                (Typedtree.TIntExp 10);
                                                exp_type = int }};
                                            exp_type = int }
                                           ]};
                                       exp_type = unit }
                                     ]);
                                exp_type = unit };
                              else_ = None};
                            exp_type = unit }
                          }
                         ])
                     ];
                   body =
                   { Typedtree.exp_desc =
                     Typedtree.TIfExp {
                       test =
                       { Typedtree.exp_desc =
                         Typedtree.TOpExp {
                           left =
                           { Typedtree.exp_desc =
                             (Typedtree.TVarExp
                                { Typedtree.var_desc =
                                  (Typedtree.TSimpleVar (15, "i"));
                                  var_type = int });
                             exp_type = int };
                           oper = Parsetree.LtOp;
                           right =
                           { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                             exp_type = int }};
                         exp_type = int };
                       then_ =
                       { Typedtree.exp_desc =
                         (Typedtree.TSeqExp
                            [{ Typedtree.exp_desc =
                               Typedtree.TCallExp {func = (30, "f");
                                 args =
                                 [{ Typedtree.exp_desc =
                                    Typedtree.TOpExp {
                                      left =
                                      { Typedtree.exp_desc =
                                        (Typedtree.TIntExp 0); exp_type = int };
                                      oper = Parsetree.MinusOp;
                                      right =
                                      { Typedtree.exp_desc =
                                        (Typedtree.TVarExp
                                           { Typedtree.var_desc =
                                             (Typedtree.TSimpleVar (15, "i"));
                                             var_type = int });
                                        exp_type = int }};
                                    exp_type = int }
                                   ]};
                               exp_type = unit };
                              { Typedtree.exp_desc =
                                Typedtree.TCallExp {func = (0, "print");
                                  args =
                                  [{ Typedtree.exp_desc =
                                     (Typedtree.TStringExp "-");
                                     exp_type = string }
                                    ]};
                                exp_type = unit }
                              ]);
                         exp_type = unit };
                       else_ =
                       (Some { Typedtree.exp_desc =
                               Typedtree.TIfExp {
                                 test =
                                 { Typedtree.exp_desc =
                                   Typedtree.TOpExp {
                                     left =
                                     { Typedtree.exp_desc =
                                       (Typedtree.TVarExp
                                          { Typedtree.var_desc =
                                            (Typedtree.TSimpleVar (15, "i"));
                                            var_type = int });
                                       exp_type = int };
                                     oper = Parsetree.GtOp;
                                     right =
                                     { Typedtree.exp_desc =
                                       (Typedtree.TIntExp 0); exp_type = int }};
                                   exp_type = int };
                                 then_ =
                                 { Typedtree.exp_desc =
                                   Typedtree.TCallExp {func = (30, "f");
                                     args =
                                     [{ Typedtree.exp_desc =
                                        (Typedtree.TVarExp
                                           { Typedtree.var_desc =
                                             (Typedtree.TSimpleVar (15, "i"));
                                             var_type = int });
                                        exp_type = int }
                                       ]};
                                   exp_type = unit };
                                 else_ =
                                 (Some { Typedtree.exp_desc =
                                         Typedtree.TCallExp {
                                           func = (0, "print");
                                           args =
                                           [{ Typedtree.exp_desc =
                                              (Typedtree.TStringExp "0");
                                              exp_type = string }
                                             ]};
                                         exp_type = unit })};
                               exp_type = unit })};
                     exp_type = unit }};
                 exp_type = unit }
               };
             { Typedtree.fun_name = (31, "printlist");
               fun_params =
               [{ Typedtree.fd_name = (32, "l"); fd_escape = ref (true);
                  fd_type = {(first : int)(rest : (Name  list))} }
                 ];
               fun_result = unit;
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
                              (Typedtree.TSimpleVar (32, "l"));
                              var_type = {(first : int)(rest : (Name  list))} });
                         exp_type = {(first : int)(rest : (Name  list))} };
                       oper = Parsetree.EqOp;
                       right =
                       { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil
                         }};
                     exp_type = int };
                   then_ =
                   { Typedtree.exp_desc =
                     Typedtree.TCallExp {func = (0, "print");
                       args =
                       [{ Typedtree.exp_desc = (Typedtree.TStringExp "\\n");
                          exp_type = string }
                         ]};
                     exp_type = unit };
                   else_ =
                   (Some { Typedtree.exp_desc =
                           (Typedtree.TSeqExp
                              [{ Typedtree.exp_desc =
                                 Typedtree.TCallExp {func = (31, "printlist");
                                   args =
                                   [{ Typedtree.exp_desc =
                                      (Typedtree.TVarExp
                                         { Typedtree.var_desc =
                                           (Typedtree.TFieldVar (
                                              { Typedtree.var_desc =
                                                (Typedtree.TSimpleVar (32, "l"));
                                                var_type =
                                                {(first : int)(rest : (Name  list))}
                                                },
                                              (22, "rest")));
                                           var_type =
                                           {(first : int)(rest : (Name  list))}
                                           });
                                      exp_type =
                                      {(first : int)(rest : (Name  list))} }
                                     ]};
                                 exp_type = unit };
                                { Typedtree.exp_desc =
                                  Typedtree.TCallExp {func = (0, "print");
                                    args =
                                    [{ Typedtree.exp_desc =
                                       (Typedtree.TStringExp " ");
                                       exp_type = string }
                                      ]};
                                  exp_type = unit };
                                { Typedtree.exp_desc =
                                  Typedtree.TCallExp {func = (29, "printint");
                                    args =
                                    [{ Typedtree.exp_desc =
                                       (Typedtree.TVarExp
                                          { Typedtree.var_desc =
                                            (Typedtree.TFieldVar (
                                               { Typedtree.var_desc =
                                                 (Typedtree.TSimpleVar
                                                    (32, "l"));
                                                 var_type =
                                                 {(first : int)(rest : (Name  list))}
                                                 },
                                               (21, "first")));
                                            var_type = int });
                                       exp_type = int }
                                      ]};
                                  exp_type = unit }
                                ]);
                           exp_type = unit })};
                 exp_type = unit }
               }
             ]);
        Typedtree.TVarDec {name = (33, "list1"); escape = ref (true);
          type_ = {(first : int)(rest : (Name  list))};
          init =
          { Typedtree.exp_desc =
            Typedtree.TCallExp {func = (23, "readlist"); args = []};
            exp_type = {(first : int)(rest : (Name  list))} }};
        Typedtree.TVarDec {name = (34, "list2"); escape = ref (true);
          type_ = {(first : int)(rest : (Name  list))};
          init =
          { Typedtree.exp_desc =
            (Typedtree.TSeqExp
               [{ Typedtree.exp_desc =
                  Typedtree.TCallExp {func = (23, "readlist"); args = []};
                  exp_type = {(first : int)(rest : (Name  list))} };
                 { Typedtree.exp_desc =
                   Typedtree.TAssignExp {
                     var =
                     { Typedtree.var_desc =
                       (Typedtree.TSimpleVar (13, "buffer")); var_type = string
                       };
                     exp =
                     { Typedtree.exp_desc =
                       Typedtree.TCallExp {func = (2, "getchar"); args = []};
                       exp_type = string }};
                   exp_type = unit }
                 ]);
            exp_type = {(first : int)(rest : (Name  list))} }}
        ];
      body =
      { Typedtree.exp_desc =
        Typedtree.TCallExp {func = (31, "printlist");
          args =
          [{ Typedtree.exp_desc =
             Typedtree.TCallExp {func = (26, "merge");
               args =
               [{ Typedtree.exp_desc =
                  (Typedtree.TVarExp
                     { Typedtree.var_desc =
                       (Typedtree.TSimpleVar (33, "list1"));
                       var_type = {(first : int)(rest : (Name  list))} });
                  exp_type = {(first : int)(rest : (Name  list))} };
                 { Typedtree.exp_desc =
                   (Typedtree.TVarExp
                      { Typedtree.var_desc =
                        (Typedtree.TSimpleVar (34, "list2"));
                        var_type = {(first : int)(rest : (Name  list))} });
                   exp_type = {(first : int)(rest : (Name  list))} }
                 ]};
             exp_type = {(first : int)(rest : (Name  list))} }
            ]};
        exp_type = unit }};
    exp_type = unit }
