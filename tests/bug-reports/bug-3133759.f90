!
! bug #3133759
!
! The bug is that the character type-spec in the array constructor
! is parsed as a derived-type-spec and not an intrinsic-type-spec.
!
integer :: a, b
a = 1
b = 3

print *, [character(len=2) :: 'a', 'bb']
print *, a, b
print "(i1, i1)", a, b
100 format(i1, i1)
end
