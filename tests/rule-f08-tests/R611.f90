! Kyle - add a section-subscript-list to one of the tests

type mytype
   integer :: b
end type mytype

integer :: lhs
type(mytype) :: a

!lhs = a
lhs = a%b
!lhs = a%b%c
end
