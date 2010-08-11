!
! Test char_selector (R424), length-selector (R421), and char-length (R422)
!
! R420-08   char-selector                is length-selector
!                                        or (LEN = type-param-value ,
!                                            KIND = scalar-int-initialization-expr)
!                                        or (type-param-value ,
!                                            [KIND = ] scalar-int-initialization-expr)
!                                        or (KIND = scalar-int-initialization-expr
!                                            [, LEN = type-param-value])
!
!R421-08   length-selector               is ( [LEN =] type-param-value )
!                                        or * char-length [ , ]
!
!R422-08   char-length                   is ( type-param-value )
!                                        or scalar-int-literal-constant
!
subroutine char_selector(str4, str7, str10, str13, str16, str19, str22, str26)

   character*10  :: str1      ! length-selector * char-length : int-literal-constant
   character*10, :: str2

   character*(10) :: str3     ! length-selector * char-length
   character*(*)  :: str4 
   character*(:)  :: str5

   character*(10), :: str6     ! length-selector * char-length with comma
   character*(*),  :: str7 
   character*(:),  :: str8

   character(10) :: str9
   character(*)  :: str10
   character(:)  :: str11

   character(10,1) :: str12
   character(*, 1) :: str13
   character(:, 1) :: str14

   character(10,KIND=1) :: str15
   character(*, KIND=1) :: str16
   character(:, kind=1) :: str17

   character(LEN=10) :: str18  ! length-selector : type-param-value with LEN
   character(LEN=*)  :: str19
   character(LEN=:)  :: str20

   character(LEN=10,KIND=1) :: str21
   character(LEN=*, KIND=1) :: str22
   character(LEN=:, kind=1) :: str23

   character(KIND=1) :: str24

   character(KIND=1,len=10) :: str25
   character(KIND=1,LEN=*)  :: str26
   character(KIND=1,LEN=:)  :: str27

   allocatable :: str5, str8, str11, str14, str17, str20, str23, str27

end subroutine
