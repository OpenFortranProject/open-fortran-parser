 program multigrid_example
    integer :: mesh8(0:7), mesh4(0:3), mesh2(0:1), mesh1(0)

    ! for all elements in smaller mesh
    do concurrent(i=0:3)
       call coarsen(mesh8(2*i:2*i+1), mesh4(i))
    end do

end program
