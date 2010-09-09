!
! This file tests bug 3056328.  See also bug 3056309.  It has the same
! properties except that there is an T_ELSEIF rather than T_ELSE T_IF.
!
  if (a .lt. value) then
     a = 1
  else if (a .gt. value) then
     a = 3
  else if (a .ne. work(1,to)) then
     a = 4
  end if

end
