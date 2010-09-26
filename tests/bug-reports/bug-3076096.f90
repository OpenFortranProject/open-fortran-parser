!
! This is not a parser or lexer bug but a reporting error.
! action.ac_implied_do_control should call do-variable
! which should output an identifier.
!
! To pass this test should output a line with the following:
!
!  R 919:io-implied-do-control: hasStride=true
!
real, dimension(3) :: b = (/(j+i, j=1,3)/)

end
