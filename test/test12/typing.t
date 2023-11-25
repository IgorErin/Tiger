  $  cat ./code.tig
  /* valid for and let */
  
  let
  	var a:= 0
  in 
  	for i:=0 to 100 do (a:=a+1;())
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [Typedtree.TVarDec {name = (12, "a"); escape = ref (true); type_ = int;
         init = { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }}
        ];
      body =
      { Typedtree.exp_desc =
        Typedtree.TForExp {var = (14, "i"); escape = ref (true);
          lb = { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int };
          hb = { Typedtree.exp_desc = (Typedtree.TIntExp 100); exp_type = int };
          body =
          { Typedtree.exp_desc =
            (Typedtree.TSeqExp
               [{ Typedtree.exp_desc =
                  Typedtree.TAssignExp {
                    var =
                    { Typedtree.var_desc = (Typedtree.TSimpleVar (12, "a"));
                      var_type = int };
                    exp =
                    { Typedtree.exp_desc =
                      Typedtree.TOpExp {
                        left =
                        { Typedtree.exp_desc =
                          (Typedtree.TVarExp
                             { Typedtree.var_desc =
                               (Typedtree.TSimpleVar (12, "a")); var_type = int
                               });
                          exp_type = int };
                        oper = `PlusOp;
                        right =
                        { Typedtree.exp_desc = (Typedtree.TIntExp 1);
                          exp_type = int }};
                      exp_type = int }};
                  exp_type = unit };
                 { Typedtree.exp_desc = (Typedtree.TSeqExp []); exp_type = unit
                   }
                 ]);
            exp_type = unit }};
        exp_type = unit }};
    exp_type = unit }
