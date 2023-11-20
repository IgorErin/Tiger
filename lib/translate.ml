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

  let outer_encounter () = failwith "Outer  frame encounter"

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

(* -----------------------------------------------------------*)
(* TODO 
let simple_var source (target, frame_access) =
  let rec loop acc current =
    if equal_level target current
    then acc
    else
      let open Ir in
      match current.frame, current.prev with
      | Some frame, Some prev ->
        let new_acc =
          let offset = const @@ Frame.length frame in
          mem @@ binop acc Plus offset
        in
        loop new_acc prev
      | _ -> failwith "Empty desc"
  in
  let acc = Frame.exp frame_access @@ Ir.temp Frame.fp in
  loop acc source
;; *)

module Exp = struct
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
      k l l
  ;;

  let to_jump =
    let open Ir in
    function
    | Ex e -> fun t f -> cjump EQ e false_ f t
    | Nx _ -> failwith "Nx in jump"
    | Cx k -> k
  ;;

  (* let simple_var access level = *)
end
