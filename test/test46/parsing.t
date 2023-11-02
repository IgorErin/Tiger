  $  cat ./code.tig
  /* valid rec comparisons */
  let 
  	type rectype = {name:string, id:int}
  	var b:rectype := nil
  in
  	(b = nil;
  	b <> nil)
  end
  $ Tiger -dparsetree ./code.tig 
  Parsetree.PLetExp {
    decs =
    [(Parsetree.PTypeDec
        [{ Parsetree.ptd_name = (0, "rectype");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (1, "name"); pfd_escape = ref (true);
                 pfd_type = (2, "string") };
                { Parsetree.pfd_name = (3, "id"); pfd_escape = ref (true);
                  pfd_type = (4, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (5, "b"); escape = ref (true);
        type_ = (Some (0, "rectype")); init = Parsetree.PNilExp}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.POpExp {
          left = (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "b")));
          oper = Parsetree.EqOp; right = Parsetree.PNilExp};
         Parsetree.POpExp {
           left = (Parsetree.PVarExp (Parsetree.PSimpleVar (5, "b")));
           oper = Parsetree.NeqOp; right = Parsetree.PNilExp}
         ])}
