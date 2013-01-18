!!!!!!!!!!!
! R1111.f90 - test of R1111 rename
!

!! Module for subsequent tests
!
MODULE mymodule
  INTEGER :: that, bar, beauty
END MODULE

USE mymodule , this=>that, foo=>bar, truth => beauty
END
