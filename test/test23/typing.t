  $  cat ./code.tig
  /* error : type mismatch */
  
  let 
  	type rectype = {name:string , id:int}
  	var rec1 := rectype {name="aname", id=0}
  in
  	(rec1.name := 3;
  	rec1.id := "") 
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal String =/= int
  error: Type mismatch
