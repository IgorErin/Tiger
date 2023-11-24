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
      Parsetree.PVarDec {name = (15, "rec1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (12, "rectype");
          fields =
          [((13, "name"), (Parsetree.PStringExp "Name"));
            ((14, "id"), (Parsetree.PIntExp 0))]}}
      ];
    body =
    Parsetree.PAssignExp {
      var =
      (Parsetree.PFieldVar ((Parsetree.PSimpleVar (15, "rec1")), (16, "nam")));
      exp = (Parsetree.PStringExp "asd")}}
  message: No such fiedl in {(name : String); (id : int);}
  error: unbound name: nam
