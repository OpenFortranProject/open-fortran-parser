!
! This is a regression test for bug 3076044.  It tests for a
! TAB character followed by a blank. The convention for a TAB
! character in columns 1..5 followed by a digit 1..9 is a continuation
! line.  If TAB + '0' the '0' is ignored in the input stream.  This
! follows DEC convention (I believe) but is non standard Fortran.
!
      subroutine cg1
	integer i
      end

      program cg2
      implicit none

      integer i,
     ;j
	integer k,
	3l          ! if this were 0l it should be an error
     i,m

      integer T_init, T_last
      parameter (T_init=1, T_last=3)

      character t_names(t_last)*8

	t_names(t_init) = 'init'
      end                              ! end main

