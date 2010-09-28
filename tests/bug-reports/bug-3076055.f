!
! This is a regression test for bug 3076044.  It tests for a
! TAB character followed by a blank.  The convention we use
! is for TAB + (WS | '0') acts as ';'.  TAB + other char is a
! continuation line.  This follows DEC (I believe) but is
! non standard Fortran.
!
      subroutine cg
	 integer i
      end

      program cg
      implicit none

      integer T_init, T_last
      parameter (T_init=1, T_last=3)

      character t_names(t_last)*8

	 t_names(t_init) = 'init'
      end                              ! end main

