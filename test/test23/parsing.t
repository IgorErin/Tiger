  $  cat ./code.tig
  /* error : type mismatch */
  
  let 
  	type rectype = {name:string , id:int}
  	var rec1 := rectype {name="aname", id=0}
  in
  	(rec1.name := 3;
  	rec1.id := "") 
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
          [((1, "name"), (Parsetree.PStringExp "aname"));
            ((3, "id"), (Parsetree.PIntExp 0))]}}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.PAssignExp {
          var =
          (Parsetree.PFieldVar ((Parsetree.PSimpleVar (5, "rec1")), (1, "name")
             ));
          exp = (Parsetree.PIntExp 3)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar ((Parsetree.PSimpleVar (5, "rec1")), (3, "id")
              ));
           exp = (Parsetree.PStringExp "")}
         ])}
