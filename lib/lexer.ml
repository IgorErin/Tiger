open Angstrom
open Ast
open! Base
open Stdio

let ws =
  skip_while (function '\x20' | '\x0a' | '\x0d' | '\x09' -> true | _ -> false)

let point = ws *> char '.'

let id =
  ws
  *> take_while1 (function 'a' .. 'z' | 'A' .. 'Z' | '_' -> true | _ -> false)
  >>| Id.of_string

let parse p str =
  parse_string ~consume:All p str |> function
  | Ok value -> value
  | Error m -> failwith m

let escape_init () = ref true

let true' = IntExp 1 
let false' = IntExp 0

let exp =
  fix (fun exp ->
      let var =
        let simpleVar = id >>| fun x -> SimpleVar x in
        (* . id -> id *)
        let pointId = point *> id in
        (* [exp] -> exp *)
        let subscriptExp = ws *> char '[' *> exp <* ws *> char ']' in
        (* var . id -> fieldVar *)
        let pointId_cont var =
          pointId >>| fun right_id -> FieldVar (var, right_id)
        in
        (* var [exp] -> subscriptVar *)
        let subscript_cont var =
          subscriptExp >>| fun expr -> SubscriptVar (var, expr)
        in
        (* var (. id | [exp])* *)
        let rec var' var =
          pointId_cont var <|> subscript_cont var >>= var' <|> return var
        in
        simpleVar >>= var'
      in

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
            escape = escape_init ();
            lo = lb_exp;
            hi = ub_exp;
            body = do_exp;
          }
      in

      let break_exp = ws *> string "break" >>| fun _ -> BreakExp in

      let array_exp =
        let type_id = ws *> id in
        let size_exp = ws *> char '[' *> exp <* ws <* char ']' in
        let init_exp = ws *> string "of" *> ws *> exp in

        type_id >>= fun type_id ->
        size_exp >>= fun size_exp ->
        init_exp >>| fun init_exp ->
        ArrayExp { typ = type_id; size = size_exp; init = init_exp }
      in
      let ty_option =
        let some = Angstrom.map (ws *> char ':' *> id) ~f:Option.some in
        let none = return None in
        some <|> none
      in

      let vardec =
        let var_id = ws *> string "var" *> ws *> id in
        let var_exp = ws *> string ":=" *> ws *> exp in
        var_id >>= fun var_id ->
        ty_option >>= fun var_type ->
        var_exp >>| fun var_exp ->
        VarDec
          {
            name = var_id;
            escape = escape_init ();
            typ = var_type;
            init = var_exp;
          }
      in

      let tyfield =
        let field_id = ws *> id in
        let ty = ws *> char ':' *> ws *> id in
        both field_id ty >>| fun (id, ty) ->
        { name = id; escape = escape_init (); typ = ty }
      in

      let fields =
        let comma = ws *> char ',' <* ws in
        ws *> sep_by comma tyfield
      in

      let typedec =
        let type_id = ws *> string "type" *> id <* ws <* char '=' <* ws in
        let ty =
          let arrayOf =
            let p = ws *> string "array" *> ws *> string "of" *> ws *> id in
            p >>| fun result -> ArrayTy result
          in
          let ty_name = id >>| fun i -> NameTy i in
          let tyfields =
            ws *> char '{' *> fields <* ws <* char '}' >>| fun result ->
            RecordTy result
          in
          choice [ arrayOf; ty_name; tyfields ]
        in
        both type_id ty >>| fun (id, ty) -> { tname = id; ty }
      in

      let fundec =
        let fun_id = ws *> string "function" *> ws *> id in
        let fields = ws *> char '(' *> ws *> fields <* ws <* char ')' in
        let body = ws *> char '=' *> exp in
        fun_id >>= fun fun_id ->
        fields >>= fun fields ->
        ty_option >>= fun ty ->
        body >>| fun body ->
        { fname = fun_id; params = fields; result = ty; body }
      in

      let dec =
        let typedecs = sep_by1 ws typedec >>| fun x -> TypeDec x in
        let funcdecs = sep_by1 ws fundec >>| fun x -> FunctionDec x in
        let vardec =
          let var_id = ws *> string "var" *> id in
          let var_exp = ws *> string ":=" *> exp in
          var_id >>= fun var_id ->
          ty_option >>= fun ty ->
          var_exp >>| fun exp ->
          VarDec
            { name = var_id; escape = escape_init (); typ = ty; init = exp }
        in
        choice [ typedecs; funcdecs; vardec ]
      in

      let let_exp =
        let let_dec_list = ws *> string "let" *> ws *> sep_by1 ws dec in
        let in_exp = ws *> string "in" *> exp in
        let _end = ws *> string "end" in
        let_dec_list >>= fun dec_list ->
        in_exp >>= fun in_exp ->
        _end >>| fun _ -> LetExp { decs = dec_list; body = in_exp }
      in
      let unar_minus =
        ws *> char '-' *> exp >>| fun x ->
        OpExp { left = IntExp 0; oper = MinusOp; right = x }
      in

      let non_op =
        choice
          [
            let_exp;
            array_exp;
            break_exp;
            for_exp;
            while_exp;
            if_exp;
            fcall_exp;
            seq_exp;
            assign_exp;
            string_exp;
            number_exp; (* TODO(strange error: end_of_input while choice exist) *)
            nil_exp;
            var_exp; (* TODO(strange error: end_of_input while choice exist) *)
            unar_minus;
          ]
      in
      let bin_op_exp =
        (* create left associative bin op parser *)
        let create inner oper p =
          let cons left right = OpExp { left; oper; right } in
          p >>= fun init ->
          let fold ls = List.fold ls ~init ~f:cons in
          fold <$> many (inner *> p)
          (* inner *> p >>| cons init *)
        in
        let create_or left right = IfExp {test = left; then' = true' ; else' = Some right;} in
        let create_and left right = IfExp {test = left; then' = right; else' = Some false' } in 
        let create_logic inner create p = 
          p >>= fun init ->
          let fold ls = List.fold ls ~init ~f:create in
          fold <$> many (inner *> p)
          in
        let create_inner s = ws *> string s *> ws *> return () in
        create (create_inner "*") TimesOp non_op
        |> create (create_inner "/") DivideOp
        |> create (create_inner "+") PlusOp
        |> create (create_inner "-") MinusOp
        |> create (create_inner "=") EqOp
        |> create (create_inner "<>") NeqOp 
        |> create (create_inner ">") GtOp
        |> create (create_inner "<") LtOp   
        |> create (create_inner ">=") GeOp
        |> create (create_inner "<=") LeOp
        |> create_logic (create_inner "&") create_and
        |> create_logic (create_inner "|") create_or
      in
      
      bin_op_exp (*TODO(start with let_exp)*))

    