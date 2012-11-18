! This is a little program to test the tree walker
!
   Program TestParser
      implicit none
      integer      :: i, j
      real(kind=4) :: x
13 End Program TestParser

subroutine foo
!  interface
!  end interface
end subroutine

subroutine bar() BIND(C)
end subroutine bar

! end comment, will this fail program_unit loop?
!
