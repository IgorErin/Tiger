  $  cat ./code.tig
  /* error : compare rec with array */
  
  let
  
  	type arrtype = array of int
  	type rectype = {name:string, id: int}
  
  	var rec := rectype {name="aname", id=0}
  	var arr := arrtype [3] of 0
  
  in
  	if rec <> arr then 3 else 4
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "arrtype");
           ptd_type = (Parsetree.ArrayTy (10, "int")) };
          { Parsetree.ptd_name = (13, "rectype");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (14, "name"); pfd_escape = ref (true);
                  pfd_type = (11, "string") };
                 { Parsetree.pfd_name = (15, "id"); pfd_escape = ref (true);
                   pfd_type = (10, "int") }
                 ])
            }
          ]);
      Parsetree.PVarDec {name = (16, "rec"); escape = ref (true); type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (13, "rectype");
          fields =
          [((14, "name"), (Parsetree.PStringExp "aname"));
            ((15, "id"), (Parsetree.PIntExp 0))]}};
      Parsetree.PVarDec {name = (17, "arr"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (12, "arrtype");
          size = (Parsetree.PIntExp 3); init = (Parsetree.PIntExp 0)}}
      ];
    body =
    Parsetree.PIfExp {
      test =
      Parsetree.POpExp {
        left = (Parsetree.PVarExp (Parsetree.PSimpleVar (16, "rec")));
        oper = Parsetree.NeqOp;
        right = (Parsetree.PVarExp (Parsetree.PSimpleVar (17, "arr")))};
      then_ = (Parsetree.PIntExp 3); else_ = (Some (Parsetree.PIntExp 4))}}
