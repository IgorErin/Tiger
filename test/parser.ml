let create_test input =
  Tiger.Parser.of_string input |> Tiger.Parser.parse |> function
  | Base.Either.First result -> Tiger.Ast.show_exp result |> print_string
  | Base.Either.Second m -> failwith m

let%expect_test _ =
  create_test "nil";
  [%expect {| Ast.NilExp |}]
