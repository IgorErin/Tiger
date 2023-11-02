  $  cat ./code.tig
  /* error: initializing nil expressions not constrained by record type */
  let 
  	type rectype = {name:string, id:int}
  
  	var a:= nil
  in
  	a
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "rectype");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (1, "name"); pfd_escape = ref (true);
                 pfd_type = (2, "string") };
                { Parsetree.pfd_name = (3, "id"); pfd_escape = ref (true);
                  pfd_type = (4, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (5, "a"); escape = ref (true); type_ = None;
        init = Parsetree.PNilExp}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "a")))}
