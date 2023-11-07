  $  cat ./code.tig
  /* error : compare rec with array */
  
  let
  
  	type arrtype = array of int
  	type rectype = {name:string, id: int}
  
  	var rec := rectype {name="aname", id=0}
  	var arr := arrtype [3] of 0
  
  in
  	if rec <> arr then 3 else 4
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal {(name : String); (id : int);} =/= array of int
  error: Type mismatch
