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
        [{ Parsetree.ptd_name = (12, "rectype1");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (13, "name"); pfd_escape = ref (true);
                 pfd_type = (11, "string") };
                { Parsetree.pfd_name = (14, "id"); pfd_escape = ref (true);
                  pfd_type = (10, "int") }
                ])
           };
          { Parsetree.ptd_name = (15, "rectype2");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (13, "name"); pfd_escape = ref (true);
                  pfd_type = (11, "string") };
                 { Parsetree.pfd_name = (14, "id"); pfd_escape = ref (true);
                   pfd_type = (10, "int") }
                 ])
            }
          ]);
      Parsetree.PVarDec {name = (16, "rec1"); escape = ref (true);
        type_ = (Some (12, "rectype1"));
        init =
        Parsetree.PRecordExp {type_ = (15, "rectype2");
          fields =
          [((13, "name"), (Parsetree.PStringExp "Name"));
            ((14, "id"), (Parsetree.PIntExp 0))]}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (16, "rec1")))}
  message: Types must be equal {(name : String); (id : int);} =/= (Name  rectype1)
  error: Type mismatch
