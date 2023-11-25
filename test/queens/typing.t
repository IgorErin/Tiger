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
  	
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [Typedtree.TVarDec {name = (12, "N"); escape = ref (true); type_ = int;
         init = { Typedtree.exp_desc = (Typedtree.TIntExp 8); exp_type = int }};
        (Typedtree.TTypeDec
           [{ Typedtree.td_name = (13, "intArray"); td_type = array of int }]);
        Typedtree.TVarDec {name = (14, "row"); escape = ref (true);
          type_ = array of int;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of int;
              size =
              { Typedtree.exp_desc =
                (Typedtree.TVarExp
                   { Typedtree.var_desc = (Typedtree.TSimpleVar (12, "N"));
                     var_type = int });
                exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of int }};
        Typedtree.TVarDec {name = (15, "col"); escape = ref (true);
          type_ = array of int;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of int;
              size =
              { Typedtree.exp_desc =
                (Typedtree.TVarExp
                   { Typedtree.var_desc = (Typedtree.TSimpleVar (12, "N"));
                     var_type = int });
                exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of int }};
        Typedtree.TVarDec {name = (16, "diag1"); escape = ref (true);
          type_ = array of int;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of int;
              size =
              { Typedtree.exp_desc =
                Typedtree.TOpExp {
                  left =
                  { Typedtree.exp_desc =
                    Typedtree.TOpExp {
                      left =
                      { Typedtree.exp_desc =
                        (Typedtree.TVarExp
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (12, "N")); var_type = int });
                        exp_type = int };
                      oper = `PlusOp;
                      right =
                      { Typedtree.exp_desc =
                        (Typedtree.TVarExp
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (12, "N")); var_type = int });
                        exp_type = int }};
                    exp_type = int };
                  oper = `MinusOp;
                  right =
                  { Typedtree.exp_desc = (Typedtree.TIntExp 1); exp_type = int
                    }};
                exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of int }};
        Typedtree.TVarDec {name = (17, "diag2"); escape = ref (true);
          type_ = array of int;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of int;
              size =
              { Typedtree.exp_desc =
                Typedtree.TOpExp {
                  left =
                  { Typedtree.exp_desc =
                    Typedtree.TOpExp {
                      left =
                      { Typedtree.exp_desc =
                        (Typedtree.TVarExp
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (12, "N")); var_type = int });
                        exp_type = int };
                      oper = `PlusOp;
                      right =
                      { Typedtree.exp_desc =
                        (Typedtree.TVarExp
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (12, "N")); var_type = int });
                        exp_type = int }};
                    exp_type = int };
                  oper = `MinusOp;
                  right =
                  { Typedtree.exp_desc = (Typedtree.TIntExp 1); exp_type = int
                    }};
                exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of int }};
        (Typedtree.TFunctionDec
           [{ Typedtree.fun_name = (18, "printboard"); fun_params = [];
              fun_result = unit;
              fun_body =
              { Typedtree.exp_desc =
                (Typedtree.TSeqExp
                   [{ Typedtree.exp_desc =
                      Typedtree.TForExp {var = (20, "i"); escape = ref (true);
                        lb =
                        { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                          exp_type = int };
                        hb =
                        { Typedtree.exp_desc =
                          Typedtree.TOpExp {
                            left =
                            { Typedtree.exp_desc =
                              (Typedtree.TVarExp
                                 { Typedtree.var_desc =
                                   (Typedtree.TSimpleVar (12, "N"));
                                   var_type = int });
                              exp_type = int };
                            oper = `MinusOp;
                            right =
                            { Typedtree.exp_desc = (Typedtree.TIntExp 1);
                              exp_type = int }};
                          exp_type = int };
                        body =
                        { Typedtree.exp_desc =
                          (Typedtree.TSeqExp
                             [{ Typedtree.exp_desc =
                                Typedtree.TForExp {var = (21, "j");
                                  escape = ref (true);
                                  lb =
                                  { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                                    exp_type = int };
                                  hb =
                                  { Typedtree.exp_desc =
                                    Typedtree.TOpExp {
                                      left =
                                      { Typedtree.exp_desc =
                                        (Typedtree.TVarExp
                                           { Typedtree.var_desc =
                                             (Typedtree.TSimpleVar (12, "N"));
                                             var_type = int });
                                        exp_type = int };
                                      oper = `MinusOp;
                                      right =
                                      { Typedtree.exp_desc =
                                        (Typedtree.TIntExp 1); exp_type = int }};
                                    exp_type = int };
                                  body =
                                  { Typedtree.exp_desc =
                                    Typedtree.TCallExp {func = (0, "print");
                                      args =
                                      [{ Typedtree.exp_desc =
                                         Typedtree.TIfExp {
                                           test =
                                           { Typedtree.exp_desc =
                                             Typedtree.TOpExp {
                                               left =
                                               { Typedtree.exp_desc =
                                                 (Typedtree.TVarExp
                                                    { Typedtree.var_desc =
                                                      (Typedtree.TSubscriptVar (
                                                         { Typedtree.var_desc =
                                                           (Typedtree.TSimpleVar
                                                              (15, "col"));
                                                           var_type =
                                                           array of int },
                                                         { Typedtree.exp_desc =
                                                           (Typedtree.TVarExp
                                                              { Typedtree.var_desc =
                                                                (Typedtree.TSimpleVar
                                                                   (20, "i"));
                                                                var_type = int
                                                                });
                                                           exp_type = int }
                                                         ));
                                                      var_type = int });
                                                 exp_type = int };
                                               oper = `EqOp;
                                               right =
                                               { Typedtree.exp_desc =
                                                 (Typedtree.TVarExp
                                                    { Typedtree.var_desc =
                                                      (Typedtree.TSimpleVar
                                                         (21, "j"));
                                                      var_type = int });
                                                 exp_type = int }};
                                             exp_type = int };
                                           then_ =
                                           { Typedtree.exp_desc =
                                             (Typedtree.TStringExp " O");
                                             exp_type = string };
                                           else_ =
                                           (Some { Typedtree.exp_desc =
                                                   (Typedtree.TStringExp " .");
                                                   exp_type = string })};
                                         exp_type = string }
                                        ]};
                                    exp_type = unit }};
                                exp_type = unit };
                               { Typedtree.exp_desc =
                                 Typedtree.TCallExp {func = (0, "print");
                                   args =
                                   [{ Typedtree.exp_desc =
                                      (Typedtree.TStringExp "\\n");
                                      exp_type = string }
                                     ]};
                                 exp_type = unit }
                               ]);
                          exp_type = unit }};
                      exp_type = unit };
                     { Typedtree.exp_desc =
                       Typedtree.TCallExp {func = (0, "print");
                         args =
                         [{ Typedtree.exp_desc = (Typedtree.TStringExp "\\n");
                            exp_type = string }
                           ]};
                       exp_type = unit }
                     ]);
                exp_type = unit }
              };
             { Typedtree.fun_name = (23, "try");
               fun_params =
               [{ Typedtree.fd_name = (24, "c"); fd_escape = ref (true);
                  fd_type = int }
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
                              (Typedtree.TSimpleVar (24, "c")); var_type = int
                              });
                         exp_type = int };
                       oper = `EqOp;
                       right =
                       { Typedtree.exp_desc =
                         (Typedtree.TVarExp
                            { Typedtree.var_desc =
                              (Typedtree.TSimpleVar (12, "N")); var_type = int
                              });
                         exp_type = int }};
                     exp_type = int };
                   then_ =
                   { Typedtree.exp_desc =
                     Typedtree.TCallExp {func = (18, "printboard"); args = []};
                     exp_type = unit };
                   else_ =
                   (Some { Typedtree.exp_desc =
                           Typedtree.TForExp {var = (25, "r");
                             escape = ref (true);
                             lb =
                             { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                               exp_type = int };
                             hb =
                             { Typedtree.exp_desc =
                               Typedtree.TOpExp {
                                 left =
                                 { Typedtree.exp_desc =
                                   (Typedtree.TVarExp
                                      { Typedtree.var_desc =
                                        (Typedtree.TSimpleVar (12, "N"));
                                        var_type = int });
                                   exp_type = int };
                                 oper = `MinusOp;
                                 right =
                                 { Typedtree.exp_desc = (Typedtree.TIntExp 1);
                                   exp_type = int }};
                               exp_type = int };
                             body =
                             { Typedtree.exp_desc =
                               Typedtree.TIfExp {
                                 test =
                                 { Typedtree.exp_desc =
                                   Typedtree.TIfExp {
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
                                                    (Typedtree.TSubscriptVar (
                                                       { Typedtree.var_desc =
                                                         (Typedtree.TSimpleVar
                                                            (14, "row"));
                                                         var_type =
                                                         array of int },
                                                       { Typedtree.exp_desc =
                                                         (Typedtree.TVarExp
                                                            { Typedtree.var_desc =
                                                              (Typedtree.TSimpleVar
                                                                 (25, "r"));
                                                              var_type = int });
                                                         exp_type = int }
                                                       ));
                                                    var_type = int });
                                               exp_type = int };
                                             oper = `EqOp;
                                             right =
                                             { Typedtree.exp_desc =
                                               (Typedtree.TIntExp 0);
                                               exp_type = int }};
                                           exp_type = int };
                                         then_ =
                                         { Typedtree.exp_desc =
                                           Typedtree.TOpExp {
                                             left =
                                             { Typedtree.exp_desc =
                                               (Typedtree.TVarExp
                                                  { Typedtree.var_desc =
                                                    (Typedtree.TSubscriptVar (
                                                       { Typedtree.var_desc =
                                                         (Typedtree.TSimpleVar
                                                            (16, "diag1"));
                                                         var_type =
                                                         array of int },
                                                       { Typedtree.exp_desc =
                                                         Typedtree.TOpExp {
                                                           left =
                                                           { Typedtree.exp_desc =
                                                             (Typedtree.TVarExp
                                                                { Typedtree.var_desc =
                                                                  (Typedtree.TSimpleVar
                                                                     (25, "r"));
                                                                  var_type =
                                                                  int });
                                                             exp_type = int };
                                                           oper = `PlusOp;
                                                           right =
                                                           { Typedtree.exp_desc =
                                                             (Typedtree.TVarExp
                                                                { Typedtree.var_desc =
                                                                  (Typedtree.TSimpleVar
                                                                     (24, "c"));
                                                                  var_type =
                                                                  int });
                                                             exp_type = int }};
                                                         exp_type = int }
                                                       ));
                                                    var_type = int });
                                               exp_type = int };
                                             oper = `EqOp;
                                             right =
                                             { Typedtree.exp_desc =
                                               (Typedtree.TIntExp 0);
                                               exp_type = int }};
                                           exp_type = int };
                                         else_ =
                                         (Some { Typedtree.exp_desc =
                                                 (Typedtree.TIntExp 0);
                                                 exp_type = int })};
                                       exp_type = int };
                                     then_ =
                                     { Typedtree.exp_desc =
                                       Typedtree.TOpExp {
                                         left =
                                         { Typedtree.exp_desc =
                                           (Typedtree.TVarExp
                                              { Typedtree.var_desc =
                                                (Typedtree.TSubscriptVar (
                                                   { Typedtree.var_desc =
                                                     (Typedtree.TSimpleVar
                                                        (17, "diag2"));
                                                     var_type = array of int },
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
                                                                     (25, "r"));
                                                                  var_type =
                                                                  int });
                                                             exp_type = int };
                                                           oper = `PlusOp;
                                                           right =
                                                           { Typedtree.exp_desc =
                                                             (Typedtree.TIntExp
                                                                7);
                                                             exp_type = int }};
                                                         exp_type = int };
                                                       oper = `MinusOp;
                                                       right =
                                                       { Typedtree.exp_desc =
                                                         (Typedtree.TVarExp
                                                            { Typedtree.var_desc =
                                                              (Typedtree.TSimpleVar
                                                                 (24, "c"));
                                                              var_type = int });
                                                         exp_type = int }};
                                                     exp_type = int }
                                                   ));
                                                var_type = int });
                                           exp_type = int };
                                         oper = `EqOp;
                                         right =
                                         { Typedtree.exp_desc =
                                           (Typedtree.TIntExp 0);
                                           exp_type = int }};
                                       exp_type = int };
                                     else_ =
                                     (Some { Typedtree.exp_desc =
                                             (Typedtree.TIntExp 0);
                                             exp_type = int })};
                                   exp_type = int };
                                 then_ =
                                 { Typedtree.exp_desc =
                                   (Typedtree.TSeqExp
                                      [{ Typedtree.exp_desc =
                                         Typedtree.TAssignExp {
                                           var =
                                           { Typedtree.var_desc =
                                             (Typedtree.TSubscriptVar (
                                                { Typedtree.var_desc =
                                                  (Typedtree.TSimpleVar
                                                     (14, "row"));
                                                  var_type = array of int },
                                                { Typedtree.exp_desc =
                                                  (Typedtree.TVarExp
                                                     { Typedtree.var_desc =
                                                       (Typedtree.TSimpleVar
                                                          (25, "r"));
                                                       var_type = int });
                                                  exp_type = int }
                                                ));
                                             var_type = int };
                                           exp =
                                           { Typedtree.exp_desc =
                                             (Typedtree.TIntExp 1);
                                             exp_type = int }};
                                         exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TAssignExp {
                                            var =
                                            { Typedtree.var_desc =
                                              (Typedtree.TSubscriptVar (
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (16, "diag1"));
                                                   var_type = array of int },
                                                 { Typedtree.exp_desc =
                                                   Typedtree.TOpExp {
                                                     left =
                                                     { Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (25, "r"));
                                                            var_type = int });
                                                       exp_type = int };
                                                     oper = `PlusOp;
                                                     right =
                                                     { Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (24, "c"));
                                                            var_type = int });
                                                       exp_type = int }};
                                                   exp_type = int }
                                                 ));
                                              var_type = int };
                                            exp =
                                            { Typedtree.exp_desc =
                                              (Typedtree.TIntExp 1);
                                              exp_type = int }};
                                          exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TAssignExp {
                                            var =
                                            { Typedtree.var_desc =
                                              (Typedtree.TSubscriptVar (
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (17, "diag2"));
                                                   var_type = array of int },
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
                                                                   (25, "r"));
                                                                var_type = int
                                                                });
                                                           exp_type = int };
                                                         oper = `PlusOp;
                                                         right =
                                                         { Typedtree.exp_desc =
                                                           (Typedtree.TIntExp 7);
                                                           exp_type = int }};
                                                       exp_type = int };
                                                     oper = `MinusOp;
                                                     right =
                                                     { Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (24, "c"));
                                                            var_type = int });
                                                       exp_type = int }};
                                                   exp_type = int }
                                                 ));
                                              var_type = int };
                                            exp =
                                            { Typedtree.exp_desc =
                                              (Typedtree.TIntExp 1);
                                              exp_type = int }};
                                          exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TAssignExp {
                                            var =
                                            { Typedtree.var_desc =
                                              (Typedtree.TSubscriptVar (
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (15, "col"));
                                                   var_type = array of int },
                                                 { Typedtree.exp_desc =
                                                   (Typedtree.TVarExp
                                                      { Typedtree.var_desc =
                                                        (Typedtree.TSimpleVar
                                                           (24, "c"));
                                                        var_type = int });
                                                   exp_type = int }
                                                 ));
                                              var_type = int };
                                            exp =
                                            { Typedtree.exp_desc =
                                              (Typedtree.TVarExp
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (25, "r"));
                                                   var_type = int });
                                              exp_type = int }};
                                          exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TCallExp {
                                            func = (23, "try");
                                            args =
                                            [{ Typedtree.exp_desc =
                                               Typedtree.TOpExp {
                                                 left =
                                                 { Typedtree.exp_desc =
                                                   (Typedtree.TVarExp
                                                      { Typedtree.var_desc =
                                                        (Typedtree.TSimpleVar
                                                           (24, "c"));
                                                        var_type = int });
                                                   exp_type = int };
                                                 oper = `PlusOp;
                                                 right =
                                                 { Typedtree.exp_desc =
                                                   (Typedtree.TIntExp 1);
                                                   exp_type = int }};
                                               exp_type = int }
                                              ]};
                                          exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TAssignExp {
                                            var =
                                            { Typedtree.var_desc =
                                              (Typedtree.TSubscriptVar (
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (14, "row"));
                                                   var_type = array of int },
                                                 { Typedtree.exp_desc =
                                                   (Typedtree.TVarExp
                                                      { Typedtree.var_desc =
                                                        (Typedtree.TSimpleVar
                                                           (25, "r"));
                                                        var_type = int });
                                                   exp_type = int }
                                                 ));
                                              var_type = int };
                                            exp =
                                            { Typedtree.exp_desc =
                                              (Typedtree.TIntExp 0);
                                              exp_type = int }};
                                          exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TAssignExp {
                                            var =
                                            { Typedtree.var_desc =
                                              (Typedtree.TSubscriptVar (
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (16, "diag1"));
                                                   var_type = array of int },
                                                 { Typedtree.exp_desc =
                                                   Typedtree.TOpExp {
                                                     left =
                                                     { Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (25, "r"));
                                                            var_type = int });
                                                       exp_type = int };
                                                     oper = `PlusOp;
                                                     right =
                                                     { Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (24, "c"));
                                                            var_type = int });
                                                       exp_type = int }};
                                                   exp_type = int }
                                                 ));
                                              var_type = int };
                                            exp =
                                            { Typedtree.exp_desc =
                                              (Typedtree.TIntExp 0);
                                              exp_type = int }};
                                          exp_type = unit };
                                        { Typedtree.exp_desc =
                                          Typedtree.TAssignExp {
                                            var =
                                            { Typedtree.var_desc =
                                              (Typedtree.TSubscriptVar (
                                                 { Typedtree.var_desc =
                                                   (Typedtree.TSimpleVar
                                                      (17, "diag2"));
                                                   var_type = array of int },
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
                                                                   (25, "r"));
                                                                var_type = int
                                                                });
                                                           exp_type = int };
                                                         oper = `PlusOp;
                                                         right =
                                                         { Typedtree.exp_desc =
                                                           (Typedtree.TIntExp 7);
                                                           exp_type = int }};
                                                       exp_type = int };
                                                     oper = `MinusOp;
                                                     right =
                                                     { Typedtree.exp_desc =
                                                       (Typedtree.TVarExp
                                                          { Typedtree.var_desc =
                                                            (Typedtree.TSimpleVar
                                                               (24, "c"));
                                                            var_type = int });
                                                       exp_type = int }};
                                                   exp_type = int }
                                                 ));
                                              var_type = int };
                                            exp =
                                            { Typedtree.exp_desc =
                                              (Typedtree.TIntExp 0);
                                              exp_type = int }};
                                          exp_type = unit }
                                        ]);
                                   exp_type = unit };
                                 else_ = None};
                               exp_type = unit }};
                           exp_type = unit })};
                 exp_type = unit }
               }
             ])
        ];
      body =
      { Typedtree.exp_desc =
        Typedtree.TCallExp {func = (23, "try");
          args =
          [{ Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }]};
        exp_type = unit }};
    exp_type = unit }
