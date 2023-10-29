let anon_fun = Config.set_path
let message = "Path, parameters, etc. TODO()"

let options =
  let open Config in
  [ ("-dparsetree", Arg.Unit dump_parse_tree, "Set file format") ]

let () = Arg.parse options anon_fun message

let read_file path =
  let ch = Stdio.In_channel.create path in
  Base.Exn.protect
    ~f:(fun () -> In_channel.input_all ch)
    ~finally:(fun () -> In_channel.close ch)

let () =
  let path = Config.get_path () in
  let code = read_file path in
  let parse_tree =
    let open Tiger in
    let open Base in
    Parser.of_string code |> Parser.parse |> function
    | Either.First x -> x
    | Either.Second msg -> failwith @@ Printf.sprintf "Parse error: %s" msg
  in
  if Config.default.dparsetree then
    Printf.printf "%s" @@ Tiger.Parsetree.show_exp parse_tree;
  Tiger.Semant.type_check parse_tree
