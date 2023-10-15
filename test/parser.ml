let create_test input =
  Tiger.Parser.of_string input |> Tiger.Parser.parse |> function
  | Base.Either.First result -> Tiger.Ast.show_exp result |> print_string
  | Base.Either.Second m -> failwith m

let%expect_test _ =
  create_test "nil";
  [%expect {| Ast.NilExp |}]

let%expect_test _ =
  create_test "var";
  [%expect {| (Ast.VarExp (Ast.SimpleVar "var")) |}]

let%expect_test _ =
  create_test "var. var ";
  [%expect {| (Ast.VarExp (Ast.FieldVar ((Ast.SimpleVar "var"), "var"))) |}]

let%expect_test _ =
  create_test "var. var .var";
  [%expect
    {|
    (Ast.VarExp
       (Ast.FieldVar ((Ast.FieldVar ((Ast.SimpleVar "var"), "var")), "var"))) |}]

let%expect_test _ =
  create_test "var[count]";
  [%expect
    {|
    (Ast.VarExp
       (Ast.SubscriptVar ((Ast.SimpleVar "var"),
          (Ast.VarExp (Ast.SimpleVar "count"))))) |}]

let%expect_test _ =
  create_test "var[count][index]";
  [%expect
    {|
    (Ast.VarExp
       (Ast.SubscriptVar (
          (Ast.SubscriptVar ((Ast.SimpleVar "var"),
             (Ast.VarExp (Ast.SimpleVar "count")))),
          (Ast.VarExp (Ast.SimpleVar "index"))))) |}]

let%expect_test _ =
  create_test "var.name[count].name";
  [%expect
    {|
    (Ast.VarExp
       (Ast.FieldVar (
          (Ast.SubscriptVar ((Ast.FieldVar ((Ast.SimpleVar "var"), "name")),
             (Ast.VarExp (Ast.SimpleVar "count")))),
          "name"))) |}]

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
          [Ast.VarDec {name = "x"; escape = ref (true); typ = None;
             init = (Ast.IntExp 1)}
            ];
          body = (Ast.VarExp (Ast.SimpleVar "x"))}
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
  [%expect {| (Ast.SeqExp [Ast.AssignExp {var = "x"; exp = (Ast.IntExp 4)}]) |}]

let%expect_test _ =
  create_test {| x := 2 |};
  [%expect {| Ast.AssignExp {var = "x"; exp = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| x := 2 |};
  [%expect {| Ast.AssignExp {var = "x"; exp = (Ast.IntExp 2)} |}]

let%expect_test _ =
  create_test {| if x then y |};
  [%expect
    {|
    Ast.IfExp {test = (Ast.VarExp (Ast.SimpleVar "x"));
      then' = (Ast.VarExp (Ast.SimpleVar "y")); else' = None} |}]

let%expect_test _ =
  create_test {| if x then y else z |};
  [%expect
    {|
    Ast.IfExp {test = (Ast.VarExp (Ast.SimpleVar "x"));
      then' = (Ast.VarExp (Ast.SimpleVar "y"));
      else' = (Some (Ast.VarExp (Ast.SimpleVar "z")))} |}]

let%expect_test _ =
  create_test {| if x = 4 then y |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "x")); oper = Ast.EqOp;
        right = (Ast.IntExp 4)};
      then' = (Ast.VarExp (Ast.SimpleVar "y")); else' = None} |}]

let%expect_test _ =
  create_test {| if let var x := 5 in x = 0 end then y else z |};
  [%expect
    {|
    Ast.IfExp {
      test =
      Ast.LetExp {
        decs =
        [Ast.VarDec {name = "x"; escape = ref (true); typ = None;
           init = (Ast.IntExp 5)}
          ];
        body =
        Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "x")); oper = Ast.EqOp;
          right = (Ast.IntExp 0)}};
      then' = (Ast.VarExp (Ast.SimpleVar "y"));
      else' = (Some (Ast.VarExp (Ast.SimpleVar "z")))} |}]

let%expect_test _ =
  create_test {| while x do ()|};
  [%expect
    {| Ast.WhileExp {test = (Ast.VarExp (Ast.SimpleVar "x")); body = (Ast.SeqExp [])} |}]

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
      Ast.AssignExp {var = "x";
        exp =
        Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "x")); oper = Ast.PlusOp;
          right = (Ast.IntExp 1)}}} |}]

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
            [Ast.VarDec {name = "x"; escape = ref (true); typ = None;
               init = (Ast.IntExp 4)}
              ];
            body =
            Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "x")); oper = Ast.EqOp;
              right = (Ast.IntExp 1)}}
           ])} |}]

let%expect_test _ =
  create_test {| for x := 1 to 5 do () |};
  [%expect
    {|
    Ast.ForExp {var = "x"; escape = ref (true); lo = (Ast.IntExp 1);
      hi = (Ast.IntExp 5); body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| for x:= let var x:= 4 in x + 1 end to -1000 do () |};
  [%expect
    {|
    Ast.ForExp {var = "x"; escape = ref (true);
      lo =
      Ast.LetExp {
        decs =
        [Ast.VarDec {name = "x"; escape = ref (true); typ = None;
           init = (Ast.IntExp 4)}
          ];
        body =
        Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "x")); oper = Ast.PlusOp;
          right = (Ast.IntExp 1)}};
      hi = (Ast.IntExp -1000); body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| for x := () to () do () |};
  [%expect
    {|
    Ast.ForExp {var = "x"; escape = ref (true); lo = (Ast.SeqExp []);
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
    Ast.ArrayExp {typ = "id"; size = (Ast.VarExp (Ast.SimpleVar "length"));
      init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[1 + 1] of 1 |};
  [%expect
    {|
    Ast.ArrayExp {typ = "id";
      size =
      Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp; right = (Ast.IntExp 1)};
      init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[()] of 1 |};
  [%expect
    {| Ast.ArrayExp {typ = "id"; size = (Ast.SeqExp []); init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[while () do ()] of 1 |};
  [%expect
    {|
    Ast.ArrayExp {typ = "id";
      size = Ast.WhileExp {test = (Ast.SeqExp []); body = (Ast.SeqExp [])};
      init = (Ast.IntExp 1)} |}]

let%expect_test _ =
  create_test {| id[id .id] of id |};
  [%expect
    {|
    Ast.ArrayExp {typ = "id";
      size = (Ast.VarExp (Ast.FieldVar ((Ast.SimpleVar "id"), "id")));
      init = (Ast.VarExp (Ast.SimpleVar "id"))} |}]

let%expect_test _ =
  create_test {| let var x :int := 2 in () end |};
  [%expect
    {|
    Ast.LetExp {
      decs =
      [Ast.VarDec {name = "x"; escape = ref (true); typ = (Some "int");
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
          [{ Ast.tname = "x";
             ty =
             (Ast.RecordTy
                [{ Ast.name = "first"; escape = ref (true); typ = "int" };
                  { Ast.name = "second"; escape = ref (true); typ = "float" };
                  { Ast.name = "third"; escape = ref (true); typ = "lol" }])
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
          [{ Ast.fname = "x"; params = []; result = None; body = (Ast.IntExp 6) }
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
          [{ Ast.fname = "f"; params = []; result = (Some "int");
             body =
             Ast.CallExp {func = "g";
               args =
               [(Ast.IntExp 2);
                 Ast.OpExp {left = (Ast.IntExp 1); oper = Ast.PlusOp;
                   right = (Ast.IntExp 1)};
                 (Ast.VarExp (Ast.SimpleVar "option"));
                 Ast.CallExp {func = "g"; args = []}]}
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
          [{ Ast.fname = "f";
             params =
             [{ Ast.name = "first"; escape = ref (true); typ = "int" };
               { Ast.name = "second"; escape = ref (true); typ = "float" }];
             result = (Some "int"); body = (Ast.IntExp 0) }
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
          [{ Ast.fname = "f";
             params =
             [{ Ast.name = "first"; escape = ref (true); typ = "int" };
               { Ast.name = "second"; escape = ref (true); typ = "float" }];
             result = (Some "option"); body = (Ast.VarExp (Ast.SimpleVar "int"))
             }
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
  [%expect {| Ast.CallExp {func = "f"; args = []} |}]

let%expect_test _ =
  create_test {| f (g(), 4, var) |};
  [%expect
    {|
        Ast.CallExp {func = "f";
          args =
          [Ast.CallExp {func = "g"; args = []}; (Ast.IntExp 4);
            (Ast.VarExp (Ast.SimpleVar "var"))]} |}]

let%expect_test _ =
  create_test {| let var x:int:= 4 in f() end |};
  [%expect
    {|
        Ast.LetExp {
          decs =
          [Ast.VarDec {name = "x"; escape = ref (true); typ = (Some "int");
             init = (Ast.IntExp 4)}
            ];
          body = Ast.CallExp {func = "f"; args = []}} |}]

let%expect_test _ =
  create_test {| let function f() = g() function g() = f () in () end |};
  [%expect
    {|
            Ast.LetExp {
              decs =
              [(Ast.FunctionDec
                  [{ Ast.fname = "f"; params = []; result = None;
                     body = Ast.CallExp {func = "g"; args = []} };
                    { Ast.fname = "g"; params = []; result = None;
                      body = Ast.CallExp {func = "f"; args = []} }
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
                  [{ Ast.tname = "t"; ty = (Ast.NameTy "l") };
                    { Ast.tname = "l"; ty = (Ast.NameTy "g") };
                    { Ast.tname = "g"; ty = (Ast.NameTy "s") }])
                ];
              body = (Ast.SeqExp [])} |}]

let%expect_test _ =
  create_test {| let type s = t type x = y var x:t := 4 in () end |};
  [%expect
    {|
                Ast.LetExp {
                  decs =
                  [(Ast.TypeDec
                      [{ Ast.tname = "s"; ty = (Ast.NameTy "t") };
                        { Ast.tname = "x"; ty = (Ast.NameTy "y") }]);
                    Ast.VarDec {name = "x"; escape = ref (true); typ = (Some "t");
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
                          [{ Ast.tname = "s"; ty = (Ast.NameTy "int") };
                            { Ast.tname = "x"; ty = (Ast.NameTy "y") };
                            { Ast.tname = "lol"; ty = (Ast.NameTy "kek") }]);
                        Ast.VarDec {name = "x"; escape = ref (true); typ = (Some "int");
                          init = (Ast.IntExp 4)};
                        (Ast.FunctionDec
                           [{ Ast.fname = "lol"; params = []; result = None;
                              body = Ast.CallExp {func = "kek"; args = []} };
                             { Ast.fname = "s";
                               params =
                               [{ Ast.name = "int"; escape = ref (true); typ = "int" };
                                 { Ast.name = "some"; escape = ref (true); typ = "none" };
                                 { Ast.name = "lol"; escape = ref (true); typ = "kek" }];
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
                        [{ Ast.fname = "f";
                           params =
                           [{ Ast.name = "a"; escape = ref (true); typ = "int" };
                             { Ast.name = "b"; escape = ref (true); typ = "int" };
                             { Ast.name = "c"; escape = ref (true); typ = "int" }];
                           result = None;
                           body =
                           (Ast.SeqExp
                              [Ast.CallExp {func = "print_int";
                                 args =
                                 [Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "a"));
                                    oper = Ast.PlusOp; right = (Ast.VarExp (Ast.SimpleVar "c"))}
                                   ]};
                                Ast.LetExp {
                                  decs =
                                  [Ast.VarDec {name = "j"; escape = ref (true); typ = None;
                                     init =
                                     Ast.OpExp {left = (Ast.VarExp (Ast.SimpleVar "a"));
                                       oper = Ast.PlusOp;
                                       right = (Ast.VarExp (Ast.SimpleVar "b"))}};
                                    Ast.VarDec {name = "a"; escape = ref (true); typ = None;
                                      init = (Ast.StringExp "hello")}
                                    ];
                                  body =
                                  (Ast.SeqExp
                                     [Ast.CallExp {func = "print";
                                        args = [(Ast.VarExp (Ast.SimpleVar "a"))]};
                                       Ast.CallExp {func = "print_int";
                                         args = [(Ast.VarExp (Ast.SimpleVar "j"))]}
                                       ])};
                                Ast.CallExp {func = "print_int";
                                  args = [(Ast.VarExp (Ast.SimpleVar "b"))]}
                                ])
                           }
                          ])
                      ];
                    body = (Ast.SeqExp [])} |}]