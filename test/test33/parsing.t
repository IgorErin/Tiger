  $  cat ./code.tig
  /* error : unknown type */
  let
  	var a:= rectype {}
  in
  	0
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (0, "a"); escape = ref (true); type_ = None;
       init = Parsetree.PRecordExp {type_ = (1, "rectype"); fields = []}}
      ];
    body = (Parsetree.PIntExp 0)}
