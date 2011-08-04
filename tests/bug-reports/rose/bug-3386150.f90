!
! Regression test for ROSE bug 3386150
!
! Title: ROSE: Array initialization to scalar unparses incorrectly
!
! The bug occurs when the array inializer is unparsed as (/0/), 
! rather than as the scalar, 0.
!
   integer :: A(3) = 0

end
