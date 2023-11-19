let () =
  let anon_fun = Config.set_path in
  let message = "Path, parameters, etc. TODO()" in
  let options =
    let open Config in
    [ "-dparsetree", Arg.Unit set_dparsetree, "Dump parse tree"
    ; "-dtypedtree", Arg.Unit set_dtypedtree, "Dumpe typed tree"
    ]
  in
  Arg.parse options anon_fun message
;;

let read_file path =
  let ch = Stdio.In_channel.create path in
  Base.Exn.protect
    ~f:(fun () -> In_channel.input_all ch)
    ~finally:(fun () -> In_channel.close ch)
;;

let () =
  let name = Config.get_path () in
  let code = read_file name in
  let open Tiger in
  Parser.of_string code
  |> Parser.parse
  |> function
  | Core.Either.First tree ->
    if Config.default.dparsetree then Printf.printf "%s" @@ Tiger.Parsetree.show_exp tree;
    if Config.default.dtypedtree
    then
      (try Printf.printf "%s" @@ Tiger.Typedtree.show_exp @@ Typing.trans tree with
       | Tiger.Typing.Error { message; error } ->
         if message <> "" then Printf.printf "message: %s\n" message;
         Printf.printf "error: %s" @@ Tiger.Typing.show_error error
       | e -> raise e)
      |> ignore
  | Core.Either.Second _ -> Printf.printf "Parsing error."
;;
