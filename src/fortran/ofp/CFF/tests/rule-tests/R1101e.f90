! R1101d.f90 - test of R1101 main-program
!
!   main-program is [ program-stmt ] [
!      specification-part ] [ execution-part ] [
!      internal-subprogram-part ] end-program-stmt program-stmt is
!      PROGRAM program-name end-program-stmt is END [ PROGRAM [
!      program-name ] ] Not tested here: specification-part,
!      execution-part, and internal-subprogram-part.

! Add an optional execution-part
PROGRAM my_prog
  i = 1
END PROGRAM my_prog
