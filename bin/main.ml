let () =
  let anon_fun = Config.set_path in
  let message = "Path, parameters, etc. TODO()" in
  let options =
    let open Config in
    [ "-dparsetree", Arg.Unit set_dparsetree, "Dump parse tree"
    ; "-dtypedtree", Arg.Unit set_dtypedtree, "Dumpe typed tree"
    ; "-dir", Arg.Unit set_dir, "Dumpe typed tree"
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
  let open Passes in
  let open Core.Option.Monad_infix in 
  Parsing.run code
  >>| Parsing.dump (Config.is_dparsetree ())
  >>= Typing.run
  >>| Typing.dump (Config.is_dtypedtree ())
  |>
  Option.iter (fun result -> 
    if Config.is_dir () then 
      result
      |> Ir.run
      >>| Ir.dump (Config.is_dir ())
      |> ignore)

;;
