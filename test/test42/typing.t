  $  cat ./code.tig
  /* correct declarations */
  let 
  
  type arrtype1 = array of int
  type rectype1 = {name:string, address:string, id: int , age: int}
  type arrtype2 = array of rectype1
  type rectype2 = {name : string, dates: arrtype1}
  
  type arrtype3 = array of string
  
  var arr1 := arrtype1 [10] of 0
  var arr2  := arrtype2 [5] of rectype1 {name="aname", address="somewhere", id=0, age=0}
  var arr3:arrtype3 := arrtype3 [100] of ""
  
  var rec1 := rectype1 {name="Kapoios", address="Kapou", id=02432, age=44}
  var rec2 := rectype2 {name="Allos", dates= arrtype1 [3] of 1900}
  
  in
  
  (arr1[0] := 1; 
  arr1[9] := 3;
  arr2[3].name := "kati";
  arr2[1].age := 23;
  arr3[34] := "sfd";
  
  rec1.name := "sdf";
  rec2.dates[0] := 2323;
  rec2.dates[2] := 2323)
  
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "arrtype1"); td_type = array of int };
            { Typedtree.td_name = (13, "rectype1");
              td_type =
              {(name : string)(address : string)(id : int)(age : int)} };
            { Typedtree.td_name = (18, "arrtype2");
              td_type = array of (Name  rectype1) };
            { Typedtree.td_name = (19, "rectype2");
              td_type = {(name : string)(dates : (Name  arrtype1))} };
            { Typedtree.td_name = (21, "arrtype3"); td_type = array of string }
            ]);
        Typedtree.TVarDec {name = (22, "arr1"); escape = ref (true);
          type_ = array of int;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of int;
              size =
              { Typedtree.exp_desc = (Typedtree.TIntExp 10); exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of int }};
        Typedtree.TVarDec {name = (23, "arr2"); escape = ref (true);
          type_ = array of (Name  rectype1);
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of (Name  rectype1);
              size =
              { Typedtree.exp_desc = (Typedtree.TIntExp 5); exp_type = int };
              init =
              { Typedtree.exp_desc =
                Typedtree.TRecordExp {
                  type_ =
                  {(name : string)(address : string)(id : int)(age : int)};
                  fields =
                  [((14, "name"), string,
                    { Typedtree.exp_desc = (Typedtree.TStringExp "aname");
                      exp_type = string });
                    ((15, "address"), string,
                     { Typedtree.exp_desc = (Typedtree.TStringExp "somewhere");
                       exp_type = string });
                    ((16, "id"), int,
                     { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                       exp_type = int });
                    ((17, "age"), int,
                     { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                       exp_type = int })
                    ]};
                exp_type =
                {(name : string)(address : string)(id : int)(age : int)} }};
            exp_type = array of (Name  rectype1) }};
        Typedtree.TVarDec {name = (24, "arr3"); escape = ref (true);
          type_ = array of string;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of string;
              size =
              { Typedtree.exp_desc = (Typedtree.TIntExp 100); exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TStringExp "");
                exp_type = string }};
            exp_type = array of string }};
        Typedtree.TVarDec {name = (25, "rec1"); escape = ref (true);
          type_ = {(name : string)(address : string)(id : int)(age : int)};
          init =
          { Typedtree.exp_desc =
            Typedtree.TRecordExp {
              type_ = {(name : string)(address : string)(id : int)(age : int)};
              fields =
              [((14, "name"), string,
                { Typedtree.exp_desc = (Typedtree.TStringExp "Kapoios");
                  exp_type = string });
                ((15, "address"), string,
                 { Typedtree.exp_desc = (Typedtree.TStringExp "Kapou");
                   exp_type = string });
                ((16, "id"), int,
                 { Typedtree.exp_desc = (Typedtree.TIntExp 2432);
                   exp_type = int });
                ((17, "age"), int,
                 { Typedtree.exp_desc = (Typedtree.TIntExp 44); exp_type = int
                   })
                ]};
            exp_type = {(name : string)(address : string)(id : int)(age : int)}
            }};
        Typedtree.TVarDec {name = (26, "rec2"); escape = ref (true);
          type_ = {(name : string)(dates : (Name  arrtype1))};
          init =
          { Typedtree.exp_desc =
            Typedtree.TRecordExp {
              type_ = {(name : string)(dates : (Name  arrtype1))};
              fields =
              [((14, "name"), string,
                { Typedtree.exp_desc = (Typedtree.TStringExp "Allos");
                  exp_type = string });
                ((20, "dates"), (Name  arrtype1),
                 { Typedtree.exp_desc =
                   Typedtree.TArrayExp {type_ = array of int;
                     size =
                     { Typedtree.exp_desc = (Typedtree.TIntExp 3);
                       exp_type = int };
                     init =
                     { Typedtree.exp_desc = (Typedtree.TIntExp 1900);
                       exp_type = int }};
                   exp_type = array of int })
                ]};
            exp_type = {(name : string)(dates : (Name  arrtype1))} }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TSeqExp
           [{ Typedtree.exp_desc =
              Typedtree.TAssignExp {
                var =
                { Typedtree.var_desc =
                  (Typedtree.TSubscriptVar (
                     { Typedtree.var_desc =
                       (Typedtree.TFieldVar (
                          { Typedtree.var_desc =
                            (Typedtree.TSimpleVar (26, "rec2"));
                            var_type =
                            {(name : string)(dates : (Name  arrtype1))} },
                          (20, "dates")));
                       var_type = array of int },
                     { Typedtree.exp_desc = (Typedtree.TIntExp 2);
                       exp_type = int }
                     ));
                  var_type = int };
                exp =
                { Typedtree.exp_desc = (Typedtree.TIntExp 2323); exp_type = int
                  }};
              exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TSubscriptVar (
                      { Typedtree.var_desc =
                        (Typedtree.TFieldVar (
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (26, "rec2"));
                             var_type =
                             {(name : string)(dates : (Name  arrtype1))} },
                           (20, "dates")));
                        var_type = array of int },
                      { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                        exp_type = int }
                      ));
                   var_type = int };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TIntExp 2323);
                   exp_type = int }};
               exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TFieldVar (
                      { Typedtree.var_desc =
                        (Typedtree.TSimpleVar (25, "rec1"));
                        var_type =
                        {(name : string)(address : string)(id : int)(age : int)}
                        },
                      (14, "name")));
                   var_type = string };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TStringExp "sdf");
                   exp_type = string }};
               exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TSubscriptVar (
                      { Typedtree.var_desc =
                        (Typedtree.TSimpleVar (24, "arr3"));
                        var_type = array of string },
                      { Typedtree.exp_desc = (Typedtree.TIntExp 34);
                        exp_type = int }
                      ));
                   var_type = string };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TStringExp "sfd");
                   exp_type = string }};
               exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TFieldVar (
                      { Typedtree.var_desc =
                        (Typedtree.TSubscriptVar (
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (23, "arr2"));
                             var_type = array of (Name  rectype1) },
                           { Typedtree.exp_desc = (Typedtree.TIntExp 1);
                             exp_type = int }
                           ));
                        var_type = (Name  rectype1) },
                      (17, "age")));
                   var_type = int };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TIntExp 23); exp_type = int
                   }};
               exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TFieldVar (
                      { Typedtree.var_desc =
                        (Typedtree.TSubscriptVar (
                           { Typedtree.var_desc =
                             (Typedtree.TSimpleVar (23, "arr2"));
                             var_type = array of (Name  rectype1) },
                           { Typedtree.exp_desc = (Typedtree.TIntExp 3);
                             exp_type = int }
                           ));
                        var_type = (Name  rectype1) },
                      (14, "name")));
                   var_type = string };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TStringExp "kati");
                   exp_type = string }};
               exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TSubscriptVar (
                      { Typedtree.var_desc =
                        (Typedtree.TSimpleVar (22, "arr1"));
                        var_type = array of int },
                      { Typedtree.exp_desc = (Typedtree.TIntExp 9);
                        exp_type = int }
                      ));
                   var_type = int };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TIntExp 3); exp_type = int }};
               exp_type = unit };
             { Typedtree.exp_desc =
               Typedtree.TAssignExp {
                 var =
                 { Typedtree.var_desc =
                   (Typedtree.TSubscriptVar (
                      { Typedtree.var_desc =
                        (Typedtree.TSimpleVar (22, "arr1"));
                        var_type = array of int },
                      { Typedtree.exp_desc = (Typedtree.TIntExp 0);
                        exp_type = int }
                      ));
                   var_type = int };
                 exp =
                 { Typedtree.exp_desc = (Typedtree.TIntExp 1); exp_type = int }};
               exp_type = unit }
             ]);
        exp_type = unit }};
    exp_type = unit }
