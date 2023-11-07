  $  cat ./code.tig
  /* This is legal.  The second function "g" simply hides the first one.
     Because of the intervening variable declaration, the two "g" functions
     are not in the same  batch of mutually recursive functions. 
     See also test39 */
  let
  	function g(a:int):int = a
  	type t = int
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
             }
            ]);
        (Typedtree.TTypeDec [{ Typedtree.td_name = (14, "t"); td_type = int }]);
        (Typedtree.TFunctionDec
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
              }
             ])
        ];
      body = { Typedtree.exp_desc = (Typedtree.TIntExp 0); exp_type = int }};
    exp_type = int }
