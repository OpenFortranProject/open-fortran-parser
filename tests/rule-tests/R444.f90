!! R444 component-array-spec
!    is explicit-shape-spec -list
!    or deferred-shape-spec -list
!
type ugly
	real truth(:)
	real beauty(:,:,:,:,:)
    integer foo(2,3,4,a,x)
    real bar(y)
    real lies(8)
end type

end

