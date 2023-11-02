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
        [{ Parsetree.ptd_name = (0, "arrtype");
           ptd_type = (Parsetree.ArrayTy (1, "int")) };
          { Parsetree.ptd_name = (2, "rectype");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (3, "name"); pfd_escape = ref (true);
                  pfd_type = (4, "string") };
                 { Parsetree.pfd_name = (5, "id"); pfd_escape = ref (true);
                   pfd_type = (1, "int") }
                 ])
            }
          ]);
      Parsetree.PVarDec {name = (6, "rec"); escape = ref (true); type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (2, "rectype");
          fields =
          [((3, "name"), (Parsetree.PStringExp "aname"));
            ((5, "id"), (Parsetree.PIntExp 0))]}};
      Parsetree.PVarDec {name = (7, "arr"); escape = ref (true); type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (0, "arrtype");
          size = (Parsetree.PIntExp 3); init = (Parsetree.PIntExp 0)}}
      ];
    body =
    Parsetree.PIfExp {
      test =
      Parsetree.POpExp {
        left = (Parsetree.PVarExp (Parsetree.PSimpleVar (6, "rec")));
        oper = Parsetree.NeqOp;
        right = (Parsetree.PVarExp (Parsetree.PSimpleVar (7, "arr")))};
      then_ = (Parsetree.PIntExp 3); else_ = (Some (Parsetree.PIntExp 4))}}
