program check_data
   logical :: zero_on_baddata = .true.
   integer, parameter :: REAL4 = 4
   real :: data(100)

   if(zero_on_baddata)data(n) = 0.0_REAL4  ! FAILS HERE

end program check_data
