  $  cat ./code.tig
  /* define valid recursive types */
  let
  /* define a list */
  type intlist = {hd: int, tl: intlist} 
  
  /* define a tree */
  type tree ={key: int, children: treelist}
  type treelist = {hd: tree, tl: treelist}
  
  var lis:intlist := intlist { hd=0, tl= nil } 
  
  in
  	lis
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "intlist");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (1, "hd"); pfd_escape = ref (true);
                 pfd_type = (2, "int") };
                { Parsetree.pfd_name = (3, "tl"); pfd_escape = ref (true);
                  pfd_type = (0, "intlist") }
                ])
           };
          { Parsetree.ptd_name = (4, "tree");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (5, "key"); pfd_escape = ref (true);
                  pfd_type = (2, "int") };
                 { Parsetree.pfd_name = (6, "children");
                   pfd_escape = ref (true); pfd_type = (7, "treelist") }
                 ])
            };
          { Parsetree.ptd_name = (7, "treelist");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (1, "hd"); pfd_escape = ref (true);
                  pfd_type = (4, "tree") };
                 { Parsetree.pfd_name = (3, "tl"); pfd_escape = ref (true);
                   pfd_type = (7, "treelist") }
                 ])
            }
          ]);
      Parsetree.PVarDec {name = (8, "lis"); escape = ref (true);
        type_ = (Some (0, "intlist"));
        init =
        Parsetree.PRecordExp {type_ = (0, "intlist");
          fields =
          [((1, "hd"), (Parsetree.PIntExp 0)); ((3, "tl"), Parsetree.PNilExp)]}}
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (8, "lis")))}
