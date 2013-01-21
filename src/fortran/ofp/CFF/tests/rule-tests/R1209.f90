! Test import-stmt
!      import-stmt  is  IMPORT [ [::] import-name-list ]
!
! Not tested here: import-name-list
! 
! import-stmt is only allowed in an interface-body (C1210).
MODULE import_stmt
  INTEGER :: a, b, c

INTERFACE
   SUBROUTINE sub()
     ! No optional parts.
!TODO-F08     IMPORT
   END SUBROUTINE sub

   SUBROUTINE sub1()
     ! Optional import-name-list
!TODO-F08     IMPORT a, b
   END SUBROUTINE sub1

   SUBROUTINE sub2()
     ! Optional import-name-list with :: separater.
!TODO-F08     IMPORT :: a, b, c
   END SUBROUTINE sub2
END INTERFACE

END MODULE


