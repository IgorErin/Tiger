  $  cat ./code.tig
  /* arr1 is valid since expression 0 is int = myint */
  let
  	type myint = int
  	type  arrtype = array of myint
  
  	var arr1:arrtype := arrtype [10] of 0
  in
  	arr1
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "myint"); td_type = int };
            { Typedtree.td_name = (13, "arrtype");
              td_type = array of (Name  myint) }
            ]);
        Typedtree.TVarDec {name = (14, "arr1"); escape = ref (true);
          type_ = array of (Name  myint);
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of (Name  myint);
              size =
              { Typedtree.exp_desc = (Typedtree.TIntExp 10); exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of (Name  myint) }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TVarExp
           { Typedtree.var_desc = (Typedtree.TSimpleVar (14, "arr1"));
             var_type = array of (Name  myint) });
        exp_type = array of (Name  myint) }};
    exp_type = array of (Name  myint) }
