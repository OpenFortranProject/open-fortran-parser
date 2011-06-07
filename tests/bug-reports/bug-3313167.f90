!
! Bug 3313167.  The problem is that the two function calls were
! essentially being skipped over in conversion to idents.
!
  logical(kind=1) :: i, j
  integer(kind=1) :: a, b
  character*1 :: c, d

   localCount ( :numDims+1) = (/ len(values(1)), shape(values) /)

!
! this portion of the test from gfortran test file parens_6.f90
!
! { dg-do run }
! { dg-options "-std=legacy" }
!
! PR fortran/33626
! Types were not always propagated correctly
  if (any( (/ kind(i .and. j), kind(.not. (i .and. j)), kind((a + b)), &
              kind((42_1)), kind((j .and. i)), kind((.true._1)), &
              kind(c // d), kind((c) // d), kind((c//d)) /) /= 1 )) call abort()
  if (any( (/ len(c // d), len((c) // d), len ((c // d)) /) /= 2)) call abort()

end
