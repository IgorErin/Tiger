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
          [((13, "name"), (Parsetree.PStringExp "aname"));
            ((14, "id"), (Parsetree.PIntExp 0))]}}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.PAssignExp {
          var =
          (Parsetree.PFieldVar ((Parsetree.PSimpleVar (15, "rec1")),
             (13, "name")));
          exp = (Parsetree.PIntExp 3)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar ((Parsetree.PSimpleVar (15, "rec1")),
              (14, "id")));
           exp = (Parsetree.PStringExp "")}
         ])}
  message: Types must be equal String =/= int
  error: Type mismatch
