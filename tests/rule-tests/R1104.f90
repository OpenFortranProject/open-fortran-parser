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
MODULE a
END

! Include the optional MODULE in end-module-stmt
MODULE b
END MODULE

! Include optional MODULE and module-name in end-module-stmt.
MODULE c
END MODULE c

! Include an optional specification-part
MODULE d
  Integer i
END MODULE d

! Include an optional module-subprogram-part
MODULE e
CONTAINS
  subroutine sub()
  END subroutine sub
  Function foo()
    foo = 13
  END FUNCTION foo
END MODULE e

! Include all optional parts
MODULE f
  integer i
contains
  subroutine sub()
  END subroutine sub
  FUNCTION foo()
    foo = 13
  END FUNCTION foo
END MODULE f
