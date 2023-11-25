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
  $ Tiger -dir ./code.tig
  string (("L", 4) : "aname")
  string (("L", 5) : "somewhere")
  string (("L", 8) : "")
  string (("L", 10) : "Kapoios")
  string (("L", 11) : "Kapou")
  string (("L", 13) : "Allos")
  string (("L", 37) : "kati")
  string (("L", 53) : "sfd")
  string (("L", 57) : "sdf")
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))),
            (Ir.Call ((Ir.Name ("init_array", 3)),
               [(Ir.Const 0); (Ir.Const 10)]))
            ));
          (Ir.Move (
             (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 4)))),
             (Ir.Call ((Ir.Name ("init_array", 7)),
                [(Ir.Eseq (
                    (Ir.Seq
                       [(Ir.Seq
                           [(Ir.Seq
                               [(Ir.Seq
                                   [(Ir.Move ((Ir.Temp ("T", 1)),
                                       (Ir.Call ((Ir.Name ("malloc", 6)),
                                          [(Ir.Const 4)]))
                                       ));
                                     (Ir.Move (
                                        (Ir.Mem
                                           (Ir.BinOp (Ir.Plus, (Ir.Const 0),
                                              (Ir.Temp ("T", 1))))),
                                        (Ir.Name ("L", 4))))
                                     ]);
                                 (Ir.Move (
                                    (Ir.Mem
                                       (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                          (Ir.Temp ("T", 1))))),
                                    (Ir.Name ("L", 5))))
                                 ]);
                             (Ir.Move (
                                (Ir.Mem
                                   (Ir.BinOp (Ir.Plus, (Ir.Const 8),
                                      (Ir.Temp ("T", 1))))),
                                (Ir.Const 0)))
                             ]);
                         (Ir.Move (
                            (Ir.Mem
                               (Ir.BinOp (Ir.Plus, (Ir.Const 12),
                                  (Ir.Temp ("T", 1))))),
                            (Ir.Const 0)))
                         ]),
                    (Ir.Temp ("T", 1))));
                  (Ir.Const 5)]
                ))
             ));
          (Ir.Move (
             (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 8)))),
             (Ir.Call ((Ir.Name ("init_array", 9)),
                [(Ir.Name ("L", 8)); (Ir.Const 100)]))
             ));
          (Ir.Move (
             (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 12)))),
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.Seq
                       [(Ir.Seq
                           [(Ir.Seq
                               [(Ir.Move ((Ir.Temp ("T", 2)),
                                   (Ir.Call ((Ir.Name ("malloc", 12)),
                                      [(Ir.Const 4)]))
                                   ));
                                 (Ir.Move (
                                    (Ir.Mem
                                       (Ir.BinOp (Ir.Plus, (Ir.Const 0),
                                          (Ir.Temp ("T", 2))))),
                                    (Ir.Name ("L", 10))))
                                 ]);
                             (Ir.Move (
                                (Ir.Mem
                                   (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                      (Ir.Temp ("T", 2))))),
                                (Ir.Name ("L", 11))))
                             ]);
                         (Ir.Move (
                            (Ir.Mem
                               (Ir.BinOp (Ir.Plus, (Ir.Const 8),
                                  (Ir.Temp ("T", 2))))),
                            (Ir.Const 2432)))
                         ]);
                     (Ir.Move (
                        (Ir.Mem
                           (Ir.BinOp (Ir.Plus, (Ir.Const 12),
                              (Ir.Temp ("T", 2))))),
                        (Ir.Const 44)))
                     ]),
                (Ir.Temp ("T", 2))))
             ));
          (Ir.Move (
             (Ir.Mem (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 16)))),
             (Ir.Eseq (
                (Ir.Seq
                   [(Ir.Seq
                       [(Ir.Move ((Ir.Temp ("T", 3)),
                           (Ir.Call ((Ir.Name ("malloc", 15)), [(Ir.Const 2)]))
                           ));
                         (Ir.Move (
                            (Ir.Mem
                               (Ir.BinOp (Ir.Plus, (Ir.Const 0),
                                  (Ir.Temp ("T", 3))))),
                            (Ir.Name ("L", 13))))
                         ]);
                     (Ir.Move (
                        (Ir.Mem
                           (Ir.BinOp (Ir.Plus, (Ir.Const 4), (Ir.Temp ("T", 3))
                              ))),
                        (Ir.Call ((Ir.Name ("init_array", 14)),
                           [(Ir.Const 1900); (Ir.Const 3)]))
                        ))
                     ]),
                (Ir.Temp ("T", 3))))
             ));
          (Ir.Seq
             [(Ir.Move (
                 (Ir.Eseq (
                    (Ir.Seq
                       [(Ir.CJump (Ir.GE, (Ir.Const 0), (Ir.Const 0),
                           ("L", 21), ("L", 20)));
                         (Ir.Label ("L", 21));
                         (Ir.CJump (Ir.LT, (Ir.Const 0),
                            (Ir.Mem
                               (Ir.Eseq (
                                  (Ir.Seq
                                     [(Ir.CJump (Ir.EQ,
                                         (Ir.Mem (Ir.Temp ("FP", 0))),
                                         (Ir.Const 0), ("L", 17), ("L", 16)));
                                       (Ir.Label ("L", 17));
                                       (Ir.Exp
                                          (Ir.Call ((Ir.Name ("null_ref", 18)),
                                             [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                                       (Ir.Label ("L", 16))]),
                                  (Ir.Mem (Ir.Temp ("FP", 0)))))),
                            ("L", 19), ("L", 20)));
                         (Ir.Label ("L", 20));
                         (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                         (Ir.Label ("L", 19))]),
                    (Ir.Mem
                       (Ir.BinOp (Ir.Plus,
                          (Ir.Eseq (
                             (Ir.Seq
                                [(Ir.CJump (Ir.EQ,
                                    (Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Const 0),
                                    ("L", 17), ("L", 16)));
                                  (Ir.Label ("L", 17));
                                  (Ir.Exp
                                     (Ir.Call ((Ir.Name ("null_ref", 18)),
                                        [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                                  (Ir.Label ("L", 16))]),
                             (Ir.Mem (Ir.Temp ("FP", 0))))),
                          (Ir.BinOp (Ir.Mul, (Ir.Const 0), (Ir.Const 4))))))
                    )),
                 (Ir.Const 1)));
               (Ir.Move (
                  (Ir.Eseq (
                     (Ir.Seq
                        [(Ir.CJump (Ir.GE, (Ir.Const 9), (Ir.Const 0),
                            ("L", 27), ("L", 26)));
                          (Ir.Label ("L", 27));
                          (Ir.CJump (Ir.LT, (Ir.Const 9),
                             (Ir.Mem
                                (Ir.Eseq (
                                   (Ir.Seq
                                      [(Ir.CJump (Ir.EQ,
                                          (Ir.Mem (Ir.Temp ("FP", 0))),
                                          (Ir.Const 0), ("L", 23), ("L", 22)));
                                        (Ir.Label ("L", 23));
                                        (Ir.Exp
                                           (Ir.Call (
                                              (Ir.Name ("null_ref", 24)),
                                              [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                                        (Ir.Label ("L", 22))]),
                                   (Ir.Mem (Ir.Temp ("FP", 0)))))),
                             ("L", 25), ("L", 26)));
                          (Ir.Label ("L", 26));
                          (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                          (Ir.Label ("L", 25))]),
                     (Ir.Mem
                        (Ir.BinOp (Ir.Plus,
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.EQ,
                                     (Ir.Mem (Ir.Temp ("FP", 0))),
                                     (Ir.Const 0), ("L", 23), ("L", 22)));
                                   (Ir.Label ("L", 23));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("null_ref", 24)),
                                         [(Ir.Mem (Ir.Temp ("FP", 0)))])));
                                   (Ir.Label ("L", 22))]),
                              (Ir.Mem (Ir.Temp ("FP", 0))))),
                           (Ir.BinOp (Ir.Mul, (Ir.Const 9), (Ir.Const 4))))))
                     )),
                  (Ir.Const 3)));
               (Ir.Move (
                  (Ir.Eseq (
                     (Ir.Seq
                        [(Ir.CJump (Ir.EQ,
                            (Ir.Eseq (
                               (Ir.Seq
                                  [(Ir.CJump (Ir.GE, (Ir.Const 3),
                                      (Ir.Const 0), ("L", 33), ("L", 32)));
                                    (Ir.Label ("L", 33));
                                    (Ir.CJump (Ir.LT, (Ir.Const 3),
                                       (Ir.Mem
                                          (Ir.Eseq (
                                             (Ir.Seq
                                                [(Ir.CJump (Ir.EQ,
                                                    (Ir.Mem
                                                       (Ir.BinOp (Ir.Plus,
                                                          (Ir.Temp ("FP", 0)),
                                                          (Ir.Const 4)))),
                                                    (Ir.Const 0), ("L", 29),
                                                    ("L", 28)));
                                                  (Ir.Label ("L", 29));
                                                  (Ir.Exp
                                                     (Ir.Call (
                                                        (Ir.Name
                                                           ("null_ref", 30)),
                                                        [(Ir.Mem
                                                            (Ir.BinOp (Ir.Plus,
                                                               (Ir.Temp
                                                                  ("FP", 0)),
                                                               (Ir.Const 4))))
                                                          ]
                                                        )));
                                                  (Ir.Label ("L", 28))]),
                                             (Ir.Mem
                                                (Ir.BinOp (Ir.Plus,
                                                   (Ir.Temp ("FP", 0)),
                                                   (Ir.Const 4))))
                                             ))),
                                       ("L", 31), ("L", 32)));
                                    (Ir.Label ("L", 32));
                                    (Ir.Exp
                                       (Ir.Call ((Ir.Name ("out_of_bound", 2)),
                                          [])));
                                    (Ir.Label ("L", 31))]),
                               (Ir.Mem
                                  (Ir.BinOp (Ir.Plus,
                                     (Ir.Eseq (
                                        (Ir.Seq
                                           [(Ir.CJump (Ir.EQ,
                                               (Ir.Mem
                                                  (Ir.BinOp (Ir.Plus,
                                                     (Ir.Temp ("FP", 0)),
                                                     (Ir.Const 4)))),
                                               (Ir.Const 0), ("L", 29),
                                               ("L", 28)));
                                             (Ir.Label ("L", 29));
                                             (Ir.Exp
                                                (Ir.Call (
                                                   (Ir.Name ("null_ref", 30)),
                                                   [(Ir.Mem
                                                       (Ir.BinOp (Ir.Plus,
                                                          (Ir.Temp ("FP", 0)),
                                                          (Ir.Const 4))))
                                                     ]
                                                   )));
                                             (Ir.Label ("L", 28))]),
                                        (Ir.Mem
                                           (Ir.BinOp (Ir.Plus,
                                              (Ir.Temp ("FP", 0)), (Ir.Const 4)
                                              )))
                                        )),
                                     (Ir.BinOp (Ir.Mul, (Ir.Const 3),
                                        (Ir.Const 4)))
                                     )))
                               )),
                            (Ir.Const 0), ("L", 35), ("L", 34)));
                          (Ir.Label ("L", 35));
                          (Ir.Exp
                             (Ir.Call ((Ir.Name ("null_ref", 36)),
                                [(Ir.Eseq (
                                    (Ir.Seq
                                       [(Ir.CJump (Ir.GE, (Ir.Const 3),
                                           (Ir.Const 0), ("L", 33), ("L", 32)));
                                         (Ir.Label ("L", 33));
                                         (Ir.CJump (Ir.LT, (Ir.Const 3),
                                            (Ir.Mem
                                               (Ir.Eseq (
                                                  (Ir.Seq
                                                     [(Ir.CJump (Ir.EQ,
                                                         (Ir.Mem
                                                            (Ir.BinOp (Ir.Plus,
                                                               (Ir.Temp
                                                                  ("FP", 0)),
                                                               (Ir.Const 4)))),
                                                         (Ir.Const 0),
                                                         ("L", 29), ("L", 28)));
                                                       (Ir.Label ("L", 29));
                                                       (Ir.Exp
                                                          (Ir.Call (
                                                             (Ir.Name
                                                                ("null_ref", 30)),
                                                             [(Ir.Mem
                                                                 (Ir.BinOp (
                                                                    Ir.Plus,
                                                                    (Ir.Temp
                                                                      ("FP", 0)),
                                                                    (Ir.Const 4)
                                                                    )))
                                                               ]
                                                             )));
                                                       (Ir.Label ("L", 28))]),
                                                  (Ir.Mem
                                                     (Ir.BinOp (Ir.Plus,
                                                        (Ir.Temp ("FP", 0)),
                                                        (Ir.Const 4))))
                                                  ))),
                                            ("L", 31), ("L", 32)));
                                         (Ir.Label ("L", 32));
                                         (Ir.Exp
                                            (Ir.Call (
                                               (Ir.Name ("out_of_bound", 2)),
                                               [])));
                                         (Ir.Label ("L", 31))]),
                                    (Ir.Mem
                                       (Ir.BinOp (Ir.Plus,
                                          (Ir.Eseq (
                                             (Ir.Seq
                                                [(Ir.CJump (Ir.EQ,
                                                    (Ir.Mem
                                                       (Ir.BinOp (Ir.Plus,
                                                          (Ir.Temp ("FP", 0)),
                                                          (Ir.Const 4)))),
                                                    (Ir.Const 0), ("L", 29),
                                                    ("L", 28)));
                                                  (Ir.Label ("L", 29));
                                                  (Ir.Exp
                                                     (Ir.Call (
                                                        (Ir.Name
                                                           ("null_ref", 30)),
                                                        [(Ir.Mem
                                                            (Ir.BinOp (Ir.Plus,
                                                               (Ir.Temp
                                                                  ("FP", 0)),
                                                               (Ir.Const 4))))
                                                          ]
                                                        )));
                                                  (Ir.Label ("L", 28))]),
                                             (Ir.Mem
                                                (Ir.BinOp (Ir.Plus,
                                                   (Ir.Temp ("FP", 0)),
                                                   (Ir.Const 4))))
                                             )),
                                          (Ir.BinOp (Ir.Mul, (Ir.Const 3),
                                             (Ir.Const 4)))
                                          )))
                                    ))
                                  ]
                                )));
                          (Ir.Label ("L", 34))]),
                     (Ir.Eseq (
                        (Ir.Seq
                           [(Ir.CJump (Ir.GE, (Ir.Const 3), (Ir.Const 0),
                               ("L", 33), ("L", 32)));
                             (Ir.Label ("L", 33));
                             (Ir.CJump (Ir.LT, (Ir.Const 3),
                                (Ir.Mem
                                   (Ir.Eseq (
                                      (Ir.Seq
                                         [(Ir.CJump (Ir.EQ,
                                             (Ir.Mem
                                                (Ir.BinOp (Ir.Plus,
                                                   (Ir.Temp ("FP", 0)),
                                                   (Ir.Const 4)))),
                                             (Ir.Const 0), ("L", 29), (
                                             "L", 28)));
                                           (Ir.Label ("L", 29));
                                           (Ir.Exp
                                              (Ir.Call (
                                                 (Ir.Name ("null_ref", 30)),
                                                 [(Ir.Mem
                                                     (Ir.BinOp (Ir.Plus,
                                                        (Ir.Temp ("FP", 0)),
                                                        (Ir.Const 4))))
                                                   ]
                                                 )));
                                           (Ir.Label ("L", 28))]),
                                      (Ir.Mem
                                         (Ir.BinOp (Ir.Plus,
                                            (Ir.Temp ("FP", 0)), (Ir.Const 4))))
                                      ))),
                                ("L", 31), ("L", 32)));
                             (Ir.Label ("L", 32));
                             (Ir.Exp
                                (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                             (Ir.Label ("L", 31))]),
                        (Ir.Mem
                           (Ir.BinOp (Ir.Plus,
                              (Ir.Eseq (
                                 (Ir.Seq
                                    [(Ir.CJump (Ir.EQ,
                                        (Ir.Mem
                                           (Ir.BinOp (Ir.Plus,
                                              (Ir.Temp ("FP", 0)), (Ir.Const 4)
                                              ))),
                                        (Ir.Const 0), ("L", 29), ("L", 28)));
                                      (Ir.Label ("L", 29));
                                      (Ir.Exp
                                         (Ir.Call ((Ir.Name ("null_ref", 30)),
                                            [(Ir.Mem
                                                (Ir.BinOp (Ir.Plus,
                                                   (Ir.Temp ("FP", 0)),
                                                   (Ir.Const 4))))
                                              ]
                                            )));
                                      (Ir.Label ("L", 28))]),
                                 (Ir.Mem
                                    (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)),
                                       (Ir.Const 4))))
                                 )),
                              (Ir.BinOp (Ir.Mul, (Ir.Const 3), (Ir.Const 4))))))
                        ))
                     )),
                  (Ir.Name ("L", 37))));
               (Ir.Move (
                  (Ir.Mem
                     (Ir.BinOp (Ir.Plus, (Ir.Const 12),
                        (Ir.Eseq (
                           (Ir.Seq
                              [(Ir.CJump (Ir.EQ,
                                  (Ir.Eseq (
                                     (Ir.Seq
                                        [(Ir.CJump (Ir.GE, (Ir.Const 1),
                                            (Ir.Const 0), ("L", 43), ("L", 42)
                                            ));
                                          (Ir.Label ("L", 43));
                                          (Ir.CJump (Ir.LT, (Ir.Const 1),
                                             (Ir.Mem
                                                (Ir.Eseq (
                                                   (Ir.Seq
                                                      [(Ir.CJump (Ir.EQ,
                                                          (Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 4)))),
                                                          (Ir.Const 0),
                                                          ("L", 39), ("L", 38)
                                                          ));
                                                        (Ir.Label ("L", 39));
                                                        (Ir.Exp
                                                           (Ir.Call (
                                                              (Ir.Name
                                                                 ("null_ref",
                                                                  40)),
                                                              [(Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      4)
                                                                     )))
                                                                ]
                                                              )));
                                                        (Ir.Label ("L", 38))]),
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 4))))
                                                   ))),
                                             ("L", 41), ("L", 42)));
                                          (Ir.Label ("L", 42));
                                          (Ir.Exp
                                             (Ir.Call (
                                                (Ir.Name ("out_of_bound", 2)),
                                                [])));
                                          (Ir.Label ("L", 41))]),
                                     (Ir.Mem
                                        (Ir.BinOp (Ir.Plus,
                                           (Ir.Eseq (
                                              (Ir.Seq
                                                 [(Ir.CJump (Ir.EQ,
                                                     (Ir.Mem
                                                        (Ir.BinOp (Ir.Plus,
                                                           (Ir.Temp ("FP", 0)),
                                                           (Ir.Const 4)))),
                                                     (Ir.Const 0), ("L", 39),
                                                     ("L", 38)));
                                                   (Ir.Label ("L", 39));
                                                   (Ir.Exp
                                                      (Ir.Call (
                                                         (Ir.Name
                                                            ("null_ref", 40)),
                                                         [(Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 4))))
                                                           ]
                                                         )));
                                                   (Ir.Label ("L", 38))]),
                                              (Ir.Mem
                                                 (Ir.BinOp (Ir.Plus,
                                                    (Ir.Temp ("FP", 0)),
                                                    (Ir.Const 4))))
                                              )),
                                           (Ir.BinOp (Ir.Mul, (Ir.Const 1),
                                              (Ir.Const 4)))
                                           )))
                                     )),
                                  (Ir.Const 0), ("L", 45), ("L", 44)));
                                (Ir.Label ("L", 45));
                                (Ir.Exp
                                   (Ir.Call ((Ir.Name ("null_ref", 46)),
                                      [(Ir.Eseq (
                                          (Ir.Seq
                                             [(Ir.CJump (Ir.GE, (Ir.Const 1),
                                                 (Ir.Const 0), ("L", 43),
                                                 ("L", 42)));
                                               (Ir.Label ("L", 43));
                                               (Ir.CJump (Ir.LT, (Ir.Const 1),
                                                  (Ir.Mem
                                                     (Ir.Eseq (
                                                        (Ir.Seq
                                                           [(Ir.CJump (Ir.EQ,
                                                               (Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      4)
                                                                     ))),
                                                               (Ir.Const 0),
                                                               ("L", 39),
                                                               ("L", 38)));
                                                             (Ir.Label
                                                                ("L", 39));
                                                             (Ir.Exp
                                                                (Ir.Call (
                                                                   (Ir.Name
                                                                      (
                                                                      "null_ref",
                                                                      40)),
                                                                   [(Ir.Mem
                                                                      (Ir.BinOp (
                                                                      Ir.Plus,
                                                                      (Ir.Temp
                                                                      ("FP", 0)),
                                                                      (Ir.Const
                                                                      4))))
                                                                     ]
                                                                   )));
                                                             (Ir.Label
                                                                ("L", 38))
                                                             ]),
                                                        (Ir.Mem
                                                           (Ir.BinOp (Ir.Plus,
                                                              (Ir.Temp
                                                                 ("FP", 0)),
                                                              (Ir.Const 4))))
                                                        ))),
                                                  ("L", 41), ("L", 42)));
                                               (Ir.Label ("L", 42));
                                               (Ir.Exp
                                                  (Ir.Call (
                                                     (Ir.Name
                                                        ("out_of_bound", 2)),
                                                     [])));
                                               (Ir.Label ("L", 41))]),
                                          (Ir.Mem
                                             (Ir.BinOp (Ir.Plus,
                                                (Ir.Eseq (
                                                   (Ir.Seq
                                                      [(Ir.CJump (Ir.EQ,
                                                          (Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 4)))),
                                                          (Ir.Const 0),
                                                          ("L", 39), ("L", 38)
                                                          ));
                                                        (Ir.Label ("L", 39));
                                                        (Ir.Exp
                                                           (Ir.Call (
                                                              (Ir.Name
                                                                 ("null_ref",
                                                                  40)),
                                                              [(Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      4)
                                                                     )))
                                                                ]
                                                              )));
                                                        (Ir.Label ("L", 38))]),
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 4))))
                                                   )),
                                                (Ir.BinOp (Ir.Mul,
                                                   (Ir.Const 1), (Ir.Const 4)))
                                                )))
                                          ))
                                        ]
                                      )));
                                (Ir.Label ("L", 44))]),
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.GE, (Ir.Const 1), (Ir.Const 0),
                                     ("L", 43), ("L", 42)));
                                   (Ir.Label ("L", 43));
                                   (Ir.CJump (Ir.LT, (Ir.Const 1),
                                      (Ir.Mem
                                         (Ir.Eseq (
                                            (Ir.Seq
                                               [(Ir.CJump (Ir.EQ,
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 4)))),
                                                   (Ir.Const 0), ("L", 39),
                                                   ("L", 38)));
                                                 (Ir.Label ("L", 39));
                                                 (Ir.Exp
                                                    (Ir.Call (
                                                       (Ir.Name
                                                          ("null_ref", 40)),
                                                       [(Ir.Mem
                                                           (Ir.BinOp (Ir.Plus,
                                                              (Ir.Temp
                                                                 ("FP", 0)),
                                                              (Ir.Const 4))))
                                                         ]
                                                       )));
                                                 (Ir.Label ("L", 38))]),
                                            (Ir.Mem
                                               (Ir.BinOp (Ir.Plus,
                                                  (Ir.Temp ("FP", 0)),
                                                  (Ir.Const 4))))
                                            ))),
                                      ("L", 41), ("L", 42)));
                                   (Ir.Label ("L", 42));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("out_of_bound", 2)),
                                         [])));
                                   (Ir.Label ("L", 41))]),
                              (Ir.Mem
                                 (Ir.BinOp (Ir.Plus,
                                    (Ir.Eseq (
                                       (Ir.Seq
                                          [(Ir.CJump (Ir.EQ,
                                              (Ir.Mem
                                                 (Ir.BinOp (Ir.Plus,
                                                    (Ir.Temp ("FP", 0)),
                                                    (Ir.Const 4)))),
                                              (Ir.Const 0), ("L", 39),
                                              ("L", 38)));
                                            (Ir.Label ("L", 39));
                                            (Ir.Exp
                                               (Ir.Call (
                                                  (Ir.Name ("null_ref", 40)),
                                                  [(Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 4))))
                                                    ]
                                                  )));
                                            (Ir.Label ("L", 38))]),
                                       (Ir.Mem
                                          (Ir.BinOp (Ir.Plus,
                                             (Ir.Temp ("FP", 0)), (Ir.Const 4)
                                             )))
                                       )),
                                    (Ir.BinOp (Ir.Mul, (Ir.Const 1),
                                       (Ir.Const 4)))
                                    )))
                              ))
                           ))
                        ))),
                  (Ir.Const 23)));
               (Ir.Move (
                  (Ir.Eseq (
                     (Ir.Seq
                        [(Ir.CJump (Ir.GE, (Ir.Const 34), (Ir.Const 0),
                            ("L", 52), ("L", 51)));
                          (Ir.Label ("L", 52));
                          (Ir.CJump (Ir.LT, (Ir.Const 34),
                             (Ir.Mem
                                (Ir.Eseq (
                                   (Ir.Seq
                                      [(Ir.CJump (Ir.EQ,
                                          (Ir.Mem
                                             (Ir.BinOp (Ir.Plus,
                                                (Ir.Temp ("FP", 0)),
                                                (Ir.Const 8)))),
                                          (Ir.Const 0), ("L", 48), ("L", 47)));
                                        (Ir.Label ("L", 48));
                                        (Ir.Exp
                                           (Ir.Call (
                                              (Ir.Name ("null_ref", 49)),
                                              [(Ir.Mem
                                                  (Ir.BinOp (Ir.Plus,
                                                     (Ir.Temp ("FP", 0)),
                                                     (Ir.Const 8))))
                                                ]
                                              )));
                                        (Ir.Label ("L", 47))]),
                                   (Ir.Mem
                                      (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)),
                                         (Ir.Const 8))))
                                   ))),
                             ("L", 50), ("L", 51)));
                          (Ir.Label ("L", 51));
                          (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                          (Ir.Label ("L", 50))]),
                     (Ir.Mem
                        (Ir.BinOp (Ir.Plus,
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.EQ,
                                     (Ir.Mem
                                        (Ir.BinOp (Ir.Plus,
                                           (Ir.Temp ("FP", 0)), (Ir.Const 8)))),
                                     (Ir.Const 0), ("L", 48), ("L", 47)));
                                   (Ir.Label ("L", 48));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("null_ref", 49)),
                                         [(Ir.Mem
                                             (Ir.BinOp (Ir.Plus,
                                                (Ir.Temp ("FP", 0)),
                                                (Ir.Const 8))))
                                           ]
                                         )));
                                   (Ir.Label ("L", 47))]),
                              (Ir.Mem
                                 (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)),
                                    (Ir.Const 8))))
                              )),
                           (Ir.BinOp (Ir.Mul, (Ir.Const 34), (Ir.Const 4))))))
                     )),
                  (Ir.Name ("L", 53))));
               (Ir.Move (
                  (Ir.Eseq (
                     (Ir.Seq
                        [(Ir.CJump (Ir.EQ,
                            (Ir.Mem
                               (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)),
                                  (Ir.Const 12)))),
                            (Ir.Const 0), ("L", 55), ("L", 54)));
                          (Ir.Label ("L", 55));
                          (Ir.Exp
                             (Ir.Call ((Ir.Name ("null_ref", 56)),
                                [(Ir.Mem
                                    (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)),
                                       (Ir.Const 12))))
                                  ]
                                )));
                          (Ir.Label ("L", 54))]),
                     (Ir.Mem
                        (Ir.BinOp (Ir.Plus, (Ir.Temp ("FP", 0)), (Ir.Const 12)
                           )))
                     )),
                  (Ir.Name ("L", 57))));
               (Ir.Move (
                  (Ir.Eseq (
                     (Ir.Seq
                        [(Ir.CJump (Ir.GE, (Ir.Const 0), (Ir.Const 0),
                            ("L", 66), ("L", 65)));
                          (Ir.Label ("L", 66));
                          (Ir.CJump (Ir.LT, (Ir.Const 0),
                             (Ir.Mem
                                (Ir.Eseq (
                                   (Ir.Seq
                                      [(Ir.CJump (Ir.EQ,
                                          (Ir.Mem
                                             (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                                (Ir.Eseq (
                                                   (Ir.Seq
                                                      [(Ir.CJump (Ir.EQ,
                                                          (Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 16)))),
                                                          (Ir.Const 0),
                                                          ("L", 59), ("L", 58)
                                                          ));
                                                        (Ir.Label ("L", 59));
                                                        (Ir.Exp
                                                           (Ir.Call (
                                                              (Ir.Name
                                                                 ("null_ref",
                                                                  60)),
                                                              [(Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      16)
                                                                     )))
                                                                ]
                                                              )));
                                                        (Ir.Label ("L", 58))]),
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16))))
                                                   ))
                                                ))),
                                          (Ir.Const 0), ("L", 62), ("L", 61)));
                                        (Ir.Label ("L", 62));
                                        (Ir.Exp
                                           (Ir.Call (
                                              (Ir.Name ("null_ref", 63)),
                                              [(Ir.Mem
                                                  (Ir.BinOp (Ir.Plus,
                                                     (Ir.Const 4),
                                                     (Ir.Eseq (
                                                        (Ir.Seq
                                                           [(Ir.CJump (Ir.EQ,
                                                               (Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      16)
                                                                     ))),
                                                               (Ir.Const 0),
                                                               ("L", 59),
                                                               ("L", 58)));
                                                             (Ir.Label
                                                                ("L", 59));
                                                             (Ir.Exp
                                                                (Ir.Call (
                                                                   (Ir.Name
                                                                      (
                                                                      "null_ref",
                                                                      60)),
                                                                   [(Ir.Mem
                                                                      (Ir.BinOp (
                                                                      Ir.Plus,
                                                                      (Ir.Temp
                                                                      ("FP", 0)),
                                                                      (Ir.Const
                                                                      16))))
                                                                     ]
                                                                   )));
                                                             (Ir.Label
                                                                ("L", 58))
                                                             ]),
                                                        (Ir.Mem
                                                           (Ir.BinOp (Ir.Plus,
                                                              (Ir.Temp
                                                                 ("FP", 0)),
                                                              (Ir.Const 16))))
                                                        ))
                                                     )))
                                                ]
                                              )));
                                        (Ir.Label ("L", 61))]),
                                   (Ir.Mem
                                      (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                         (Ir.Eseq (
                                            (Ir.Seq
                                               [(Ir.CJump (Ir.EQ,
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16)))),
                                                   (Ir.Const 0), ("L", 59),
                                                   ("L", 58)));
                                                 (Ir.Label ("L", 59));
                                                 (Ir.Exp
                                                    (Ir.Call (
                                                       (Ir.Name
                                                          ("null_ref", 60)),
                                                       [(Ir.Mem
                                                           (Ir.BinOp (Ir.Plus,
                                                              (Ir.Temp
                                                                 ("FP", 0)),
                                                              (Ir.Const 16))))
                                                         ]
                                                       )));
                                                 (Ir.Label ("L", 58))]),
                                            (Ir.Mem
                                               (Ir.BinOp (Ir.Plus,
                                                  (Ir.Temp ("FP", 0)),
                                                  (Ir.Const 16))))
                                            ))
                                         )))
                                   ))),
                             ("L", 64), ("L", 65)));
                          (Ir.Label ("L", 65));
                          (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                          (Ir.Label ("L", 64))]),
                     (Ir.Mem
                        (Ir.BinOp (Ir.Plus,
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.EQ,
                                     (Ir.Mem
                                        (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                           (Ir.Eseq (
                                              (Ir.Seq
                                                 [(Ir.CJump (Ir.EQ,
                                                     (Ir.Mem
                                                        (Ir.BinOp (Ir.Plus,
                                                           (Ir.Temp ("FP", 0)),
                                                           (Ir.Const 16)))),
                                                     (Ir.Const 0), ("L", 59),
                                                     ("L", 58)));
                                                   (Ir.Label ("L", 59));
                                                   (Ir.Exp
                                                      (Ir.Call (
                                                         (Ir.Name
                                                            ("null_ref", 60)),
                                                         [(Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 16))))
                                                           ]
                                                         )));
                                                   (Ir.Label ("L", 58))]),
                                              (Ir.Mem
                                                 (Ir.BinOp (Ir.Plus,
                                                    (Ir.Temp ("FP", 0)),
                                                    (Ir.Const 16))))
                                              ))
                                           ))),
                                     (Ir.Const 0), ("L", 62), ("L", 61)));
                                   (Ir.Label ("L", 62));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("null_ref", 63)),
                                         [(Ir.Mem
                                             (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                                (Ir.Eseq (
                                                   (Ir.Seq
                                                      [(Ir.CJump (Ir.EQ,
                                                          (Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 16)))),
                                                          (Ir.Const 0),
                                                          ("L", 59), ("L", 58)
                                                          ));
                                                        (Ir.Label ("L", 59));
                                                        (Ir.Exp
                                                           (Ir.Call (
                                                              (Ir.Name
                                                                 ("null_ref",
                                                                  60)),
                                                              [(Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      16)
                                                                     )))
                                                                ]
                                                              )));
                                                        (Ir.Label ("L", 58))]),
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16))))
                                                   ))
                                                )))
                                           ]
                                         )));
                                   (Ir.Label ("L", 61))]),
                              (Ir.Mem
                                 (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                    (Ir.Eseq (
                                       (Ir.Seq
                                          [(Ir.CJump (Ir.EQ,
                                              (Ir.Mem
                                                 (Ir.BinOp (Ir.Plus,
                                                    (Ir.Temp ("FP", 0)),
                                                    (Ir.Const 16)))),
                                              (Ir.Const 0), ("L", 59),
                                              ("L", 58)));
                                            (Ir.Label ("L", 59));
                                            (Ir.Exp
                                               (Ir.Call (
                                                  (Ir.Name ("null_ref", 60)),
                                                  [(Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16))))
                                                    ]
                                                  )));
                                            (Ir.Label ("L", 58))]),
                                       (Ir.Mem
                                          (Ir.BinOp (Ir.Plus,
                                             (Ir.Temp ("FP", 0)), (Ir.Const 16)
                                             )))
                                       ))
                                    )))
                              )),
                           (Ir.BinOp (Ir.Mul, (Ir.Const 0), (Ir.Const 4))))))
                     )),
                  (Ir.Const 2323)));
               (Ir.Move (
                  (Ir.Eseq (
                     (Ir.Seq
                        [(Ir.CJump (Ir.GE, (Ir.Const 2), (Ir.Const 0),
                            ("L", 75), ("L", 74)));
                          (Ir.Label ("L", 75));
                          (Ir.CJump (Ir.LT, (Ir.Const 2),
                             (Ir.Mem
                                (Ir.Eseq (
                                   (Ir.Seq
                                      [(Ir.CJump (Ir.EQ,
                                          (Ir.Mem
                                             (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                                (Ir.Eseq (
                                                   (Ir.Seq
                                                      [(Ir.CJump (Ir.EQ,
                                                          (Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 16)))),
                                                          (Ir.Const 0),
                                                          ("L", 68), ("L", 67)
                                                          ));
                                                        (Ir.Label ("L", 68));
                                                        (Ir.Exp
                                                           (Ir.Call (
                                                              (Ir.Name
                                                                 ("null_ref",
                                                                  69)),
                                                              [(Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      16)
                                                                     )))
                                                                ]
                                                              )));
                                                        (Ir.Label ("L", 67))]),
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16))))
                                                   ))
                                                ))),
                                          (Ir.Const 0), ("L", 71), ("L", 70)));
                                        (Ir.Label ("L", 71));
                                        (Ir.Exp
                                           (Ir.Call (
                                              (Ir.Name ("null_ref", 72)),
                                              [(Ir.Mem
                                                  (Ir.BinOp (Ir.Plus,
                                                     (Ir.Const 4),
                                                     (Ir.Eseq (
                                                        (Ir.Seq
                                                           [(Ir.CJump (Ir.EQ,
                                                               (Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      16)
                                                                     ))),
                                                               (Ir.Const 0),
                                                               ("L", 68),
                                                               ("L", 67)));
                                                             (Ir.Label
                                                                ("L", 68));
                                                             (Ir.Exp
                                                                (Ir.Call (
                                                                   (Ir.Name
                                                                      (
                                                                      "null_ref",
                                                                      69)),
                                                                   [(Ir.Mem
                                                                      (Ir.BinOp (
                                                                      Ir.Plus,
                                                                      (Ir.Temp
                                                                      ("FP", 0)),
                                                                      (Ir.Const
                                                                      16))))
                                                                     ]
                                                                   )));
                                                             (Ir.Label
                                                                ("L", 67))
                                                             ]),
                                                        (Ir.Mem
                                                           (Ir.BinOp (Ir.Plus,
                                                              (Ir.Temp
                                                                 ("FP", 0)),
                                                              (Ir.Const 16))))
                                                        ))
                                                     )))
                                                ]
                                              )));
                                        (Ir.Label ("L", 70))]),
                                   (Ir.Mem
                                      (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                         (Ir.Eseq (
                                            (Ir.Seq
                                               [(Ir.CJump (Ir.EQ,
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16)))),
                                                   (Ir.Const 0), ("L", 68),
                                                   ("L", 67)));
                                                 (Ir.Label ("L", 68));
                                                 (Ir.Exp
                                                    (Ir.Call (
                                                       (Ir.Name
                                                          ("null_ref", 69)),
                                                       [(Ir.Mem
                                                           (Ir.BinOp (Ir.Plus,
                                                              (Ir.Temp
                                                                 ("FP", 0)),
                                                              (Ir.Const 16))))
                                                         ]
                                                       )));
                                                 (Ir.Label ("L", 67))]),
                                            (Ir.Mem
                                               (Ir.BinOp (Ir.Plus,
                                                  (Ir.Temp ("FP", 0)),
                                                  (Ir.Const 16))))
                                            ))
                                         )))
                                   ))),
                             ("L", 73), ("L", 74)));
                          (Ir.Label ("L", 74));
                          (Ir.Exp (Ir.Call ((Ir.Name ("out_of_bound", 2)), [])));
                          (Ir.Label ("L", 73))]),
                     (Ir.Mem
                        (Ir.BinOp (Ir.Plus,
                           (Ir.Eseq (
                              (Ir.Seq
                                 [(Ir.CJump (Ir.EQ,
                                     (Ir.Mem
                                        (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                           (Ir.Eseq (
                                              (Ir.Seq
                                                 [(Ir.CJump (Ir.EQ,
                                                     (Ir.Mem
                                                        (Ir.BinOp (Ir.Plus,
                                                           (Ir.Temp ("FP", 0)),
                                                           (Ir.Const 16)))),
                                                     (Ir.Const 0), ("L", 68),
                                                     ("L", 67)));
                                                   (Ir.Label ("L", 68));
                                                   (Ir.Exp
                                                      (Ir.Call (
                                                         (Ir.Name
                                                            ("null_ref", 69)),
                                                         [(Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 16))))
                                                           ]
                                                         )));
                                                   (Ir.Label ("L", 67))]),
                                              (Ir.Mem
                                                 (Ir.BinOp (Ir.Plus,
                                                    (Ir.Temp ("FP", 0)),
                                                    (Ir.Const 16))))
                                              ))
                                           ))),
                                     (Ir.Const 0), ("L", 71), ("L", 70)));
                                   (Ir.Label ("L", 71));
                                   (Ir.Exp
                                      (Ir.Call ((Ir.Name ("null_ref", 72)),
                                         [(Ir.Mem
                                             (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                                (Ir.Eseq (
                                                   (Ir.Seq
                                                      [(Ir.CJump (Ir.EQ,
                                                          (Ir.Mem
                                                             (Ir.BinOp (
                                                                Ir.Plus,
                                                                (Ir.Temp
                                                                   ("FP", 0)),
                                                                (Ir.Const 16)))),
                                                          (Ir.Const 0),
                                                          ("L", 68), ("L", 67)
                                                          ));
                                                        (Ir.Label ("L", 68));
                                                        (Ir.Exp
                                                           (Ir.Call (
                                                              (Ir.Name
                                                                 ("null_ref",
                                                                  69)),
                                                              [(Ir.Mem
                                                                  (Ir.BinOp (
                                                                     Ir.Plus,
                                                                     (Ir.Temp
                                                                      ("FP", 0)),
                                                                     (Ir.Const
                                                                      16)
                                                                     )))
                                                                ]
                                                              )));
                                                        (Ir.Label ("L", 67))]),
                                                   (Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16))))
                                                   ))
                                                )))
                                           ]
                                         )));
                                   (Ir.Label ("L", 70))]),
                              (Ir.Mem
                                 (Ir.BinOp (Ir.Plus, (Ir.Const 4),
                                    (Ir.Eseq (
                                       (Ir.Seq
                                          [(Ir.CJump (Ir.EQ,
                                              (Ir.Mem
                                                 (Ir.BinOp (Ir.Plus,
                                                    (Ir.Temp ("FP", 0)),
                                                    (Ir.Const 16)))),
                                              (Ir.Const 0), ("L", 68),
                                              ("L", 67)));
                                            (Ir.Label ("L", 68));
                                            (Ir.Exp
                                               (Ir.Call (
                                                  (Ir.Name ("null_ref", 69)),
                                                  [(Ir.Mem
                                                      (Ir.BinOp (Ir.Plus,
                                                         (Ir.Temp ("FP", 0)),
                                                         (Ir.Const 16))))
                                                    ]
                                                  )));
                                            (Ir.Label ("L", 67))]),
                                       (Ir.Mem
                                          (Ir.BinOp (Ir.Plus,
                                             (Ir.Temp ("FP", 0)), (Ir.Const 16)
                                             )))
                                       ))
                                    )))
                              )),
                           (Ir.BinOp (Ir.Mul, (Ir.Const 2), (Ir.Const 4))))))
                     )),
                  (Ir.Const 2323)))
               ])
          ]))
