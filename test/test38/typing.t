  $  cat ./code.tig
  /* This is illegal, since there are two types with the same name
      in the same (consecutive) batch of mutually recursive types. 
      See also test47  */
  let
  	type a = int
  	type a = string
  
  	var a: a := "" 
  in
  	a
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "a"); td_type = int };
            { Typedtree.td_name = (12, "a"); td_type = string }]);
        Typedtree.TVarDec {name = (12, "a"); escape = ref (true);
          type_ = string;
          init =
          { Typedtree.exp_desc = (Typedtree.TStringExp ""); exp_type = string }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TVarExp
           { Typedtree.var_desc = (Typedtree.TSimpleVar (12, "a"));
             var_type = string });
        exp_type = string }};
    exp_type = string }
