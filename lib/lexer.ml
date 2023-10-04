open Angstrom
open Ast
open! Base
open Stdio

let ws =
  skip_while (function '\x20' | '\x0a' | '\x0d' | '\x09' -> true | _ -> false)

let squareBracketsOpen = ws *> char '['
let squareBracketsClose = ws *> char ']'
let point = ws *> char '.'

let id =
  ws *> take_while (function 'a' .. 'z' -> true | _ -> false) >>| Id.of_string

let todo = ws
let expr = ws >>| fun () -> NilExp

(* Var *)
let expr = char ' ' >>| fun _ -> NilExp
let simpleVar = id >>| fun x -> SimpleVar x
let pointId = point *> id
let subscriptExp = squareBracketsOpen *> expr <* squareBracketsClose

let var =
  let simpleVar = id >>| fun x -> SimpleVar x in
  (* . id -> id *)
  let pointId = point *> id in
  (* [exp] -> exp *)
  let subscriptExp = squareBracketsOpen *> expr <* squareBracketsClose in
  (* var . id -> fieldVar *)
  let pointId_cont var = pointId >>| fun right_id -> FieldVar (var, right_id) in
  (* var [exp] -> subscriptVar *)
  let subscript_cont var =
    subscriptExp >>| fun expr -> SubscriptVar (var, expr)
  in
  (* var (. id | [exp])* *)
  let rec var' var =
    pointId_cont var <|> subscript_cont var >>= var' <|> return var
  in
  simpleVar >>= var'

let parse p str =
  parse_string ~consume:All p str |> function
  | Ok value -> value
  | Error _ -> failwith "Error"

let%expect_test _ =
  print_endline (show_var (parse var "  name"));
  [%expect {| (Ast.SimpleVar "name") |}]

let%expect_test _ =
  print_endline (show_var (parse var "  name . name"));
  [%expect {| (Ast.FieldVar ((Ast.SimpleVar "name"), "name")) |}]

let%expect_test _ =
  print_endline (show_var (parse var "  name . name. name  .name"));
  [%expect
    {|
    (Ast.FieldVar (
       (Ast.FieldVar ((Ast.FieldVar ((Ast.SimpleVar "name"), "name")), "name")),
       "name")) |}]

let%expect_test _ =
  print_endline (show_var (parse var "  name [ ].name [ ] [ ] . name [ ]"));
  [%expect
    {|
    (Ast.SubscriptVar (
       (Ast.FieldVar (
          (Ast.SubscriptVar (
             (Ast.SubscriptVar (
                (Ast.FieldVar (
                   (Ast.SubscriptVar ((Ast.SimpleVar "name"), Ast.NilExp)),
                   "name")),
                Ast.NilExp)),
             Ast.NilExp)),
          "name")),
       Ast.NilExp)) |}]

let rec par p = ws *> char '(' *> ws *> par p <* ws <* char ')' <|> p

let exp =
  fix (fun exp ->
      let var_exp = var >>| fun v -> VarExp v in

      let nil_exp = ws *> string "nil" *> return NilExp in

      let number_exp =
        let unsign_number = take_while1 Char.is_digit >>| Int.of_string in
        let sign_number = char '-' *> ws *> unsign_number >>| Int.neg in
        ws *> (sign_number <|> unsign_number) >>| fun x -> IntExp x
      in

      let string_exp =
        let leftq = ws *> char '"' in
        let text = take_while (function '"' -> false | _ -> true) in
        let rightq = char '"' in
        leftq *> text <* rightq >>| fun result -> StringExp result
      in

      let seq =
        let obr = ws *> char '(' in
        let s = ws *> char ',' <* ws in
        let exps = sep_by s exp in
        let cbr = ws *> char ')' in
        obr *> exps <* cbr
      in
      let seq_exp = seq >>| fun result -> SeqExp result in
      let fcall_exp =
        let id = ws *> id in
        let seq = seq in
        both id seq >>| fun (i, s) -> CallExp { func = i; args = s }
      in

      let assign_exp =
        let id = ws *> id in
        let exp = ws *> string ":=" *> exp in
        id >>= fun id ->
        exp >>| fun exp -> AssignExp { var = id; exp }
      in

      let if_exp =
        let _if = ws *> string "if" *> ws *> exp in
        let _then = ws *> string "then" *> ws *> exp in
        let if_then_exp_cont _else =
          _if >>= fun test_exp ->
          _then >>= fun then_exp ->
          _else >>| fun else_exp ->
          IfExp { test = test_exp; then' = then_exp; else' = else_exp }
        in
        let _else = ws *> string "else" *> ws *> exp >>| Option.some in
        let option_else = _else <|> return None in
        if_then_exp_cont option_else
      in

      let while_exp =
        let cond_exp = ws *> string "while" *> ws *> exp in
        let do_exp = ws *> string "do" *> exp in
        cond_exp >>= fun test ->
        do_exp >>| fun do_exp -> WhileExp { test; body = do_exp }
      in

      let for_exp =
        let for_id = ws *> string "for" *> ws *> id in
        let lb_exp = ws *> string ":=" *> ws *> exp in
        let ub_exp = ws *> string "to" *> ws *> exp in
        let do_exp = ws *> string "do" *> ws *> exp in
        for_id >>= fun for_id ->
        lb_exp >>= fun lb_exp ->
        ub_exp >>= fun ub_exp ->
        do_exp >>| fun do_exp ->
        ForExp
          {
            var = for_id;
            escape = ref true;
            lo = lb_exp;
            hi = ub_exp;
            body = do_exp;
          }
      in

      let break_exp = ws *> string "break" >>| fun _ -> BreakExp in

      (* let let_exp =
           let let_dec_list = ws *> string "let" *> ws *> return [] in
           (* TODO() *)
           let in_exp = ws *> string "in" *> exp () in
           let _end = ws *> string "end" in
           let_dec_list >>| fun dec_list ->
           in_exp >>| fun in_exp ->
           _end >>| fun _ -> LetExp { decs = dec_list; body = in_exp }
         in *)

      (* let array_exp =
           let type_id = ws *> id in
           let size_exp = ws *> char '[' *> exp () <* ws <* char ']' in
           let init_exp = ws *> string "of" *> ws *> exp () in

           type_id >>| fun type_id ->
           size_exp >>| fun size_exp ->
           init_exp >>| fun init_exp ->
           ArrayExp { typ = type_id; size = size_exp; init = init_exp }
         in *)
      choice
        [
          break_exp;
          for_exp;
          while_exp;
          if_exp;
          fcall_exp;
          seq_exp;
          assign_exp;
          string_exp;
          number_exp;
          nil_exp;
          var_exp;
        ])

let%expect_test _ =
  print_endline (show_exp (parse exp "var"));
  [%expect {| (Ast.VarExp (Ast.SimpleVar "var")) |}]

let%expect_test _ =
  print_endline (show_exp (parse exp "   var"));
  [%expect {| (Ast.VarExp (Ast.SimpleVar "var")) |}]

let%expect_test _ =
  print_endline (show_exp (parse exp "  nil"));
  [%expect {| Ast.NilExp |}]

let%expect_test _ =
  print_endline (show_exp (parse exp "  123"));
  [%expect {| (Ast.IntExp 123) |}]

let%expect_test _ =
  print_endline (show_exp (parse exp "  -123"));
  [%expect {| (Ast.IntExp -123) |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| "lol"|}));
  [%expect {| (Ast.StringExp "lol") |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| ""|}));
  [%expect {| (Ast.StringExp "") |}]

let%expect_test _ =
  print_endline (show_exp (parse exp "   lol   := 4"));
  [%expect {| Ast.AssignExp {var = "lol"; exp = (Ast.IntExp 4)} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| (lol, x := 5, 134  , "lol"  )|}));
  [%expect
    {|
        Ast.CallExp {func = "";
          args =
          [(Ast.VarExp (Ast.SimpleVar "lol"));
            Ast.AssignExp {var = "x"; exp = (Ast.IntExp 5)}; (Ast.IntExp 134);
            (Ast.StringExp "lol")]} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {|lol ( 3, "lol"   , x  := 3, nil  )|}));
  [%expect
    {|
      Ast.CallExp {func = "lol";
        args =
        [(Ast.IntExp 3); (Ast.StringExp "lol");
          Ast.AssignExp {var = "x"; exp = (Ast.IntExp 3)}; Ast.NilExp]} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| if 4 then nil else 4|}));
  [%expect
    {|
      Ast.IfExp {test = (Ast.IntExp 4); then' = Ast.NilExp;
        else' = (Some (Ast.IntExp 4))} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| if 4 then nil|}));
  [%expect
    {|
      Ast.IfExp {test = (Ast.IntExp 4); then' = Ast.NilExp; else' = None} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| while lol do 4|}));
  [%expect
    {|
    Ast.WhileExp {test = (Ast.VarExp (Ast.SimpleVar "lol"));
      body = (Ast.IntExp 4)} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| for i := 4 to 5 do 6|}));
  [%expect
    {|
    Ast.ForExp {var = "i"; escape = ref (true); lo = (Ast.IntExp 4);
      hi = (Ast.IntExp 5); body = (Ast.IntExp 6)} |}]

let%expect_test _ =
  print_endline (show_exp (parse exp {| while 4 do break|}));
  [%expect
    {|
      Ast.WhileExp {test = (Ast.IntExp 4); body = Ast.BreakExp} |}]
