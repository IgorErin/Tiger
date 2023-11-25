  $  cat ./code.tig
  /* local types hide global */
  let
  	type a = int
  in
  	let
  		type a = string
  	in
  		let
  			var a:a := "" 
  		in
  			a
  		end 
  	end
  end
  $ Tiger -dir ./code.tig
  string (("L", 3) : "")
  body:
  (Translate.Exp.Nx
     (Ir.Seq
        [(Ir.Seq
            [(Ir.Seq
                [(Ir.Move ((Ir.Mem (Ir.Temp ("FP", 0))), (Ir.Name ("L", 3))));
                  (Ir.Exp (Ir.Mem (Ir.Temp ("FP", 0))))])
              ])
          ]))
