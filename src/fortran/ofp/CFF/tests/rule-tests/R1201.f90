! Test interface-block
!      interface-block  is  interface-stmt
!                             [ interface-specificiation ] ...
!                           end-interface-stmt
!
!      interface-specification  is  interface-body
!                               or  procedure-stmt
!
!      interface-stmt  is  INTERFACE [ generic-spec ]
!                      or  ABSTRACT INTERFACE
!
!      end-interface-stmt  is  END INTERFACE [ generic-spec ]
!
! Not tested here: interface-body, procedure-stmt, and generic-spec.

! Include none of the optional parts.
INTERFACE
END INTERFACE

! Include a generic-spec in the interface-stmt and end-interface-stmt
INTERFACE foo
END INTERFACE foo

! Try an abstract interface
!TODO-F08 abstract INTERFACE
!TODO-F08 END INTERFACE

! Include an optional interface-specification
INTERFACE
   SUBROUTINE sub()
   END SUBROUTINE sub
END INTERFACE

! Include multiple optional interface-specification
INTERFACE
   SUBROUTINE bub()
   END SUBROUTINE bub
   FUNCTION foo()
   END FUNCTION foo
END INTERFACE

END

