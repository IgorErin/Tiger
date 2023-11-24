exception Error of string

let raise str = raise @@ Error str
