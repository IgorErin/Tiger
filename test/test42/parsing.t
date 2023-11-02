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
        [{ Parsetree.ptd_name = (0, "arrtype1");
           ptd_type = (Parsetree.ArrayTy (1, "int")) };
          { Parsetree.ptd_name = (2, "rectype1");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (3, "name"); pfd_escape = ref (true);
                  pfd_type = (4, "string") };
                 { Parsetree.pfd_name = (5, "address");
                   pfd_escape = ref (true); pfd_type = (4, "string") };
                 { Parsetree.pfd_name = (6, "id"); pfd_escape = ref (true);
                   pfd_type = (1, "int") };
                 { Parsetree.pfd_name = (7, "age"); pfd_escape = ref (true);
                   pfd_type = (1, "int") }
                 ])
            };
          { Parsetree.ptd_name = (8, "arrtype2");
            ptd_type = (Parsetree.ArrayTy (2, "rectype1")) };
          { Parsetree.ptd_name = (9, "rectype2");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (3, "name"); pfd_escape = ref (true);
                  pfd_type = (4, "string") };
                 { Parsetree.pfd_name = (10, "dates"); pfd_escape = ref (true);
                   pfd_type = (0, "arrtype1") }
                 ])
            };
          { Parsetree.ptd_name = (11, "arrtype3");
            ptd_type = (Parsetree.ArrayTy (4, "string")) }
          ]);
      Parsetree.PVarDec {name = (12, "arr1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (0, "arrtype1");
          size = (Parsetree.PIntExp 10); init = (Parsetree.PIntExp 0)}};
      Parsetree.PVarDec {name = (13, "arr2"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PArrayExp {type_ = (8, "arrtype2");
          size = (Parsetree.PIntExp 5);
          init =
          Parsetree.PRecordExp {type_ = (2, "rectype1");
            fields =
            [((3, "name"), (Parsetree.PStringExp "aname"));
              ((5, "address"), (Parsetree.PStringExp "somewhere"));
              ((6, "id"), (Parsetree.PIntExp 0));
              ((7, "age"), (Parsetree.PIntExp 0))]}}};
      Parsetree.PVarDec {name = (14, "arr3"); escape = ref (true);
        type_ = (Some (11, "arrtype3"));
        init =
        Parsetree.PArrayExp {type_ = (11, "arrtype3");
          size = (Parsetree.PIntExp 100); init = (Parsetree.PStringExp "")}};
      Parsetree.PVarDec {name = (15, "rec1"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (2, "rectype1");
          fields =
          [((3, "name"), (Parsetree.PStringExp "Kapoios"));
            ((5, "address"), (Parsetree.PStringExp "Kapou"));
            ((6, "id"), (Parsetree.PIntExp 2432));
            ((7, "age"), (Parsetree.PIntExp 44))]}};
      Parsetree.PVarDec {name = (16, "rec2"); escape = ref (true);
        type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (9, "rectype2");
          fields =
          [((3, "name"), (Parsetree.PStringExp "Allos"));
            ((10, "dates"),
             Parsetree.PArrayExp {type_ = (0, "arrtype1");
               size = (Parsetree.PIntExp 3); init = (Parsetree.PIntExp 1900)})
            ]}}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.PAssignExp {
          var =
          (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (12, "arr1")),
             (Parsetree.PIntExp 0)));
          exp = (Parsetree.PIntExp 1)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (12, "arr1")),
              (Parsetree.PIntExp 9)));
           exp = (Parsetree.PIntExp 3)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar (
              (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (13, "arr2")),
                 (Parsetree.PIntExp 3))),
              (3, "name")));
           exp = (Parsetree.PStringExp "kati")};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar (
              (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (13, "arr2")),
                 (Parsetree.PIntExp 1))),
              (7, "age")));
           exp = (Parsetree.PIntExp 23)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar ((Parsetree.PSimpleVar (14, "arr3")),
              (Parsetree.PIntExp 34)));
           exp = (Parsetree.PStringExp "sfd")};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PFieldVar ((Parsetree.PSimpleVar (15, "rec1")),
              (3, "name")));
           exp = (Parsetree.PStringExp "sdf")};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar (
              (Parsetree.PFieldVar ((Parsetree.PSimpleVar (16, "rec2")),
                 (10, "dates"))),
              (Parsetree.PIntExp 0)));
           exp = (Parsetree.PIntExp 2323)};
         Parsetree.PAssignExp {
           var =
           (Parsetree.PSubscriptVar (
              (Parsetree.PFieldVar ((Parsetree.PSimpleVar (16, "rec2")),
                 (10, "dates"))),
              (Parsetree.PIntExp 2)));
           exp = (Parsetree.PIntExp 2323)}
         ])}
