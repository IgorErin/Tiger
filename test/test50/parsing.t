  $  cat ./code.tig
  let 
  	type rectype = {name:string, id:int}
  
  	var a:rectype :=  nil
  in
  	a.name
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
      Parsetree.PVarDec {name = (15, "a"); escape = ref (true);
        type_ = (Some (12, "rectype")); init = Parsetree.PNilExp}
      ];
    body =
    (Parsetree.PVarExp
       (Parsetree.PFieldVar ((Parsetree.PSimpleVar (15, "a")), (13, "name"))))}
