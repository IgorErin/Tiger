  $  cat ./code.tig
  /* redeclaration of variable; this is legal, there are two different
     variables with the same name.  The second one hides the first.  */
  let
  	var a := 0
  	var a := " "
  in
  	a
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [Typedtree.TVarDec {name = (12, "a"); escape = ref (true); type_ = int;
         init = { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
        Typedtree.TVarDec {name = (12, "a"); escape = ref (true);
          type_ = string;
          init =
          { Typedtree.exp_desc = (Typedtree.TStringExp " "); exp_type = string
            }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TVarExp
           { Typedtree.var_desc = (Typedtree.TSimpleVar (12, "a"));
             var_type = string });
        exp_type = string }};
    exp_type = string }
