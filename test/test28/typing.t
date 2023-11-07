  $  cat ./code.tig
  /* error : different record types */
  
  let
  	type rectype1 = {name:string , id:int}
  	type rectype2 = {name:string , id:int}
  
  	var rec1: rectype1 := rectype2 {name="Name", id=0}
  in
  	rec1
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Types must be equal {(name : String); (id : int);} =/= (Name  rectype1)
  error: Type mismatch
