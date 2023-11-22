  $  cat ./code.tig
  /* valid for and let */
  
  let
  	var a:= 0
  in 
  	for i:=0 to 100 do (a:=a+1;())
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [Parsetree.PVarDec {name = (12, "a"); escape = ref (true); type_ = None;
       init = (Parsetree.PIntExp 0)}
      ];
    body =
    Parsetree.PForExp {var = (14, "i"); escape = ref (true);
      lb = (Parsetree.PIntExp 0); hb = (Parsetree.PIntExp 100);
      body =
      (Parsetree.PSeqExp
         [Parsetree.PAssignExp {var = (Parsetree.PSimpleVar (12, "a"));
            exp =
            Parsetree.POpExp {
              left = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "a")));
              oper = `PlusOp; right = (Parsetree.PIntExp 1)}};
           (Parsetree.PSeqExp [])])}}
