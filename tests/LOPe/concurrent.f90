   do concurrent(i=1:NX, j=1:NY)
       call convolve(Array(i,j))
   end do
   exchange_halo(Array)

    do concurrent(i=0:num_cells)
       call predict_on_face(Mass(i), U(i), Flux(i))
    end do

   do concurrent(i=1:num_cells+1)
       call predict_on_face(Mass(i), U(i), Flux(i))
   end do

end


