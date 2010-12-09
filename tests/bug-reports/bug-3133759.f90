!
! bug #3133759
!
! The bug is that the character type-spec in the array constructor
! is parsed as a derived-type-spec and not an intrinsic-type-spec.
!

!character(2), parameter :: a = 'a'
!character(2), dimension(2) :: list = [a, 'bb']
!
!print *, list
!
print *, [character(len=2) :: 'a', 'bb']
!print *, [a, 'bb']
end
