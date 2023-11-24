  $  cat ./code.tig
  /* error: definition of recursive types is interrupted */
  let
  /* define a tree */
  type tree ={key: int, children: treelist}
  var d:int :=0
  type treelist = {hd: tree, tl: treelist}
  
  in
  	d
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (12, "tree");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (13, "key"); pfd_escape = ref (true);
                 pfd_type = (10, "int") };
                { Parsetree.pfd_name = (14, "children");
                  pfd_escape = ref (true); pfd_type = (15, "treelist") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (16, "d"); escape = ref (true);
        type_ = (Some (10, "int")); init = (Parsetree.PIntExp 0)};
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (15, "treelist");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (17, "hd"); pfd_escape = ref (true);
                  pfd_type = (12, "tree") };
                 { Parsetree.pfd_name = (18, "tl"); pfd_escape = ref (true);
                   pfd_type = (15, "treelist") }
                 ])
            }
           ])
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (16, "d")))}
  error: unbound type: treelist
