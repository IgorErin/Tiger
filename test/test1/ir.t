  $  cat ./code.tig
  let
  	type  arrtype = array of int
  	var arr1:arrtype := arrtype [10] of 0
  in
  	arr1
  end
$ Tiger -dir ./code.tig
