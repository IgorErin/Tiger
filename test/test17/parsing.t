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
        [{ Parsetree.ptd_name = (0, "tree");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (1, "key"); pfd_escape = ref (true);
                 pfd_type = (2, "int") };
                { Parsetree.pfd_name = (3, "children");
                  pfd_escape = ref (true); pfd_type = (4, "treelist") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (5, "d"); escape = ref (true);
        type_ = (Some (2, "int")); init = (Parsetree.PIntExp 0)};
      (Parsetree.PTypeDec
         [{ Parsetree.ptd_name = (4, "treelist");
            ptd_type =
            (Parsetree.RecordTy
               [{ Parsetree.pfd_name = (6, "hd"); pfd_escape = ref (true);
                  pfd_type = (0, "tree") };
                 { Parsetree.pfd_name = (7, "tl"); pfd_escape = ref (true);
                   pfd_type = (4, "treelist") }
                 ])
            }
           ])
      ];
    body = (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "d")))}
