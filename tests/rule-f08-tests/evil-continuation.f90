!
! Tests continuation for free format.  No rule number
! as continuation is not officially part of the grammar (lexer issue)
!
implicit none
integer :: x& ! this is truly evil
            &x

character(6) :: word = "hell&
                            &no"

300   format (1h1,58x,2h!)&
     &)

xx = 1

print *, word

end
