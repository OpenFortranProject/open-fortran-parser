! Test interface-body
!      interface-body  is  function-stmt
!                            [ specification-part ]
!                          end-function-stmt
!                      or  subroutine-stmt
!                            [ specification-part ]
!                          end-subroutine-stmt
!
! Not tested here: function-stmt, specification-part, end-function-stmt, 
! subroutine-stmt, and end-subroutine-stmt.
!
! interface-body tested as part of an interface-block.

! Test functions.
INTERFACE
   FUNCTION foo()
   END FUNCTION foo
END INTERFACE

! Test subroutines.
!TODO-F90 INTERFACE
!TODO-F90    SUBROUTINE sub
!TODO-F90    END SUBROUTINE sub
!TODO-F90 END INTERFACE

! Test both together; this is not a test of an interface-body, but actually
! a test of interface-specification, which allows for multiple interface-body.
INTERFACE
   SUBROUTINE dub()
   END SUBROUTINE dub
   FUNCTION bar()
   END FUNCTION bar
END INTERFACE

END

   
