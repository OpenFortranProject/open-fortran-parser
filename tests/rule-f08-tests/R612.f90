! Test part-ref, which is:
!      part-ref  is  part-name [ ( section-subscript-list ) ]
!
! part-name is a name->variable->T_IDENT.
! Tested separetly is: section-subscript-list (R619).
!
! part-ref tested as part of an assignment-stmt.

! Kyle add a two element list to tests
! and test image selector (this won't work with gfortran)

integer :: a(10), b(12)

a(1:3) = 3
a(3:4) = b(5:6)
a = 3

end

