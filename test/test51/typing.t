  $  cat ./code.tig
  let
  	type arrtype1 = array of int
  
  	var arr1: arrtype1 := nil
  in
  	arr1[0]
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "arrtype1"); td_type = array of int }]);
        Typedtree.TVarDec {name = (13, "arr1"); escape = ref (true);
          type_ = array of int;
          init = { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TVarExp
           { Typedtree.var_desc =
             (Typedtree.TSubscriptVar (
                { Typedtree.var_desc = (Typedtree.TSimpleVar (13, "arr1"));
                  var_type = array of int },
                { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }
                ));
             var_type = int });
        exp_type = int }};
    exp_type = int }
