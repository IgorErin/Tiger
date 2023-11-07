  $  cat ./code.tig
  /* error: mutually recursive types thet do not pass through record or array */
  let 
  
  type a=c
  type b=a
  type c=d
  type d=a
  
  in
   ""
  end
  $ Tiger -dtypedtree ./code.tig 
  message: Cycl type a name
  error: Umbiguos

