  $  cat ./code.tig
  /* This is illegal, since there are two functions with the same name
      in the same (consecutive) batch of mutually recursive functions.
     See also test48 */
  let
  	function g(a:int):int = a
  	function g(a:int):int = a
  in
  	0
  end
  $ Tiger -dtypedtree ./code.tig 
  { Typedtree.exp_desc =
    Typedtree.TLetExp {
      decs =
      [(Typedtree.TFunctionDec
          [{ Typedtree.fun_name = (12, "g");
             fun_params =
             [{ Typedtree.fd_name = (13, "a"); fd_escape = ref (true);
                fd_type = int }
               ];
             fun_result = int;
             fun_body =
             { Typedtree.exp_desc =
               (Typedtree.TVarExp
                  { Typedtree.var_desc = (Typedtree.TSimpleVar (13, "a"));
                    var_type = int });
               exp_type = int }
             };
            { Typedtree.fun_name = (12, "g");
              fun_params =
              [{ Typedtree.fd_name = (13, "a"); fd_escape = ref (true);
                 fd_type = int }
                ];
              fun_result = int;
              fun_body =
              { Typedtree.exp_desc =
                (Typedtree.TVarExp
                   { Typedtree.var_desc = (Typedtree.TSimpleVar (13, "a"));
                     var_type = int });
                exp_type = int }
              }
            ])
        ];
      body = { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
    exp_type = int }
