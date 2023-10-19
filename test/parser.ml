let create_test input =
  Tiger.Parser.of_string input |> Tiger.Parser.parse |> function
  | Base.Either.First result -> Tiger.Ast.show_exp result |> print_string
  | Base.Either.Second m -> failwith m

let%expect_test _ =
  create_test "nil";
  [%expect {| Ast.NilExp |}]

let%expect_test _ =
  create_test "var";
  [%expect {| (Ast.VarExp (Ast.SimpleVar (0, "var"))) |}]

let%expect_test _ =
  create_test "var. var ";
  [%expect
    {| (Ast.VarExp (Ast.FieldVar ((Ast.SimpleVar (0, "var")), (0, "var")))) |}]

let%expect_test _ =
  create_test "var. var .var";
  [%expect
    {|
    (Ast.VarExp
       (Ast.FieldVar ((Ast.FieldVar ((Ast.SimpleVar (0, "var")), (0, "var"))),
          (0, "var")))) |}]

let%expect_test _ =
  create_test "var[count]";
  [%expect
    {|
    (Ast.VarExp
       (Ast.SubscriptVar ((Ast.SimpleVar (0, "var")),
          (Ast.VarExp (Ast.SimpleVar (0, "count")))))) |}]

let%expect_test _ =
  create_test "var[count][index]";
  [%expect
    {|
    (Ast.VarExp
       (Ast.SubscriptVar (
          (Ast.SubscriptVar ((Ast.SimpleVar (0, "var")),
             (Ast.VarExp (Ast.SimpleVar (0, "count"))))),
          (Ast.VarExp (Ast.SimpleVar (0, "index")))))) |}]

let%expect_test _ =
  create_test "var.name[count].name";
  [%expect
    {|
    (Ast.VarExp
       (Ast.FieldVar (
          (Ast.SubscriptVar (
             (Ast.FieldVar ((Ast.SimpleVar (0, "var")), (0, "name"))),
             (Ast.VarExp (Ast.SimpleVar (0, "count"))))),
          (0, "name")))) |}]

let%expect_test _ =
  create_test "123";
  [%expect {| (Ast.IntExp 123) |}]

let%expect_test _ =
  create_test "0";
  [%expect {| (Ast.IntExp 0) |}]

let%expect_test _ =
  create_test "-123";
  [%expect {| (Ast.IntExp -123) |}]

let%expect_test _ =
  create_test "-000";
  [%expect {| (Ast.IntExp 0) |}]

let%expect_test _ =
  create_test {|" some string" |};
  [%expect {| (Ast.StringExp " some string") |}]

let%expect_test _ =
  create_test {| "some string. as [var]" |};
  [%expect {| (Ast.StringExp "some string. as [var]") |}]

let%expect_test _ =
  create_test {| (1; 1; 2; 0) |};
  [%expect
    {| (Ast.SeqExp [(Ast.IntExp 1); (Ast.IntExp 1); (Ast.IntExp 2); (Ast.IntExp 0)]) |}]

let%expect_test _ =
  create_test {| () |};
  [%expect {| (Ast.SeqExp []) |}]

let%expect_test _ =
  create_test {| (let var x := 1 in x end) |};
  [%expect
    {|
    (Ast.SeqExp
       [Ast.LetExp {
          decs =
          [Ast.VarDec {name = (0, "x"); escape = ref (true); typ = None;
             init = (Ast.IntExp 1)}
            ];
          body = (Ast.VarExp (Ast.SimpleVar (0, "x")))}
         ]) |}]

let%expect_test _ =
  create_test {| (1 + 1; 2 * 2; 3 / 4; 1 < 1; 3 <= 1) |};
  [%expect
    {|
    (Ast.SeqExp
       [Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp;
          right = (Ast.IntExp 1)};
         Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.TimesOp;
           right = (Ast.IntExp 2)};
         Ast.OpExp {left = (Ast.IntExp 3); oper = Ast.DivideOp;
           right = (Ast.IntExp 4)};
         Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.LtOp;
           right = (Ast.IntExp 1)};
         Ast.OpExp {left = (Ast.IntExp 3); oper = Ast.LeOp;
           right = (Ast.IntExp 1)}
         ]) |}]

let%expect_test _ =
  create_test {| (x:= 4 ) |};
  [%expect
    {| (Ast.SeqExp [Ast.AssignExp {var = (0, "x"); exp = (Ast.IntExp 4)}]) |}]

let%expect_test _ =
  create_test {| x := 2 |};
  [%expect {| Ast.AssignExp {var = (0, "x"); exp = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| x := 2 |};
  [%expect {| Ast.AssignExp {var = (0, "x"); exp = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| if x then y |};
  [%expect
    {|
    Ast.IfExp {test = (Ast.VarExp (Ast.SimpleVar (0, "x")));
      then' = (Ast.VarExp (Ast.SimpleVar (0, "y"))); else' = None} |}]

let%expect_test _ =
  create_test {| if x then y else z |};
  [%expect
    {|
    Ast.IfExp {test = (Ast.VarExp (Ast.SimpleVar (0, "x")));
      then' = (Ast.VarExp (Ast.SimpleVar (0, "y")));
      else' = (Some (Ast.VarExp (Ast.SimpleVar (0, "z"))))} |}]

let%expect_test _ =
  create_test {| if x = 4 then y |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "x"))); oper = Ast.EqOp;
        right = (Ast.IntExp 4)};
      then' = (Ast.VarExp (Ast.SimpleVar (0, "y"))); else' = None} |}]

let%expect_test _ =
  create_test {| if let var x := 5 in x = 0 end then y else z |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.LetExp {
        decs =
        [Ast.VarDec {name = (0, "x"); escape = ref (true); typ = None;
           init = (Ast.IntExp 5)}
          ];
        body =
        Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "x"))); oper = Ast.EqOp;
          right = (Ast.IntExp 0)}};
      then' = (Ast.VarExp (Ast.SimpleVar (0, "y")));
      else' = (Some (Ast.VarExp (Ast.SimpleVar (0, "z"))))} |}]

let%expect_test _ =
  create_test {| while x do ()|};
  [%expect
    {|
      Ast.WhileExp {test = (Ast.VarExp (Ast.SimpleVar (0, "x")));
        body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| while 1 = 4 do 4 |};
  [%expect
    {|
    Ast.WhileExp {
      test =
      Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.EqOp; right = (Ast.IntExp 4)};
      body = (Ast.IntExp 4)} |}]

let%expect_test _ =
  create_test {| while 4 = 5 do x := x + 1 |};
  [%expect
    {|
    Ast.WhileExp {
      test =
      Ast.OpExp {left = (Ast.IntExp 4); oper = Ast.EqOp; right = (Ast.IntExp 5)};
      body =
      Ast.AssignExp {var = (0, "x");
        exp =
        Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "x")));
          oper = Ast.PlusOp; right = (Ast.IntExp 1)}}} |}]

let%expect_test _ =
  create_test {| while (1; 1+ 2; 5 = 3) do (let var x := 4 in x = 1 end) |};
  [%expect
    {|
    Ast.WhileExp {
      test =
      (Ast.SeqExp
         [(Ast.IntExp 1);
           Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp;
             right = (Ast.IntExp 2)};
           Ast.OpExp {left = (Ast.IntExp 5); oper = Ast.EqOp;
             right = (Ast.IntExp 3)}
           ]);
      body =
      (Ast.SeqExp
         [Ast.LetExp {
            decs =
            [Ast.VarDec {name = (0, "x"); escape = ref (true); typ = None;
               init = (Ast.IntExp 4)}
              ];
            body =
            Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "x")));
              oper = Ast.EqOp; right = (Ast.IntExp 1)}}
           ])} |}]

let%expect_test _ =
  create_test {| for x := 1 to 5 do () |};
  [%expect
    {|
    Ast.ForExp {var = (0, "x"); escape = ref (true); lo = (Ast.IntExp 1);
      hi = (Ast.IntExp 5); body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| for x:= let var x:= 4 in x + 1 end to -1000 do () |};
  [%expect
    {|
    Ast.ForExp {var = (0, "x"); escape = ref (true);
      lo =
      Ast.LetExp {
        decs =
        [Ast.VarDec {name = (0, "x"); escape = ref (true); typ = None;
           init = (Ast.IntExp 4)}
          ];
        body =
        Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "x")));
          oper = Ast.PlusOp; right = (Ast.IntExp 1)}};
      hi = (Ast.IntExp -1000); body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| for x := () to () do () |};
  [%expect
    {|
    Ast.ForExp {var = (0, "x"); escape = ref (true); lo = (Ast.SeqExp []);
      hi = (Ast.SeqExp []); body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| break |};
  [%expect {| Ast.BreakExp |}]

let%expect_test _ =
  create_test {| while break do () |};
  [%expect {| Ast.WhileExp {test = Ast.BreakExp; body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| while 4 do break |};
  [%expect {| Ast.WhileExp {test = (Ast.IntExp 4); body = Ast.BreakExp} |}]

let%expect_test _ =
  create_test {| while 4 do (1 +1; break) |};
  [%expect
    {|
    Ast.WhileExp {test = (Ast.IntExp 4);
      body =
      (Ast.SeqExp
         [Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp;
            right = (Ast.IntExp 1)};
           Ast.BreakExp])} |}]

let%expect_test _ =
  create_test {| id[length] of 1 |};
  [%expect
    {|
    Ast.ArrayExp {typ = (0, "id");
      size = (Ast.VarExp (Ast.SimpleVar (0, "length"))); init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[1 + 1] of 1 |};
  [%expect
    {|
    Ast.ArrayExp {typ = (0, "id");
      size =
      Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp; right = (Ast.IntExp 1)};
      init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[()] of 1 |};
  [%expect
    {| Ast.ArrayExp {typ = (0, "id"); size = (Ast.SeqExp []); init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[while () do ()] of 1 |};
  [%expect
    {|
    Ast.ArrayExp {typ = (0, "id");
      size = Ast.WhileExp {test = (Ast.SeqExp []); body = (Ast.SeqExp [])};
      init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[id .id] of id |};
  [%expect
    {|
    Ast.ArrayExp {typ = (0, "id");
      size = (Ast.VarExp (Ast.FieldVar ((Ast.SimpleVar (0, "id")), (0, "id"))));
      init = (Ast.VarExp (Ast.SimpleVar (0, "id")))} |}]

let%expect_test _ =
  create_test {| let var x :int := 2 in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [Ast.VarDec {name = (0, "x"); escape = ref (true); typ = (Some (0, "int"));
         init = (Ast.IntExp 2)}
        ];
      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test
    {| let type x = { first: int, second: float, third: lol} in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [(Ast.TypeDec
          [{ Ast.tname = (0, "x");
             ty =
             (Ast.RecordTy
                [{ Ast.name = (0, "first"); escape = ref (true); typ = (0, "int")
                   };
                  { Ast.name = (0, "second"); escape = ref (true);
                    typ = (0, "float") };
                  { Ast.name = (0, "third"); escape = ref (true);
                    typ = (0, "lol") }
                  ])
             }
            ])
        ];
      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| let function x () = 6 in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [(Ast.FunctionDec
          [{ Ast.fname = (0, "x"); params = []; result = None;
             body = (Ast.IntExp 6) }
            ])
        ];
      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| let function f():int = g (2, 1 + 1, option, g()) in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [(Ast.FunctionDec
          [{ Ast.fname = (0, "f"); params = []; result = (Some (0, "int"));
             body =
             Ast.CallExp {func = (0, "g");
               args =
               [(Ast.IntExp 2);
                 Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp;
                   right = (Ast.IntExp 1)};
                 (Ast.VarExp (Ast.SimpleVar (0, "option")));
                 Ast.CallExp {func = (0, "g"); args = []}]}
             }
            ])
        ];
      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| let function f(first:int, second: float): int = 0 in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [(Ast.FunctionDec
          [{ Ast.fname = (0, "f");
             params =
             [{ Ast.name = (0, "first"); escape = ref (true); typ = (0, "int") };
               { Ast.name = (0, "second"); escape = ref (true);
                 typ = (0, "float") }
               ];
             result = (Some (0, "int")); body = (Ast.IntExp 0) }
            ])
        ];
      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test
    {| let function f(first: int, second: float): option = int in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [(Ast.FunctionDec
          [{ Ast.fname = (0, "f");
             params =
             [{ Ast.name = (0, "first"); escape = ref (true); typ = (0, "int") };
               { Ast.name = (0, "second"); escape = ref (true);
                 typ = (0, "float") }
               ];
             result = (Some (0, "option"));
             body = (Ast.VarExp (Ast.SimpleVar (0, "int"))) }
            ])
        ];
      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| 1 +1|};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp; right = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| 1 + 1 + 1 + 1 |};
  [%expect
    {|
    Ast.OpExp {
      left =
      Ast.OpExp {
        left =
        Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp;
          right = (Ast.IntExp 1)};
        oper = Ast.PlusOp; right = (Ast.IntExp 1)};
      oper = Ast.PlusOp; right = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| 2 * 2 |};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.TimesOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 * 2 * 2* 2|};
  [%expect
    {|
    Ast.OpExp {
      left =
      Ast.OpExp {
        left =
        Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.TimesOp;
          right = (Ast.IntExp 2)};
        oper = Ast.TimesOp; right = (Ast.IntExp 2)};
      oper = Ast.TimesOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 - 2- -2 -2  |};
  [%expect
    {|
    Ast.OpExp {
      left =
      Ast.OpExp {
        left =
        Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.MinusOp;
          right = (Ast.IntExp 2)};
        oper = Ast.MinusOp; right = (Ast.IntExp -2)};
      oper = Ast.MinusOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 / 2 / 2 / 2 |};
  [%expect
    {|
    Ast.OpExp {
      left =
      Ast.OpExp {
        left =
        Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.DivideOp;
          right = (Ast.IntExp 2)};
        oper = Ast.DivideOp; right = (Ast.IntExp 2)};
      oper = Ast.DivideOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 <> 2 |};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.NeqOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 > 2 |};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.GtOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 < 2 |};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.LtOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 >= 2 |};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.GeOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 >= 2 |};
  [%expect
    {| Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.GeOp; right = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| 2 & 2 |};
  [%expect
    {|
    Ast.IfExp {test = (Ast.IntExp 2); then' = (Ast.IntExp 2);
      else' = (Some (Ast.IntExp 0))} |}]

let%expect_test _ =
  create_test {| 2 | 2 |};
  [%expect
    {|
    Ast.IfExp {test = (Ast.IntExp 2); then' = (Ast.IntExp 1);
      else' = (Some (Ast.IntExp 2))} |}]

let%expect_test _ =
  create_test {| 2 & 2 & 2 & 2 |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.IfExp {
        test =
        Ast.IfExp {test = (Ast.IntExp 2); then' = (Ast.IntExp 2);
          else' = (Some (Ast.IntExp 0))};
        then' = (Ast.IntExp 2); else' = (Some (Ast.IntExp 0))};
      then' = (Ast.IntExp 2); else' = (Some (Ast.IntExp 0))} |}]

let%expect_test _ =
  create_test {| 2 | 2 | 2 |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.IfExp {test = (Ast.IntExp 2); then' = (Ast.IntExp 1);
        else' = (Some (Ast.IntExp 2))};
      then' = (Ast.IntExp 1); else' = (Some (Ast.IntExp 2))} |}]

let%expect_test _ =
  create_test {| 2 * 2 + 2 - 1 / 3 + 3 | 4 |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.OpExp {
        left =
        Ast.OpExp {
          left =
          Ast.OpExp {left = (Ast.IntExp 2); oper = Ast.TimesOp;
            right = (Ast.IntExp 2)};
          oper = Ast.PlusOp; right = (Ast.IntExp 2)};
        oper = Ast.MinusOp;
        right =
        Ast.OpExp {
          left =
          Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.DivideOp;
            right = (Ast.IntExp 3)};
          oper = Ast.PlusOp; right = (Ast.IntExp 3)}};
      then' = (Ast.IntExp 1); else' = (Some (Ast.IntExp 4))} |}]

let%expect_test _ =
  create_test {| f () |};
  [%expect {| Ast.CallExp {func = (0, "f"); args = []} |}]

let%expect_test _ =
  create_test {| f (g(), 4, var) |};
  [%expect
    {|
        Ast.CallExp {func = (0, "f");
          args =
          [Ast.CallExp {func = (0, "g"); args = []}; (Ast.IntExp 4);
            (Ast.VarExp (Ast.SimpleVar (0, "var")))]} |}]

let%expect_test _ =
  create_test {| let var x:int:= 4 in f() end |};
  [%expect
    {|
        Ast.LetExp {
          decs =
          [Ast.VarDec {name = (0, "x"); escape = ref (true); typ = (Some (0, "int"));
             init = (Ast.IntExp 4)}
            ];
          body = Ast.CallExp {func = (0, "f"); args = []}} |}]

let%expect_test _ =
  create_test {| let function f() = g() function g() = f () in () end |};
  [%expect
    {|
            Ast.LetExp {
              decs =
              [(Ast.FunctionDec
                  [{ Ast.fname = (0, "f"); params = []; result = None;
                     body = Ast.CallExp {func = (0, "g"); args = []} };
                    { Ast.fname = (0, "g"); params = []; result = None;
                      body = Ast.CallExp {func = (0, "f"); args = []} }
                    ])
                ];
              body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| let type t = l type l = g type g = s in () end  |};
  [%expect
    {|
            Ast.LetExp {
              decs =
              [(Ast.TypeDec
                  [{ Ast.tname = (0, "t"); ty = (Ast.NameTy (0, "l")) };
                    { Ast.tname = (0, "l"); ty = (Ast.NameTy (0, "g")) };
                    { Ast.tname = (0, "g"); ty = (Ast.NameTy (0, "s")) }])
                ];
              body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| let type s = t type x = y var x:t := 4 in () end |};
  [%expect
    {|
                Ast.LetExp {
                  decs =
                  [(Ast.TypeDec
                      [{ Ast.tname = (0, "s"); ty = (Ast.NameTy (0, "t")) };
                        { Ast.tname = (0, "x"); ty = (Ast.NameTy (0, "y")) }]);
                    Ast.VarDec {name = (0, "x"); escape = ref (true); typ = (Some (0, "t"));
                      init = (Ast.IntExp 4)}
                    ];
                  body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test
    {| let type s = int type x = y type lol = kek var x: int := 4 function lol() = kek() function s(int:int, some:none, lol:kek) = () in () end|};
  [%expect
    {|
                    Ast.LetExp {
                      decs =
                      [(Ast.TypeDec
                          [{ Ast.tname = (0, "s"); ty = (Ast.NameTy (0, "int")) };
                            { Ast.tname = (0, "x"); ty = (Ast.NameTy (0, "y")) };
                            { Ast.tname = (0, "lol"); ty = (Ast.NameTy (0, "kek")) }]);
                        Ast.VarDec {name = (0, "x"); escape = ref (true);
                          typ = (Some (0, "int")); init = (Ast.IntExp 4)};
                        (Ast.FunctionDec
                           [{ Ast.fname = (0, "lol"); params = []; result = None;
                              body = Ast.CallExp {func = (0, "kek"); args = []} };
                             { Ast.fname = (0, "s");
                               params =
                               [{ Ast.name = (0, "int"); escape = ref (true); typ = (0, "int") };
                                 { Ast.name = (0, "some"); escape = ref (true); typ = (0, "none")
                                   };
                                 { Ast.name = (0, "lol"); escape = ref (true); typ = (0, "kek") }
                                 ];
                               result = None; body = (Ast.SeqExp []) }
                             ])
                        ];
                      body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test
    {| let function f(a:int, b: int, c: int) = 
    (print_int(a + c);
    let var j := a + b
        var a := "hello"
    in (print(a); print_int(j))
  end;
  print_int(b)) in () end |};
  [%expect
    {|
                  Ast.LetExp {
                    decs =
                    [(Ast.FunctionDec
                        [{ Ast.fname = (0, "f");
                           params =
                           [{ Ast.name = (0, "a"); escape = ref (true); typ = (0, "int") };
                             { Ast.name = (0, "b"); escape = ref (true); typ = (0, "int") };
                             { Ast.name = (0, "c"); escape = ref (true); typ = (0, "int") }];
                           result = None;
                           body =
                           (Ast.SeqExp
                              [Ast.CallExp {func = (0, "print_int");
                                 args =
                                 [Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "a")));
                                    oper = Ast.PlusOp;
                                    right = (Ast.VarExp (Ast.SimpleVar (0, "c")))}
                                   ]};
                                Ast.LetExp {
                                  decs =
                                  [Ast.VarDec {name = (0, "j"); escape = ref (true);
                                     typ = None;
                                     init =
                                     Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar (0, "a")));
                                       oper = Ast.PlusOp;
                                       right = (Ast.VarExp (Ast.SimpleVar (0, "b")))}};
                                    Ast.VarDec {name = (0, "a"); escape = ref (true);
                                      typ = None; init = (Ast.StringExp "hello")}
                                    ];
                                  body =
                                  (Ast.SeqExp
                                     [Ast.CallExp {func = (0, "print");
                                        args = [(Ast.VarExp (Ast.SimpleVar (0, "a")))]};
                                       Ast.CallExp {func = (0, "print_int");
                                         args = [(Ast.VarExp (Ast.SimpleVar (0, "j")))]}
                                       ])};
                                Ast.CallExp {func = (0, "print_int");
                                  args = [(Ast.VarExp (Ast.SimpleVar (0, "b")))]}
                                ])
                           }
                          ])
                      ];
                    body = (Ast.SeqExp [])} |}]
