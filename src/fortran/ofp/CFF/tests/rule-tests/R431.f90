!! R431 derived-type-stmt
!    is TYPE [ [ , type-attr-spec-list ] :: ] type-name [ ( type-param-name-list ) ]

module DTS

10 TYPE binky
end type

type, abstract, private :: boopy(l,m)
end type boopy

end module
