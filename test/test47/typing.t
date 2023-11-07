  $  cat ./code.tig
  /* This is legal.  The second type "a" simply hides the first one.
     Because of the intervening variable declaration, the two "a" types
     are not in the same  batch of mutually recursive types.
     See also test38 */
  let
  	type a = int
  	var b := 4
  	type a = string
  in
  	0
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec [{ Typedtree.td_name = (12, "a"); td_type = int }]);
        Typedtree.TVarDec {name = (13, "b"); escape = ref (true); type_ = int;
          init = { Typedtree.exp_desc = (Typedtree.TIntExp 4); exp_type = int }};
        (Typedtree.TTypeDec
           [{ Typedtree.td_name = (12, "a"); td_type = string }])
        ];
      body = { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
    exp_type = int }
