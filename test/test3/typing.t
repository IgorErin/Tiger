  $  cat ./code.tig
  /* a record type and a record variable */
  let
  	type  rectype = {name:string, age:int}
  	var rec1:rectype := rectype {name="Nobody", age=1000}
  in
  	(rec1.name := "Somebody";
  	rec1)
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "rectype");
             td_type = {(name : string)(age : int)} }
            ]);
        Typedtree.TVarDec {name = (15, "rec1"); escape = ref (true);
          type_ = {(name : string)(age : int)};
          init =
          { Typedtree.exp_desc =
            Typedtree.TRecordExp {type_ = {(name : string)(age : int)};
              fields =
              [((13, "name"), string,
                { Typedtree.exp_desc = (Typedtree.TStringExp "Nobody");
                  exp_type = string });
                ((14, "age"), int,
                 { Typedtree.exp_desc = (Typedtree.TIntExp 1000);
                   exp_type = int })
                ]};
            exp_type = {(name : string)(age : int)} }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TSeqExp
           [{ Typedtree.exp_desc =
              Typedtree.TAssignExp {
                var =
                { Typedtree.var_desc =
                  (Typedtree.TFieldVar (
                     { Typedtree.var_desc = (Typedtree.TSimpleVar (15, "rec1"));
                       var_type = {(name : string)(age : int)} },
                     0));
                  var_type = string };
                exp =
                { Typedtree.exp_desc = (Typedtree.TStringExp "Somebody");
                  exp_type = string }};
              exp_type = unit };
             { Typedtree.exp_desc =
               (Typedtree.TVarExp
                  { Typedtree.var_desc = (Typedtree.TSimpleVar (15, "rec1"));
                    var_type = {(name : string)(age : int)} });
               exp_type = {(name : string)(age : int)} }
             ]);
        exp_type = {(name : string)(age : int)} }};
    exp_type = {(name : string)(age : int)} }
