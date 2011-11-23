impure subroutine apply_boundary_conditions(U)

   real, HALO(1:*:1,1:*:1), intent(out) :: U(:,:)

   U(0,:) = 1.0   ! top boundary

end subroutine
