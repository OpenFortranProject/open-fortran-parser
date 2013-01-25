!! R455 binding-attr
!    is PASS [ (arg-name ) ]
!    or NOPASS
!    or NON OVERRIDABLE
!    or DEFERRED
!    or access-spec
!
type truth
contains
	procedure, nopass, deferred :: foo
 	procedure, private, nopass :: beauty
 	procedure, non_overridable :: ugly
 	procedure, pass :: lies
 	procedure, pass (woohoo) :: bar
 	procedure, public :: that
 	procedure, private :: theother
end type truth
end
