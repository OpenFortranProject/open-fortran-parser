!
! This is not a parser or lexer bug but a reporting error.
! action.io_implied_do_control should report a hasStride variable.
!
! from NOTE 9.36
!
! To pass this test should output a line with the following:
!
!  R 919:io-implied-do-control: hasStride=true
!
write(lp, fmt='(10F8.2)') (log(A(i)), i = 1, n+9, k), g

end
