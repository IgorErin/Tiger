  $  cat ./code.tig
  /* valid rec comparisons */
  let 
  	type rectype = {name:string, id:int}
  	var b:rectype := nil
  in
  	(b = nil;
  	b <> nil)
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "rectype");
             td_type = {(name : string)(id : int)} }
            ]);
        Typedtree.TVarDec {name = (15, "b"); escape = ref (true);
          type_ = {(name : string)(id : int)};
          init = { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TSeqExp
           [{ Typedtree.exp_desc =
              Typedtree.TOpExp {
                left =
                { Typedtree.exp_desc =
                  (Typedtree.TVarExp
                     { Typedtree.var_desc = (Typedtree.TSimpleVar (15, "b"));
                       var_type = {(name : string)(id : int)} });
                  exp_type = {(name : string)(id : int)} };
                oper = Parsetree.NeqOp;
                right =
                { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil }};
              exp_type = int };
             { Typedtree.exp_desc =
               Typedtree.TOpExp {
                 left =
                 { Typedtree.exp_desc =
                   (Typedtree.TVarExp
                      { Typedtree.var_desc = (Typedtree.TSimpleVar (15, "b"));
                        var_type = {(name : string)(id : int)} });
                   exp_type = {(name : string)(id : int)} };
                 oper = Parsetree.EqOp;
                 right =
                 { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil }};
               exp_type = int }
             ]);
        exp_type = int }};
    exp_type = int }
