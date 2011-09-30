!
! Regression test for ROSE bug 3324735
!
module m 

  character(len=*),private,parameter :: hotvars = &
'&
& bwat  topg  kinbcmask  acab  temp  uvelhom  artm  usurf  vvelhom  velnormhom &
& flwa  beta  bheatflx  bmlt  tauf  etill  u_till  thk &
&'
end module 
