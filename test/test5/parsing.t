  $  cat ./code.tig
  /* define valid recursive types */
  let
  /* define a list */
  type intlist = {hd: int, tl: intlist} 
  
  /* define a tree */
  type tree ={key: int, children: treelist}
  
  type treelist = {hd: tree, tl: treelist}
  
  
  var lis := intlist { hd=0, tl= nil } 
  
  in
  	()
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "intlist");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (13, "hd"); pfd_escape = ref (true);
                 pfd_type = (10, "int") };
                { Parsetree.pfd_name = (14, "tl"); pfd_escape = ref (true);
                  pfd_type = (12, "intlist") }
                ])
           };
          { Parsetree.ptd_name = (15, "tree");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (16, "key"); pfd_escape = ref (true);
                  pfd_type = (10, "int") };
                 { Parsetree.pfd_name = (17, "children");
                   pfd_escape = ref (true); pfd_type = (18, "treelist") }
                 ])
            };
          { Parsetree.ptd_name = (18, "treelist");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (13, "hd"); pfd_escape = ref (true);
                  pfd_type = (15, "tree") };
                 { Parsetree.pfd_name = (14, "tl"); pfd_escape = ref (true);
                   pfd_type = (18, "treelist") }
                 ])
            }
          ]);
      Parsetree.PVarDec {name = (19, "lis"); escape = ref (true); type_ = None;
        init =
        Parsetree.PRecordExp {type_ = (12, "intlist");
          fields =
          [((13, "hd"), (Parsetree.PIntExp 0)); ((14, "tl"), Parsetree.PNilExp)
            ]}}
      ];
    body = (Parsetree.PSeqExp [])}
