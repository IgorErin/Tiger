module Helpers = struct
  let get =
    let open Base.Either in
    function
    | First str -> str
    | Second m -> failwith m
  ;;

  let dump print is tree =
    if is then 
      begin 
      print Format.std_formatter tree;
      Format.print_newline ();
      end ;

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
    | First x -> Some x
    | Second e -> 
      Format.printf "parsing error: %s" e ; None
  ;;

  let dump = Helpers.dump Tiger.Parsetree.pp_exp
end

module Typing = struct
  let run tree =
    try Tiger.Typing.trans tree |> Option.some with
    | Tiger.Typing.Error { message; error } ->
      if not @@ String.equal String.empty message then Format.printf "message: %s\n" message;
      Format.printf "error: %s" @@ Tiger.Typing.show_error error ;
      None
    | e -> raise e
  ;;

  let dump = Helpers.dump Tiger.Typedtree.pp_exp
end

module Ir = struct
  let run tree = Tiger.Semant.trans tree |> Option.some 
  let dump = Helpers.dump Tiger.Semant.pp
end
