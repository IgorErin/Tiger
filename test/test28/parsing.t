  $  cat ./code.tig
  /* error : different record types */
  
  let
  	type rectype1 = {name:string , id:int}
  	type rectype2 = {name:string , id:int}
  
  	var rec1: rectype1 := rectype2 {name="Name", id=0}
  in
  	rec1
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "rectype1");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (1, "name"); pfd_escape = ref (true);
                 pfd_type = (2, "string") };
                { Parsetree.pfd_name = (3, "id"); pfd_escape = ref (true);
                  pfd_type = (4, "int") }
                ])
           };
          { Parsetree.ptd_name = (5, "rectype2");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (1, "name"); pfd_escape = ref (true);
                  pfd_type = (2, "string") };
                 { Parsetree.pfd_name = (3, "id"); pfd_escape = ref (true);
                   pfd_type = (4, "int") }
                 ])
            }
          ]);
      Parsetree.PVarDec {name = (6, "rec1"); escape = ref (true);
        type_ = (Some (0, "rectype1"));
        init =
        Parsetree.PRecordExp {type_ = (5, "rectype2");
          fields =
          [((1, "name"), (Parsetree.PStringExp "Name"));
            ((3, "id"), (Parsetree.PIntExp 0))]}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (6, "rec1")))}
