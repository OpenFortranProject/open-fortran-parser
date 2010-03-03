! from NOTE 4.30
   TYPE GRID_TYPE 
      REAL, ALLOCATABLE, CODIMENSION[:,:,:] :: GRID1(:,:,:) 
      real, ALLOCATABLE :: GRID2(:,:,:)[:,:,:]
   END TYPE GRID_TYPE 
end
