! R1101c.f90 - test of R1101 main-program
!
!   main-program is [ program-stmt ] [
!      specification-part ] [ execution-part ] [
!      internal-subprogram-part ] end-program-stmt program-stmt is
!      PROGRAM program-name end-program-stmt is END [ PROGRAM [
!      program-name ] ] Not tested here: specification-part,
!      execution-part, and internal-subprogram-part.

! To include the optional name in end-program-stmt requires (by C1102) 
! the program-stmt with the optional name.
13 PROGRAM my_program
END PROGRAM my_program
