  $  cat ./code.tig
  /* local types hide global */
  let
  	type a = int
  in
  	let
  		type a = string
  	in
  		let
  			var a:a := "" 
  		in
  			a
  		end 
  	end
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "a");
           ptd_type = (Parsetree.NameTy (10, "int")) }
          ])
      ];
    body =
    Parsetree.PLetExp {
      decs =
      [(Parsetree.PTypeDec
          [{ Parsetree.ptd_name = (12, "a");
             ptd_type = (Parsetree.NameTy (11, "string")) }
            ])
        ];
      body =
      Parsetree.PLetExp {
        decs =
        [Parsetree.PVarDec {name = (12, "a"); escape = ref (true);
           type_ = (Some (12, "a")); init = (Parsetree.PStringExp "")}
          ];
        body = (Parsetree.PVarExp (Parsetree.PSimpleVar (12, "a")))}}}
