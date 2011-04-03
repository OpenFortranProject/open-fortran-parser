!
! WARNING: this bug requires visual comparision with --verbose.  It should have
! 2 format-items in 1000 format and 10 format-items in the 2000 format statement.
!
! Test for bug 3222998.  The bug was fixed by testing for ':' as well as '\'
! in a control-edit-desc.  Both characters can terminate a format-item
! (replace a comma and be a format-item) so both must be checked otherwise a
! zero-length format-item token is created and there will be too many format-items.
!

1000 format(a4,:)

! A more complex case.  There should be 10 format-items as a2: acts as
! two: a2 and :
2000 format (a4,:,'-',a2:,'-',a2,:,'-',a5) ! problem is the comma before the :

end

