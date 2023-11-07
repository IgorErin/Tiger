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
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TTypeDec
          [{ Typedtree.td_name = (12, "intlist");
             td_type = {(hd : int)(tl : (Name  intlist))} };
            { Typedtree.td_name = (15, "tree");
              td_type = {(key : int)(children : (Name  treelist))} };
            { Typedtree.td_name = (18, "treelist");
              td_type = {(hd : (Name  tree))(tl : (Name  treelist))} }
            ]);
        Typedtree.TVarDec {name = (19, "lis"); escape = ref (true);
          type_ = {(hd : int)(tl : (Name  intlist))};
          init =
          { Typedtree.exp_desc =
            Typedtree.TRecordExp {type_ = {(hd : int)(tl : (Name  intlist))};
              fields =
              [((13, "hd"), int,
                { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int });
                ((14, "tl"), (Name  intlist),
                 { Typedtree.exp_desc = Typedtree.TNilExp; exp_type = nil })
                ]};
            exp_type = {(hd : int)(tl : (Name  intlist))} }}
        ];
      body = { Typedtree.exp_desc = (Typedtree.TSeqExp []); exp_type = unit }};
    exp_type = unit }
