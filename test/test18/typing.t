  $  cat ./code.tig
  /* error : definition of recursive functions is interrupted */
  let
  
  function do_nothing1(a: int, b: string):int=
  		(do_nothing2(a+1);0)
  
  var d:=0
  
  function do_nothing2(d: int):string =
  		(do_nothing1(d, "str");" ")
  
  in
  	do_nothing1(0, "str2")
  end
  $ Tiger -dtypedtree ./code.tig 
  message: undef fun call
  error: unbound name: do_nothing2
