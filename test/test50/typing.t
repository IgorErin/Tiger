  $  cat ./code.tig
  let 
  	type rectype = {name:string, id:int}
  
  	var a:rectype :=  nil
  in
  	a.name
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "rectype");
             td_type = {(name : string)(id : int)} }
            ]);
        Typedtree.TVarDec {name = (15, "a"); escape = ref (true);
          type_ = {(name : string)(id : int)};
          init = { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil }}
        ];
      body =
      { Typedtree.exp_desc =
        (Typedtree.TVarExp
           { Typedtree.var_desc =
             (Typedtree.TFieldVar (
                { Typedtree.var_desc = (Typedtree.TSimpleVar (15, "a"));
                  var_type = {(name : string)(id : int)} },
                0));
             var_type = string });
        exp_type = string }};
    exp_type = string }
