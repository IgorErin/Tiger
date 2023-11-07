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
  message: Same name in mutual fun def: g
  error: Umbiguos
