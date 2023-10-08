open Base

let testable_exp = 
  Alcotest.testable Tiger.Ast.pp_exp Tiger.Ast.equal_exp

let create_test name input expected =
  let open Tiger.Parser in 
  of_string input
  |> parse
  |> function 
    | Either.First actual ->
      Alcotest.(check testable_exp) name actual expected
    | Either.Second m -> failwith m  (* TODO() formatting / remove failwiht *)


let nil_test () = create_test "nil" "nil" NilExp 

let run () =
  let open Alcotest in
  run "Utils" [
      "nil", [
          test_case "Lower case" `Quick nil_test;
        ];
    ]