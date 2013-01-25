!! R455 binding-attr
!    is PASS [ (arg-name ) ]
!    or NOPASS
!    or NON OVERRIDABLE
!    or DEFERRED
!    or access-spec
!
type truth
!TODO-F08 contains
!TODO-F08 	procedure, nopass, deferred :: foo
!TODO-F08 	procedure, private, nopass :: beauty
!TODO-F08 	procedure, non_overridable :: ugly
!TODO-F08 	procedure, pass :: lies
!TODO-F08 	procedure, pass (woohoo) :: bar
!TODO-F08 	procedure, public :: that
!TODO-F08 	procedure, private :: theother
end type truth
end
