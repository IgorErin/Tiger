type exp = unit

module Level : sig
  type t

  val outer_most : t
  val new_level : prev:t -> label:Temp.label -> formals:bool list -> t
  val frame : t -> Frame.t
  val prev : t -> t
  val equal : t -> t -> bool
end = struct
  type t =
    | Outer
    | Regular of
        { prev : t
        ; uneque : unit ref
        ; frame : Frame.t
        }

  let outer_most = Outer

  let new_level ~prev ~label ~formals =
    let formals = true :: formals in
    let frame = Frame.new_frame ~label ~formals in
    Regular { prev; uneque = ref (); frame }
  ;;

  let outer_encounter () = failwith "Outer frame encounter"

  let frame = function
    | Outer -> outer_encounter ()
    | Regular { frame; _ } -> frame
  ;;

  let uneque = function
    | Outer -> outer_encounter ()
    | Regular { uneque; _ } -> uneque
  ;;

  let prev = function
    | Outer -> outer_encounter ()
    | Regular { prev; _ } -> prev
  ;;

  let equal fst snd = Base.phys_equal (uneque fst) (uneque snd)
end

module Access : sig
  type t

  val create : level:Level.t -> access:Frame.access -> t
  val access : t -> Frame.access
  val level : t -> Level.t
end = struct
  type t =
    { level : Level.t
    ; access : Frame.access
    }

  let create ~level ~access = { level; access }
  let access { access; _ } = access
  let level { level; _ } = level
end

let alloc_local level =
  let frame = Level.frame level in
  let access = Frame.alloc_local ~frame in
  Access.create ~level ~access
;;

let static_link frame = frame |> Frame.formals |> List.hd
let fp = Ir.temp Frame.fp

(* -----------------------------------------------------------*)

module Exp : sig
  type t

  val ex : Ir.exp -> t
  val nx : Ir.stm -> t
  val cx : (Temp.label -> Temp.label -> Ir.stm) -> t
  val to_exp : t -> Ir.exp
  val to_stm : t -> Ir.stm
  val to_jump : t -> Temp.label -> Temp.label -> Ir.stm
end = struct
  type t =
    | Ex of Ir.exp
    | Nx of Ir.stm
    | Cx of (Temp.label -> Temp.label -> Ir.stm)

  let to_exp =
    let open Ir in
    function
    | Ex e -> e
    | Nx s -> Ir.Eseq (s, Const 0)
    | Cx k ->
      let t = Temp.new_label () in
      let f = Temp.new_label () in
      let result = name @@ Temp.new_temp () in
      eseq (seq [ move result true_; k t f; label f; move result false_; label t ]) result
  ;;

  let to_stm =
    let open Ir in
    function
    | Ex e -> Exp e
    | Nx s -> s
    | Cx k ->
      let l = Temp.new_label () in
      seq [ k l l; label l ]
  ;;

  let to_jump =
    let open Ir in
    function
    | Ex e -> fun t f -> cjump EQ e false_ f t
    | Nx _ -> failwith "Nx in jump"
    | Cx k -> k
  ;;

  let ex e = Ex e
  let nx s = Nx s
  let cx c = Cx c
end

(*--------------------------------------------------------*)

module Common = struct
  let offset_of_int ~number = Ir.(const @@ (Frame.word_size * number))
  let offset ~source ~offset = Ir.(mem @@ binop offset Plus source)

  let map_arithm =
    let open Ir in
    function
    | `PlusOp -> Plus
    | `MinusOp -> Minus
    | `TimesOp -> Mul
    | `DivideOp -> Div
  ;;

  let map_rel =
    let open Ir in
    function
    | `EqOp -> EQ
    | `NeqOp -> NE
    | `LtOp -> LT
    | `LeOp -> LT
    | `GtOp -> GT
    | `GeOp -> GE
  ;;
end

let null_check value =
  let t = Temp.new_label () in
  let f = Temp.new_label () in
  Ir.(
    eseq
      (seq [ cjump EQ value null f t; label f; exp @@ call_null_reference; label t ])
      value)
;;

let simple_var ~access ~level =
  let target_level = Access.level access in
  let rec loop current_level acc =
    if Level.equal current_level target_level
    then acc
    else (
      let acc =
        let frame = Level.frame current_level in
        let static_link = static_link frame in
        Frame.exp static_link acc
      in
      let prev = Level.prev current_level in
      loop prev acc)
  in
  let var_access = Access.access access in
  loop level @@ Frame.exp var_access fp |> Exp.ex
;;

let field_var ~var ~number =
  (if number = 0
   then var
   else Common.offset ~source:var ~offset:(Common.offset_of_int ~number))
  |> Exp.ex
;;

module Array = struct
  let length ~array_exp = Ir.mem array_exp

  let bound_check ~index ~length ~result =
    let t = Temp.new_label () in
    let f = Temp.new_label () in
    let z = Temp.new_label () in
    Ir.(
      eseq
        (seq
           [ cjump GT index (const 0) z f
           ; label z
           ; cjump LT index length t f
           ; label f
           ; exp @@ call_out_of_bound
           ; label t
           ])
        result)
  ;;

  let get ~array_exp ~index_exp =
    let offset =
      let one = Common.offset_of_int ~number:1 in
      Ir.(binop index_exp Plus one)
    in
    Ir.(mem @@ binop array_exp Plus offset)
  ;;

  let get_checked ~array_exp ~index_exp =
    let length = length ~array_exp in
    let result = get ~array_exp ~index_exp in
    bound_check ~index:index_exp ~length ~result
  ;;
end

let subscript_var ~var_exp ~index_exp =
  Array.get_checked ~array_exp:var_exp ~index_exp |> Exp.ex
;;

let nill = Ir.null |> Exp.ex
let int c = c |> Ir.const |> Exp.ex

let op_aritm ~left ~oper ~right =
  let oper = Common.map_arithm oper in
  Ir.binop left oper right |> Exp.ex
;;

let op_rel ~left ~oper ~right =
  let oper = Common.map_rel oper in
  let result t f = Ir.(cjump oper left right t f) in
  Exp.cx result
;;
