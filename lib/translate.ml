type exp = unit

module Level : sig
  type t

  val outer_most : t
  val new_level : prev:t -> label:Temp.label -> formals:bool list -> t
  val frame : t -> Frame.t
  val prev_exn : t -> t
  val equal : t -> t -> bool
  val common_level_exn : t -> t -> t
  val get_static_link : t -> Frame.access
  val label_exn : t -> Temp.label
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

  let prev_exn = function
    | Outer -> outer_encounter ()
    | Regular { prev; _ } -> prev
  ;;

  let prev_opt = function
    | Outer -> None
    | Regular { prev; _ } -> Some prev
  ;;

  let equal fst snd = Base.phys_equal (uneque fst) (uneque snd)

  let common_level_exn fst snd =
    let get_chain level =
      let rec loop acc level =
        match prev_opt level with
        | Some x -> loop (level :: acc) x
        | None -> level :: acc |> List.rev
      in
      loop [] level
    in
    let fst_chain = get_chain fst in
    let snd_chain = get_chain snd in
    List.combine fst_chain snd_chain
    |> List.find_opt (fun (fst, snd) -> equal fst snd)
    |> Core.Option.value_or_thunk ~default:(fun () ->
      failwith "Common enclosed level not found")
    |> Base.fst
  ;;

  let get_static_link level =
    let frame = frame level in
    let formals = Frame.formals frame in
    List.hd formals
  ;;

  let label_exn = function
    | Regular { frame; _ } -> Frame.label frame
    | Outer -> failwith "Oter has no label"
  ;;
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
  let one = Ir.const 1
  let zero = Ir.const 0
  let fp = Ir.(temp Frame.fp)

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

  let malloc count =
    (* TODO correct malloc call*)
    Ir.(Frame.call_external ~name:"malloc" ~args:[ const count ])
  ;;

  let is_true ~value ~t ~f = Ir.(cjump EQ value true_ t f)
  let inc ~e = Ir.(move e (binop e Plus one))
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
        let static_link = Level.get_static_link current_level in
        Frame.exp ~acc:static_link ~fp:acc
      in
      let prev = Level.prev_exn current_level in
      loop prev acc)
  in
  let var_access = Access.access access in
  loop level @@ Frame.exp ~acc:var_access ~fp |> Exp.ex
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

  let alloc ~init ~size =
    let init = Exp.to_exp init in
    let size = Exp.to_exp size in
    Frame.call_external ~name:"init_array" ~args:[ init; size ] |> Exp.ex
  ;;
end

let subscript_var ~var_exp ~index_exp =
  let index_exp = index_exp |> Exp.to_exp in
  Array.get_checked ~array_exp:var_exp ~index_exp |> Exp.ex
;;

let nill = Ir.null |> Exp.ex
let int c = c |> Ir.const |> Exp.ex
let assign ~name ~exp = Ir.move name exp |> Exp.nx
let unit = Ir.unit |> Ir.exp

let seq seq =
  seq
  |> Core.List.reduce ~f:(fun acc next -> Ir.(eseq (exp acc) @@ next))
  |> Option.value ~default:Ir.unit
  |> Exp.ex
;;

let if_else ~test ~then_ ~else_ =
  let t = Temp.new_label () in
  let f = Temp.new_label () in
  let result = Ir.name @@ Temp.new_temp () in
  Ir.(
    eseq (seq [ move result then_; test t f; label f; move result else_; label t ]) result)
  |> Exp.ex
;;

let if_ ~test ~then_ =
  let test = Exp.to_jump test in
  let then_ = Exp.to_stm then_ in
  let t = Temp.new_label () in
  let f = Temp.new_label () in
  Ir.(seq [ test t f; label t; then_; label f ]) |> Exp.nx
;;

module String = struct
  let const str =
    let label = Temp.new_label () in
    (str, label), Exp.ex @@ Ir.name label
  ;;
end

module Int = struct
  let op_aritm ~left ~oper ~right =
    let oper = Common.map_arithm oper in
    Ir.binop left oper right |> Exp.ex
  ;;

  let op_rel ~left ~oper ~right =
    let oper = Common.map_rel oper in
    let result t f = Ir.(cjump oper left right t f) in
    Exp.cx result
  ;;
end

module Record = struct
  let alloc values =
    let length = List.length values in
    let t = Ir.temp @@ Temp.new_temp () in
    let source = Ir.(move t @@ Common.malloc length) in
    let values = List.mapi (fun index value -> index, value |> Exp.to_exp) values in
    List.fold_left
      (fun acc (count, value) ->
        let current =
          let offset = Common.offset_of_int ~number:count in
          let target = Common.offset ~source:t ~offset in
          Ir.(move target value)
        in
        Ir.(seq [ acc; current ]))
      source
      values
    |> Exp.nx
  ;;
end

let break ~l = Ir.(jump ~e:(name l) ~ls:[ l ]) |> Exp.nx

let while_ ~test ~body ~dl =
  let test = Exp.to_exp test in
  let body = Exp.to_stm body in
  let module C = Common in
  let sl = Temp.new_label () in
  let bl = Temp.new_label () in
  Ir.(
    seq
      [ label sl
      ; C.is_true ~value:test ~t:bl ~f:dl
      ; label bl
      ; body
      ; jump ~e:(name sl) ~ls:[ sl ]
      ; label dl
      ])
  |> Exp.nx
;;

let for_ ~lb ~hb ~body ~dl =
  let lb = Exp.to_exp lb in
  let hb = Exp.to_exp hb in
  let body = Exp.to_stm body in
  let ht = Ir.temp @@ Temp.new_temp () in
  let ct = Ir.temp @@ Temp.new_temp () in
  let bl = Temp.new_label () in
  let sl = Temp.new_label () in
  Ir.(
    seq
      [ move ct lb
      ; move ht hb
      ; label sl
      ; cjump LE ct ht bl dl
      ; label bl
      ; body
      ; cjump LT ct hb sl dl
      ])
  |> Exp.nx
;;

let fcall ~fl ~cl ~args ~t =
  let dl = Level.common_level_exn fl cl in
  let step acc lv =
    let sl = Level.get_static_link lv in
    Frame.exp ~acc:sl ~fp:acc
  in
  let rec loop acc current =
    let acc = step acc current in
    if Level.equal current dl then acc else loop acc @@ Level.prev_exn current
  in
  let fp = loop Common.fp cl in
  let args = fp :: List.map Exp.to_exp args in
  let flabel = Level.label_exn fl in
  let result = Ir.(call (name flabel) args) in
  if Types.is_unit t then Ir.exp result |> Exp.nx else result |> Exp.ex
;;
