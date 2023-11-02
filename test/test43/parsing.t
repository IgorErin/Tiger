  $  cat ./code.tig
  /* initialize with unit and causing type mismatch in addition */
  
  let 
  	var a := ()
  in
  	a + 3
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (0, "a"); escape = ref (true); type_ = None;
       init = (Parsetree.PSeqExp [])}
      ];
    body =
    Parsetree.POpExp {
      left = (Parsetree.PVarExp (Parsetree.PSimpleVar (0, "a")));
      oper = Parsetree.PlusOp; right = (Parsetree.PIntExp 3)}}
