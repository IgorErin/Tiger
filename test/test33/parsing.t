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
    [Parsetree.PVarDec {name = (12, "a"); escape = ref (true); type_ = None;
       init = Parsetree.PRecordExp {type_ = (13, "rectype"); fields = []}}
      ];
    body = (Parsetree.PIntExp 0)}
  message: Record expr type unbound.
  error: unbound type: rectype
