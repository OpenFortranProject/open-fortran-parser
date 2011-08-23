!
! This tests a bug reported by Soeren (username ozi23).  The latest
! release of OFP (0.8.3) handles this correctly.  So does ROSE.
!
   character(len=8) :: date = '????????'
   character(len=7) :: data = 'd2spec\'

   print *, date
   print *, data

end
