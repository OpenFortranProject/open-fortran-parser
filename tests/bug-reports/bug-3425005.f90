!
! This tests for extra keywords added to prefix-spec in 2008
!
! Added keywords: IMPURE, MODULE
!

impure recursive module subroutine foo
end subroutine foo

module elemental pure integer function bar()
   bar = 13
end function bar


