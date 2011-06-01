!
! This file tests bug 3306187.  The problem reported was that
! line continuation didn't work for the string.
!
program test_string_cont
CHARACTER(len=128) :: s
s='continuation &
&string'
end
