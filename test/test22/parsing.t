  $  cat ./code.tig
  /* error : field not in record type */
  
  let 
  	type rectype = {name:string , id:int}
  	var rec1 := rectype {name="Name", id=0}
  in
  	rec1.nam := "asd"
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
      Parsetree.PVarDec {name = (5, "rec1"); escape = ref (true); type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (0, "rectype");
          fields =
          [((1, "name"), (Parsetree.PStringExp "Name"));
            ((3, "id"), (Parsetree.PIntExp 0))]}}
      ];
    body =
    Parsetree.PAssignExp {
      var =
      (Parsetree.PFieldVar ((Parsetree.PSimpleVar (5, "rec1")), (6, "nam")));
      exp = (Parsetree.PStringExp "asd")}}
