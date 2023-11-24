module Helpers = struct
  let get =
    let open Base.Either in
    function
    | First str -> str
    | Second m -> failwith m
  ;;

  let dump print is tree =
    if is then print Format.std_formatter tree;
    tree
  ;;
end

module Parsing = struct
  let run src =
    let open Tiger in
    let open Base.Either in
    Parser.of_string src
    |> Parser.parse
    |> function
    | First x -> x
    | Second e -> failwith e
  ;;

  let dump = Helpers.dump Tiger.Parsetree.pp_exp
end

module Typing = struct
  let run tree =
    try Tiger.Typing.trans tree with
    | Tiger.Typing.Error { message; error } ->
      if message <> "" then Printf.printf "message: %s\n" message;
      let message = Printf.sprintf "error: %s" @@ Tiger.Typing.show_error error in
      Error.raise message
    | e -> raise e
  ;;

  let dump = Helpers.dump Tiger.Typedtree.pp_exp
end

module Ir = struct
  let run tree = Tiger.Semant.trans tree
  let dump = Helpers.dump Tiger.Semant.pp
end
