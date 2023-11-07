  $  cat ./code.tig
  /* error : field not in record type */
  
  let 
  	type rectype = {name:string , id:int}
  	var rec1 := rectype {name="Name", id=0}
  in
  	rec1.nam := "asd"
  end
  $ Tiger -dtypedtree ./code.tig 
  message: No such fiedl in {(name : String); (id : int);}
  error: unbound name: nam
