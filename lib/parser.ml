open Angstrom
open Parsetree

type t = string

let of_string x = x

let ws =
  skip_while (function
    | '\x20' | '\x0a' | '\x0d' | '\x09' -> true
    | _ -> false)
;;

let take_until signal = fix (fun self -> signal <|> take 1 *> self)

let comment =
  fix (fun self ->
    let start = string "/*" in
    let finish = string "*/" in
    start *> take_until (finish <|> self *> take_until finish))
;;

let ws = ws *> fix (fun self -> comment *> ws *> self <|> ws)

let id =
  let tl =
    take_while1
    @@ String.contains "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'_"
  in
  ws *> tl
  >>= fun id ->
  let hd = String.get id 0 in
  if not @@ Base.Char.is_digit hd then return @@ Symbol.symbol id else fail id
;;

let parse p str =
  parse_string ~consume:All p str
  |> function
  | Ok value -> value
  | Error m -> failwith m
;;

let escape_init () = ref true
let true_ = PIntExp 1
let false_ = PIntExp 0

let exp =
  fix (fun exp ->
    let var =
      let simpleVar = id >>| fun x -> PSimpleVar x in
      (* . id -> id *)
      let pointId = ws *> char '.' *> ws *> id in
      (* [exp] -> exp *)
      let subscriptExp = ws *> char '[' *> exp <* ws *> char ']' in
      (* var . id -> fieldVar *)
      let pointId_cont var = pointId >>| fun right_id -> PFieldVar (var, right_id) in
      (* var [exp] -> subscriptVar *)
      let subscript_cont var = subscriptExp >>| fun expr -> PSubscriptVar (var, expr) in
      (* var (. id | [exp])* *)
      let rec var' var =
        pointId_cont var <|> subscript_cont var >>= var' <|> return var
      in
      simpleVar >>= var'
    in
    let var_exp = var >>| fun v -> PVarExp v in
    let nil_exp = string "nil" *> return PNilExp in
    let number_exp =
      let open Base in
      let unsign_number = take_while1 Char.is_digit >>| Int.of_string in
      let sign_number = char '-' *> ws *> unsign_number >>| Int.neg in
      sign_number <|> unsign_number >>| fun x -> PIntExp x
    in
    let string_exp =
      let leftq = char '"' in
      let text =
        take_while (function
          | '"' -> false
          | _ -> true)
      in
      let rightq = char '"' in
      leftq *> text <* rightq >>| fun result -> PStringExp result
    in
    let seq s =
      let obr = char '(' in
      let s = ws *> char s <* ws in
      let exps = sep_by s exp in
      let cbr = ws *> char ')' in
      obr *> exps <* cbr
    in
    let seq_exp = seq ';' >>| fun result -> PSeqExp result in
    let fcall_exp =
      let id = id <* ws in
      let seq = seq in
      both id (seq ',') >>| fun (i, s) -> PCallExp { func = i; args = s }
    in
    let assign_exp =
      let var = var in
      let exp = ws *> string ":=" *> exp in
      var >>= fun var -> exp >>| fun exp -> PAssignExp { var; exp }
    in
    let if_exp =
      let if_ = string "if" *> ws *> exp in
      let then_ = ws *> string "then" *> ws *> exp in
      let if_then_exp_cont else_ =
        if_
        >>= fun test ->
        then_ >>= fun then_ -> else_ >>| fun else_ -> PIfExp { test; then_; else_ }
      in
      let _else = ws *> string "else" *> ws *> exp >>| Option.some in
      let option_else = _else <|> return None in
      if_then_exp_cont option_else
    in
    let while_exp =
      let cond_exp = string "while" *> ws *> exp in
      let do_exp = ws *> string "do" *> exp in
      cond_exp >>= fun test -> do_exp >>| fun do_exp -> PWhileExp { test; body = do_exp }
    in
    let for_exp =
      let for_id = string "for" *> ws *> id in
      let lb_exp = ws *> string ":=" *> ws *> exp in
      let ub_exp = ws *> string "to" *> ws *> exp in
      let do_exp = ws *> string "do" *> ws *> exp in
      for_id
      >>= fun var ->
      lb_exp
      >>= fun lb ->
      ub_exp
      >>= fun hb ->
      do_exp >>| fun body -> PForExp { var; escape = escape_init (); lb; hb; body }
    in
    let break_exp = string "break" >>| fun _ -> PBreakExp in
    let array_exp =
      let type_id = id in
      let size_exp = ws *> char '[' *> exp <* ws <* char ']' in
      let init_exp = ws *> string "of" *> ws *> exp in
      type_id
      >>= fun type_ ->
      size_exp >>= fun size -> init_exp >>| fun init -> PArrayExp { type_; size; init }
    in
    let ty_option =
      let some = Angstrom.map (ws *> char ':' *> id) ~f:Option.some in
      let none = return None in
      some <|> none
    in
    let record_exp =
      let type_ = id in
      let field_assign =
        let id = ws *> id in
        let exp = ws *> string "=" *> ws *> exp in
        both id exp
      in
      let fields =
        let left = ws *> char '{' in
        let comma = ws *> char ',' <* ws in
        let right = ws *> char '}' in
        left *> sep_by comma field_assign <* right
      in
      type_ >>= fun type_ -> fields >>| fun fields -> PRecordExp { type_; fields }
    in
    let fields =
      let tyfield =
        let field_id = ws *> id in
        let ty = ws *> char ':' *> ws *> id in
        both field_id ty
        >>| fun (pfd_name, pfd_type) ->
        { pfd_name; pfd_escape = escape_init (); pfd_type }
      in
      let comma = ws *> char ',' <* ws in
      ws *> sep_by comma tyfield
    in
    let typedec =
      let type_id = string "type" *> id <* ws <* char '=' <* ws in
      let ty =
        let arrayOf =
          let p = string "array" *> ws *> string "of" *> ws *> id in
          p >>| fun result -> ArrayTy result
        in
        let ty_name = id >>| fun i -> NameTy i in
        let tyfields =
          char '{' *> fields <* ws <* char '}' >>| fun result -> RecordTy result
        in
        ws *> choice [ arrayOf; ty_name; tyfields ]
      in
      both type_id ty >>| fun (ptd_name, ptd_type) -> { ptd_name; ptd_type }
    in
    let fundec =
      let fun_id = string "function" *> ws *> id in
      let fields = ws *> char '(' *> ws *> fields <* ws <* char ')' in
      let body = ws *> char '=' *> exp in
      fun_id
      >>= fun pfun_name ->
      fields
      >>= fun pfun_params ->
      ty_option
      >>= fun pfun_result ->
      body >>| fun pfun_body -> { pfun_name; pfun_params; pfun_result; pfun_body }
    in
    let dec =
      let typedecs = sep_by1 ws typedec >>| fun x -> PTypeDec x in
      let funcdecs = sep_by1 ws fundec >>| fun x -> PFunctionDec x in
      let vardec =
        let var_id = string "var" *> id in
        let var_exp = ws *> string ":=" *> exp in
        var_id
        >>= fun name ->
        ty_option
        >>= fun type_ ->
        var_exp >>| fun init -> PVarDec { name; escape = escape_init (); type_; init }
      in
      ws *> choice [ typedecs; funcdecs; vardec ]
    in
    let let_exp =
      let let_dec_list = string "let" *> ws *> sep_by1 ws dec in
      let in_exp = ws *> string "in" *> exp in
      let _end = ws *> string "end" in
      let_dec_list
      >>= fun dec_list ->
      in_exp
      >>= fun in_exp -> _end >>| fun _ -> PLetExp { decs = dec_list; body = in_exp }
    in
    let unar_minus =
      char '-' *> exp >>| fun x -> POpExp { left = PIntExp 0; oper = MinusOp; right = x }
    in
    let non_op =
      ws
      *> choice
           [ let_exp
           ; record_exp
           ; array_exp
           ; break_exp
           ; for_exp
           ; while_exp
           ; if_exp
           ; fcall_exp
           ; seq_exp
           ; assign_exp
           ; string_exp
           ; number_exp
           ; nil_exp
           ; var_exp
           ; unar_minus
           ]
    in
    let bin_op_exp =
      let open Base in
      (* create left associative bin op parser *)
      let create inner oper p =
        let cons left right = POpExp { left; oper; right } in
        p
        >>= fun init ->
        let fold ls = List.fold ls ~init ~f:cons in
        fold <$> many (inner *> p)
        (* inner *> p >>| cons init *)
      in
      let create_or left right =
        PIfExp { test = left; then_ = true_; else_ = Some right }
      in
      let create_and left right =
        PIfExp { test = left; then_ = right; else_ = Some false_ }
      in
      let create_logic inner create p =
        p
        >>= fun init ->
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
    ws
    *> choice
         [ let_exp
         ; record_exp
         ; array_exp
         ; break_exp
         ; for_exp
         ; while_exp
         ; bin_op_exp
         ; if_exp
         ; fcall_exp
         ; seq_exp
         ; assign_exp
         ; string_exp
         ; number_exp
         ; nil_exp
         ; var_exp
         ; unar_minus
         ])
;;

let parse str =
  parse_string ~consume:All (exp <* ws) str
  |> function
  | Ok x -> Base.Either.first x
  | Error m -> Base.Either.second m
;;
