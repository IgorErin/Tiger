  $  cat ./code.tig
  /* error : initializing exp and array type differ */
  
  let
  	type arrayty = array of int
  
  	var a := arrayty [10] of " "
  in
  	0
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "arrayty");
           ptd_type = (Parsetree.ArrayTy (10, "int")) }
          ]);
      Parsetree.PVarDec {name = (13, "a"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (12, "arrayty");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PStringExp " ")}}
      ];
    body = (Parsetree.PIntExp 0)}
