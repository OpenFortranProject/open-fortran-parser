!!!!!!!!!!!
! R1112.f90 - test of R1112 only attribute
!

!! Module for subsequent tests
!
MODULE mymodule
  INTEGER :: this, that, theother, there
END MODULE

USE mymodule , ONLY : this, that, theother
END
