  $  cat ./code.tig
  /* local types hide global */
  let
  	type a = int
  in
  	let
  		type a = string
  	in
  		0
  	end
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "a");
           ptd_type = (Parsetree.NameTy (1, "int")) }
          ])
      ];
    body =
    Parsetree.PLetExp {
      decs =
      [(Parsetree.PTypeDec
          [{ Parsetree.ptd_name = (0, "a");
             ptd_type = (Parsetree.NameTy (2, "string")) }
            ])
        ];
      body = (Parsetree.PIntExp 0)}}
