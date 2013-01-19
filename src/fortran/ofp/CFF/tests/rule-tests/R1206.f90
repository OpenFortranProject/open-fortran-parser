! Test procedure-stmt
!      procedure-stmt  is  [ MODULE ] PROCEDURE procedure-name-list
!
! Not tested here: procedure-name-list.
!
! procedure-stmt tested as part of an interface-specification.
MODULE aMod
INTERFACE generic_name
   ! First without the optional MODULE
!TODO-F08?   PROCEDURE a
!TODO-F08?   PROCEDURE a, b
   
   ! Now with the MODULE
   MODULE PROCEDURE c
   MODULE PROCEDURE d, e
END INTERFACE

CONTAINS

SUBROUTINE c
END SUBROUTINE
SUBROUTINE d(i)
END SUBROUTINE
SUBROUTINE e(x)
END SUBROUTINE

END MODULE


