!! R432 type-attr-spec
!    is ABSTRACT
!    or access-spec
!    or BIND (C)
!    or EXTENDS ( parent-type-name )

type, abstract, extends(truth) :: beauty
end type beauty
type, abstract :: ugly
end type ugly
type, abstract, bind(C) :: lies
end type lies
type, abstract, extends(foo), bind(C) :: bar
end type bar
end
