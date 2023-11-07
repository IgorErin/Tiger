  $  cat ./code.tig
  /* local types hide global */
  let
  	type a = int
  in
  	let
  		type a = string
  	in
  		let
  			var a:a := "" 
  		in
  			a
  		end 
  	end
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec [{ Typedtree.td_name = (12, "a"); td_type = int }])];
      body =
      { Typedtree.exp_desc =
        Typedtree.TLetExp {
          decs =
          [(Typedtree.TTypeDec
              [{ Typedtree.td_name = (12, "a"); td_type = string }])
            ];
          body =
          { Typedtree.exp_desc =
            Typedtree.TLetExp {
              decs =
              [Typedtree.TVarDec {name = (12, "a"); escape = ref (true);
                 type_ = string;
                 init =
                 { Typedtree.exp_desc = (Typedtree.TStringExp "");
                   exp_type = string }}
                ];
              body =
              { Typedtree.exp_desc =
                (Typedtree.TVarExp
                   { Typedtree.var_desc = (Typedtree.TSimpleVar (12, "a"));
                     var_type = string });
                exp_type = string }};
            exp_type = string }};
        exp_type = string }};
    exp_type = string }
