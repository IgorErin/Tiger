  $  cat ./code.tig
  let
  	type  arrtype = array of int
  	var arr1:arrtype := arrtype [10] of 0
  in
  	arr1
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "arrtype"); td_type = array of int }]);
        Typedtree.TVarDec {name = (13, "arr1"); escape = ref (true);
          type_ = array of int;
          init =
          { Typedtree.exp_desc =
            Typedtree.TArrayExp {type_ = array of int;
              size =
              { Typedtree.exp_desc = (Typedtree.TIntExp 10); exp_type = int };
              init =
              { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
            exp_type = array of int }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TVarExp
           { Typedtree.var_desc = (Typedtree.TSimpleVar (13, "arr1"));
             var_type = array of int });
        exp_type = array of int }};
    exp_type = array of int }
