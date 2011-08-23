!
! Bug 3313857.  Also test2007_35.f03 in ROSE.
!
pure subroutine foo(i) bind (C,NAME="foo")

   integer, intent(in) :: i

end subroutine
