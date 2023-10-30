let () =
  let anon_fun = Config.set_path in
  let message = "Path, parameters, etc. TODO()" in

  let options =
    let open Config in
    [
      ("-dparsetree", Arg.Unit set_dparsetree, "Dump parse tree");
      ("-dtypedtree", Arg.Unit set_dtypedtree, "Dumpe typed tree");
    ]
  in

  Arg.parse options anon_fun message

let read_file path =
  let ch = Stdio.In_channel.create path in
  Base.Exn.protect
    ~f:(fun () -> In_channel.input_all ch)
    ~finally:(fun () -> In_channel.close ch)

let () =
  let name = Config.get_path () in
  let code = read_file name in
  let parse_tree =
    let open Tiger in
    let open Base in
    Parser.of_string code |> Parser.parse |> function
    | Either.First x -> x
    | Either.Second msg -> failwith @@ Printf.sprintf "Parse error: %s" msg
  in
  if Config.default.dparsetree then
    Printf.printf "%s" @@ Tiger.Parsetree.show_exp parse_tree;

  let typedtree = Tiger.Semant.trans parse_tree in
  if Config.is_dtypedtree () then
    Tiger.Typedtree.pp_exp Format.str_formatter typedtree;
  ()
