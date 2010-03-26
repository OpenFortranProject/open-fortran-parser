
! Testing component attr spec list
type woohoo
  !
  ! The following lines are probably incorrect (kind, len).  For some
  ! reason Chris thought the grammar should be extended to allow them.
  ! the F2003 grammar is extended to include kind,len and make a comment
  ! about NOTE 4.24.
  !
  ! integer, kind, len :: truth
  ! integer, len :: beauty
  ! integer, len, pointer, dimension[:] ::bar 
    integer, pointer, codimension[:] ::bar 
    integer, pointer, dimension(:) :: ugly
    real, pointer :: lies1
    real, allocatable :: lies2(:,:)
    real, pointer, private :: foo
    integer, allocatable ::this(:)
    integer, allocatable, private :: that
end type
end
