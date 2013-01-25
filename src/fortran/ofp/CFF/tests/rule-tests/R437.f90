!! R437 type-param-decl
!    is type-param-name [ = scalar-int-initialization-expr ]

!TODO-F08 TYPE big_deal(k, d)
!TODO-F08   INTEGER, KIND :: k = kind(0.0), d = 13
!TODO-F08 end type

!! following are old tests (not sure what they test)
!
type :: foo(xx, yy)
end type
type, extends(foo) :: bar(zz)
end type
end
