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
        [{ Parsetree.ptd_name = (12, "rectype");
           ptd_type =
           (Parsetree.RecordTy
              [{ Parsetree.pfd_name = (13, "name"); pfd_escape = ref (true);
                 pfd_type = (11, "string") };
                { Parsetree.pfd_name = (14, "id"); pfd_escape = ref (true);
                  pfd_type = (10, "int") }
                ])
           }
          ]);
      Parsetree.PVarDec {name = (15, "b"); escape = ref (true);
        type_ = (Some (12, "rectype")); init = Parsetree.PNilExp}
      ];
    body =
    (Parsetree.PSeqExp
       [Parsetree.POpExp {
          left = (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "b")));
          oper = Parsetree.EqOp; right = Parsetree.PNilExp};
         Parsetree.POpExp {
           left = (Parsetree.PVarExp (Parsetree.PSimpleVar (15, "b")));
           oper = Parsetree.NeqOp; right = Parsetree.PNilExp}
         ])}
