  $  cat ./code.tig
  /* valid nil initialization and assignment */
  let 
  
  	type rectype = {name:string, id:int}
  	var b:rectype := nil
  
  in
  
  	b := nil
  
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
      Parsetree.PVarDec {name = (5, "b"); escape = ref (true);
        type_ = (Some (0, "rectype")); init = Parsetree.PNilExp}
      ];
    body =
    Parsetree.PAssignExp {var = (Parsetree.PSimpleVar (5, "b"));
      exp = Parsetree.PNilExp}}
