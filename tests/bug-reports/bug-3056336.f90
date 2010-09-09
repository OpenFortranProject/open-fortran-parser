!
! This file is a test for bug 3056336.  The bug was introduced while fixing
! another bug.  The problem is that a new token was introduced which
! broke the exponential notation.  This token T_EDIT_DESC_MISC was made less
! general to fix the problem.
!
   real(REAL8),   save :: mesg_timermin  (MXMPITIMER) = huge(1e0_REAL8)
   x = 1048576e0_REAL8
end
