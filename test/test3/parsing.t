  $  cat ./code.tig
  /* a record type and a record variable */
  let
  	type  rectype = {name:string, age:int}
  	var rec1:rectype := rectype {name="Nobody", age=1000}
  in
  	(rec1.name := "Somebody";
  	rec1)
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
                { Parsetree.pfd_name = (14, "age"); pfd_escape = ref (true);
                  pfd_type = (10, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (15, "rec1"); escape = ref (true);
        type_ = (Some (12, "rectype"));
        init =
        Parsetree.PRecordExp {type_ = (12, "rectype");
          fields =
          [((13, "name"), (Parsetree.PStringExp "Nobody"));
            ((14, "age"), (Parsetree.PIntExp 1000))]}}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.PAssignExp {
          var =
          (Parsetree.PFieldVar ((Parsetree.PSimpleVar (15, "rec1")),
             (13, "name")));
          exp = (Parsetree.PStringExp "Somebody")};
         (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "rec1")))])}
