! Test use-stmt
!      use-stmt  is  USE [ [, module-nature ] :: ] module-name [, rename-list ]
!                or  USE [ [, module-nature ] :: ] module-name, 
!                      ONLY : [ only-list ]
!
!      module-nature  is  INTRINSIC
!                     or  NON_INTRINSIC
!
!      rename  is  local-name => use-name
!              or  OPERATOR(local-defined-operator) =>
!                    OPERATOR(use-defined-operator)
!
!      only  is  generic-spec
!            or  only-use-name
!            or  rename
!
!      only-use-name  is  use-name
!
!      local-defined-operator  is  defined-unary-op
!                              or  defined-binary-op
!
!      use-defined-operator  is  defined-unary-op
!                            or  defined-binary-op
!
! Not tested here: generic-spec, only-use-name, local-name, use-name,  
! defined-binary-op, and defined-unary-op.
!
! Note: defined-binary-op and defined-unary-op are ambiguous to the grammar 
! and are both matched as T_DEFINED_OP in the lexer.

!! moduls for preceeding tests
!
MODULE A
  INTEGER :: b, c
END MODULE
MODULE AA
  INTEGER :: b, c
END MODULE
MODULE AAA
  INTEGER :: m, n
END MODULE

! Test with none of the optional parts
USE a

! Include optional module nature
!TODO-F08 use, intrinsic :: iso_c_binding
!TODO-F08 use, non_intrinsic :: my_mod

! Include optional rename-list
USE aa, d=>b, e=>c
!TODO-F08 use a, operator(.myop.)=>operator(.yourop.), integer => real, &
!TODO-F08      b => c, operator(.myotherop.) =>operator(.yourotherop.)

! Include optional only clause
USE aaa, ONLY: m, f=>n

END
