TODO()
  $  cat ./code.tig
  /* error: mutually recursive types thet do not pass through record or array */
  let 
  
  type a=c
  type b=a
  type c=d
  type d=a
  
  in
   ""
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "a"); td_type = (Name  c) };
            { Typedtree.td_name = (14, "b"); td_type = (Name  a) };
            { Typedtree.td_name = (13, "c"); td_type = (Name  d) };
            { Typedtree.td_name = (15, "d"); td_type = (Name  a) }])
        ];
      body =
      { Typedtree.exp_desc = (Typedtree.TStringExp ""); exp_type = string }};
    exp_type = string }
