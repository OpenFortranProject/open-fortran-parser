!
! This bug occurred because all of the keyword tokens inside the
! array constructors were converted to identifiers.  Fixed by explicitly
! looking for array constructors in a type declaration.
!
type t
! This works...
! character (5) :: Xarray (7)

! This fails...
character (1) :: arr (2) = (/ character(len=2) :: "a", "ab" /), arr1(1) = [character(1) :: "a"]
end type t
end
