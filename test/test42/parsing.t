  $  cat ./code.tig
  /* correct declarations */
  let 
  
  type arrtype1 = array of int
  type rectype1 = {name:string, address:string, id: int , age: int}
  type arrtype2 = array of rectype1
  type rectype2 = {name : string, dates: arrtype1}
  
  type arrtype3 = array of string
  
  var arr1 := arrtype1 [10] of 0
  var arr2  := arrtype2 [5] of rectype1 {name="aname", address="somewhere", id=0, age=0}
  var arr3:arrtype3 := arrtype3 [100] of ""
  
  var rec1 := rectype1 {name="Kapoios", address="Kapou", id=02432, age=44}
  var rec2 := rectype2 {name="Allos", dates= arrtype1 [3] of 1900}
  
  in
  
  (arr1[0] := 1; 
  arr1[9] := 3;
  arr2[3].name := "kati";
  arr2[1].age := 23;
  arr3[34] := "sfd";
  
  rec1.name := "sdf";
  rec2.dates[0] := 2323;
  rec2.dates[2] := 2323)
  
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "arrtype1");
           ptd_type = (Parsetree.ArrayTy (10, "int")) };
          { Parsetree.ptd_name = (13, "rectype1");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (14, "name"); pfd_escape = ref (true);
                  pfd_type = (11, "string") };
                 { Parsetree.pfd_name = (15, "address");
                   pfd_escape = ref (true); pfd_type = (11, "string") };
                 { Parsetree.pfd_name = (16, "id"); pfd_escape = ref (true);
                   pfd_type = (10, "int") };
                 { Parsetree.pfd_name = (17, "age"); pfd_escape = ref (true);
                   pfd_type = (10, "int") }
                 ])
            };
          { Parsetree.ptd_name = (18, "arrtype2");
            ptd_type = (Parsetree.ArrayTy (13, "rectype1")) };
          { Parsetree.ptd_name = (19, "rectype2");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (14, "name"); pfd_escape = ref (true);
                  pfd_type = (11, "string") };
                 { Parsetree.pfd_name = (20, "dates"); pfd_escape = ref (true);
                   pfd_type = (12, "arrtype1") }
                 ])
            };
          { Parsetree.ptd_name = (21, "arrtype3");
            ptd_type = (Parsetree.ArrayTy (11, "string")) }
          ]);
      Parsetree.PVarDec {name = (22, "arr1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (12, "arrtype1");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (23, "arr2"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (18, "arrtype2");
          size = (Parsetree.PIntExp 5);
          init =
          Parsetree.PRecordExp {type_ = (13, "rectype1");
            fields =
            [((14, "name"), (Parsetree.PStringExp "aname"));
              ((15, "address"), (Parsetree.PStringExp "somewhere"));
              ((16, "id"), (Parsetree.PIntExp 0));
              ((17, "age"), (Parsetree.PIntExp 0))]}}};
      Parsetree.PVarDec {name = (24, "arr3"); escape = ref (true);
        type_ = (Some (21, "arrtype3"));
        init =
        Parsetree.PArrayExp {type_ = (21, "arrtype3");
          size = (Parsetree.PIntExp 100); init = (Parsetree.PStringExp "")}};
      Parsetree.PVarDec {name = (25, "rec1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (13, "rectype1");
          fields =
          [((14, "name"), (Parsetree.PStringExp "Kapoios"));
            ((15, "address"), (Parsetree.PStringExp "Kapou"));
            ((16, "id"), (Parsetree.PIntExp 2432));
            ((17, "age"), (Parsetree.PIntExp 44))]}};
      Parsetree.PVarDec {name = (26, "rec2"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (19, "rectype2");
          fields =
          [((14, "name"), (Parsetree.PStringExp "Allos"));
            ((20, "dates"),
             Parsetree.PArrayExp {type_ = (12, "arrtype1");
               size = (Parsetree.PIntExp 3); init = (Parsetree.PIntExp 1900)})
            ]}}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.PAssignExp {
          var =
          (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (22, "arr1")),
             (Parsetree.PIntExp 0)));
          exp = (Parsetree.PIntExp 1)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (22, "arr1")),
              (Parsetree.PIntExp 9)));
           exp = (Parsetree.PIntExp 3)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar (
              (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (23, "arr2")),
                 (Parsetree.PIntExp 3))),
              (14, "name")));
           exp = (Parsetree.PStringExp "kati")};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar (
              (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (23, "arr2")),
                 (Parsetree.PIntExp 1))),
              (17, "age")));
           exp = (Parsetree.PIntExp 23)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (24, "arr3")),
              (Parsetree.PIntExp 34)));
           exp = (Parsetree.PStringExp "sfd")};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar ((Parsetree.PSimpleVar (25, "rec1")),
              (14, "name")));
           exp = (Parsetree.PStringExp "sdf")};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar (
              (Parsetree.PFieldVar ((Parsetree.PSimpleVar (26, "rec2")),
                 (20, "dates"))),
              (Parsetree.PIntExp 0)));
           exp = (Parsetree.PIntExp 2323)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar (
              (Parsetree.PFieldVar ((Parsetree.PSimpleVar (26, "rec2")),
                 (20, "dates"))),
              (Parsetree.PIntExp 2)));
           exp = (Parsetree.PIntExp 2323)}
         ])}
