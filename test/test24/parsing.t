  $  cat ./code.tig
  /* error : variable not array */
  let 
  	var d:=0
  in
  	d[3]
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (12, "d"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 0)}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (12, "d")),
          (Parsetree.PIntExp 3))))}
  message: Array type expected
  error: not a record: int
