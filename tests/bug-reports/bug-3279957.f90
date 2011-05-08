!
! This file tests for bug #3279957.  The bug was that the '&' character in the
! string was treated as a continuation character even though it was in the middle
! of a string.
!
   character(7) :: data_file
   data_file(1:7) = '&GLOBAL'
   print *, data_file
end
