!
! Unit test for bug 3385969.  Boz literals are handled by OFP correctly
! but not by ROSE.
!
   integer, parameter :: INT8  = SELECTED_INT_KIND(16)
   integer(INT8), parameter :: ieee64_two = Z'4000000000000000'

   print *, ieee64_two

end
