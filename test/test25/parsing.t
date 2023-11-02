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
    [Parsetree.PVarDec {name = (0, "d"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 0)}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PFieldVar ((Parsetree.PSimpleVar (0, "d")), (1, "f"))))}
