subroutine char_selector(str2, str5, str8)

!   character(10) :: str1
!   character(*)  :: str2
!   character(:)  :: str3      ! works with ifort

   character(LEN=10) :: str4  ! length-selector : type-param-value with LEN
!   character(LEN=*)  :: str5
!   character(LEN=:)  :: str6  ! works with ifort

!   character*(10) :: str7     ! length-selector * char-length
!   character*(*)  :: str8 
!   character*(:)  :: str9

!   character*(10), :: str10   ! length-selector * char-length : type-param-value with comma
!   character*(*),  :: str11
!   character*(:),  :: str12

!   allocatable :: str3, str6, str12

!   character*10  :: str13      ! length-selector * char-length : int-literal-constant
!   character*10, :: str14
!
! the rest have two values in comma separated list, e.g., (LEN=10,KIND=1)
!
!   character(LEN=10,KIND=1) :: str15

!   character(10,1) :: str16
!   character(10,KIND=1) :: str17

!   character(KIND=1) :: str18
!   character(KIND=1,LEN=10) :: str19

end subroutine
