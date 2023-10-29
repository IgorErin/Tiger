open Tiger.Ast
open Tiger

let create_test ast ty =
  let env = Env.base_env in
  let actual_ty = (Semant.transExp env ast).ty in
  Types.equal ty actual_ty

let%test "int exp" = create_test (IntExp 1) Types.Int
let%test "string exp" = create_test (StringExp "string") Types.String
let%test "Nil exp" = create_test NilExp Types.Nil
