  $  cat ./code.tig
  /* error : variable not record */
  let 
  	var d:=0
  in
  	d.f 
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (12, "d"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 0)}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PFieldVar ((Parsetree.PSimpleVar (12, "d")), (13, "f"))))}
