! Test module
!      module  is  module-stmt
!                    [ specification-part ]
!                    [ module-subprogram-part ]
!                  end-module-stmt
!
!      module-stmt  is  MODULE module-name
!
!      end-module-stmt  is  END [ MODULE [ module-name ] ]
!
!      module-subprogram-part  is  contains-stmt 
!                                    module-subprogram
!                                    [ module-subprogram ] ...
!
!      module-subprogram  is  function-subprogram 
!                         or  subroutine-subprogram
!
! Not tested here: specification-part, function-subprogram, and 
! subroutine-subprogram.

! None of the optional parts included
module a
end

! Include the optional MODULE in end-module-stmt
module b
end module

! Include optional MODULE and module-name in end-module-stmt.
module c
end module c

! Include an optional specification-part
module d
  integer i
end module d

! Include an optional module-subprogram-part
module e
contains
  subroutine sub()
  end subroutine sub
  integer function foo()
     foo = 7
  end function foo
end module e

! Include all optional parts
module f
  integer i
contains
  subroutine sub()
  end subroutine sub
  integer function foo()
     foo = 3
  end function foo
end module f

