!
! Output should produce only 2 format-items.  It's a bug if 3 are produced
! although the parser will claim success.
!
1000 format (a4,:)

! More complex case (as it was reported to Dan from ANL):
!
! This should produce 10 format items as ",a2:," is really 2 edit
! descriptors.  C1002 (R1003) states that the optional comma shall not
! be omitted EXCEPT before or after a colon edit descriptor (10.8.3)
!
2000 format (a4,:,'-',a2:,'-',a2,:,'-',a5) ! problem is the comma before the :

end
