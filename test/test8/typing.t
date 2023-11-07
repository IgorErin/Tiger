  $  cat ./code.tig
  /* correct if */
  if (10 > 20) then 30 else 40	
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TIfExp {
      test =
      { Typedtree.exp_desc =
        Typedtree.TOpExp {
          left =
          { Typedtree.exp_desc = (Typedtree.TIntExp 10); exp_type = int };
          oper = Parsetree.GtOp;
          right =
          { Typedtree.exp_desc = (Typedtree.TIntExp 20); exp_type = int }};
        exp_type = int };
      then_ = { Typedtree.exp_desc = (Typedtree.TIntExp 30); exp_type = int };
      else_ =
      (Some { Typedtree.exp_desc = (Typedtree.TIntExp 40); exp_type = int })};
    exp_type = int }
