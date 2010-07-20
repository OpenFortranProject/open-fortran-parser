! Testing interface-stmt, R1203
!
! Passes gfortran and ROSE tests if ABSTRACT interface and end interface are commented out
!
10 interface
end interface
INTERFACE binky
end interface
ABSTRACT interface
end interface
end
