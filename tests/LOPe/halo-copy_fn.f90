pure CONCURRENT subroutine laplace(U, other_AMR_vars)
   real  ::  U(0:,0:)
   HALO, copy_fn=user_supplied_function :: U (1:*:1,1:*:1)

   U(0:0) = U(-1,0) + U(+1,0) + U(0,-1) + U(0,+1) - 3*U(0,0)

end subroutine
