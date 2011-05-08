!
! It appears that the problem is in the parser on "character*6".  
! The parser seems to do ok on character(6).
!
module sky_11_45
  public :: sphere

contains

  ! This statement does not parse well with OFP.
  character*6 function sphere ( miles ) result ( zone )
    real, intent(IN) :: miles
  end function sphere

end module sky_11_45
