!
! bug 3313439
!
! The bug is causes by INTEGER converted into an identifier because the lexer
! thinks this is an assignment statement.
!
       INTEGER i = 0
       END
