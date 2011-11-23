pure CONCURRENT subroutine laplace(U)
   real, intent(inout), HALO(1:*:1,1:*:1) :: U(0:,0:)

   !... algorithm implementation is one statement
   !
   U(0:0) = U(-1,0) + U(+1,0) + U(0,-1) + U(0,+1) - 3*U(0,0)

end subroutine laplace


   pure CONCURRENT subroutine convolve(Image, Filter)
      real, intent(in out), HALO(:,:) :: Image(0:,0:)
      real, intent(in) :: Filter(-3:3,-3:3)

      Image(0,0) = sum(Filter * Image)

   end subroutine convolve


   !... predict flux on a face
   !
   concurrent subroutine predict_on_face(Mass, U, Flux)
       halo  ::  Mass(0:*:1)

       Flux(0) = U(0) * (Mass(0) + Mass(1))/2
   end subroutine


   !... accumulate flux on a cell
   !
   concurrent subroutine accumulate_on_cell(Mass, Flux)
       halo ::  Flux (0:*:1)

       Mass(0) = Mass(0) + (Flux(0) - Flux(1))*(dt/dx)
   end subroutine
