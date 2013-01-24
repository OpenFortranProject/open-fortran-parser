!! R405 kind-selector
!    is ( [ KIND = ] scalar-int-initialization-expr )
!
! kind-selector can have an expr so there are too many to test all of them, 
! but we can test some common ones.

INTEGER, PARAMETER :: foo = 8

INTEGER (KIND = 4), PARAMETER :: i = 4
INTEGER (KIND = 4) :: p
INTEGER (KIND = foo) :: bar
INTEGER(8) :: j
INTEGER(KIND(4)) :: k
INTEGER(KIND=i) :: m
INTEGER(KIND(j)) :: n
INTEGER(i) :: o
INTEGER(SELECTED_INT_KIND(12)) :: d
REAL * 4 :: q

END
