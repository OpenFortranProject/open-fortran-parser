!
! test continued token
!
int&
&eger i

! test with blank and comment lines in middle
int&
       ! this is a comment line followed by two blank lines within a continued line
    
 
&eger j

! continue line without splitting tokens
    integer :: &! 'comment after' &

               k
! comment will end file (no '\n' before EOF)
end!
