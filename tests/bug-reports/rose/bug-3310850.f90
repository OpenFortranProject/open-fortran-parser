    module go_dog_go
      implicit none      

      interface bob
        module procedure bob

      end interface

    contains
	integer function bob()	   
	   bob = 1
	end function bob
    end module go_dog_go

