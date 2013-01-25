!! R442 component-attr-spec
!    is access-spec
!    or ALLOCATABLE
!    or DIMENSION ( component-array-spec )
!    or DIMENSION [ ( deferred-shape-spec-list ) ]
!    lbracket co-array-spec rbracket
!    or CONTIGUOUS or POINTER
!
type woohoo
!TODO-F08     integer, pointer, codimension[:] ::bar 
    integer, pointer, dimension(:) :: ugly
    real, pointer :: lies1
    real, allocatable :: lies2(:,:)
    real, pointer, private :: foo
    integer, allocatable ::this(:)
    integer, allocatable, private :: that
end type
end
