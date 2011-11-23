program bc
     real, halo(1:*:1,1:*:1)  ::  U(N,M)
     halo, boundary(CYCLIC, 0.0:*:1.0)  ::  U

     ! boundary conditions applied during halo exchange
     !
     exchange_halo(Array)

end program

impure subroutine apply_boundary_conditions(U)
   real, HALO(1:*:1,1:*:1), intent(out) :: U(:,:)

   if (THIS_IMAGE == top_boundary) then
      U(0,:) = 1.0
   end if
end subroutine

