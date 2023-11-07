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
        [{ Parsetree.ptd_name = (12, "rectype");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (13, "name"); pfd_escape = ref (true);
                 pfd_type = (11, "string") };
                { Parsetree.pfd_name = (14, "id"); pfd_escape = ref (true);
                  pfd_type = (10, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (15, "a"); escape = ref (true); type_ = None;
        init = Parsetree.PNilExp}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "a")))}
