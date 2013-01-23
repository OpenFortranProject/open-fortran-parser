!! R1235 dummy-arg and dummy-arg-list
!    is  dummy-arg-name
!    or  *

SUBROUTINE DA
  ENTRY foo1(a)
  ENTRY foo2(*)
  ENTRY foo3(a,*,c)
END
