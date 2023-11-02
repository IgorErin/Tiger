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
    [Parsetree.PVarDec {name = (0, "d"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 0)}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (0, "d")),
          (Parsetree.PIntExp 3))))}
