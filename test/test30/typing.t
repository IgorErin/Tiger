  $  cat ./code.tig
  /* synonyms are fine */
  
  let 
  		type a = array of int
  		type b = a
  
  		var arr1:a := b [10] of 0
  in
  		arr1[2]
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "a"); td_type = array of int };
            { Typedtree.td_name = (13, "b"); td_type = (Name  a) }]);
        Typedtree.TVarDec {name = (14, "arr1"); escape = ref (true);
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
           { Typedtree.var_desc =
             (Typedtree.TSubscriptVar (
                { Typedtree.var_desc = (Typedtree.TSimpleVar (14, "arr1"));
                  var_type = array of int },
                { Typedtree.exp_desc = (Typedtree.TIntExp 2); exp_type = int }
                ));
             var_type = int });
        exp_type = int }};
    exp_type = int }
