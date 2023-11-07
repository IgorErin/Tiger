  $  cat ./code.tig
  /* valid nil initialization and assignment */
  let 
  
  	type rectype = {name:string, id:int}
  	var b:rectype := nil
  
  in
  
  	b := nil
  
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
        Typedtree.TAssignExp {
          var =
          { Typedtree.var_desc = (Typedtree.TSimpleVar (15, "b"));
            var_type = {(name : string)(id : int)} };
          exp = { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil }};
        exp_type = unit }};
    exp_type = unit }
