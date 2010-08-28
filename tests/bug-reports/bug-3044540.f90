!
! This file is a test for bug 3044540.  The first two lines test for
! the bug in the official report and the others perform related tests.
!
program module_cycle
   public cycle
   public contains

   public INTEGER, a
   public :: OPERATOR(.FUNCTION.), private 
   public :: ASSIGNMENT(=), public
   private :: READ(UNFORMATTED), WRITE(FORMATTED), data
   INTENT(INOUT) real, sync
end program module_cycle
