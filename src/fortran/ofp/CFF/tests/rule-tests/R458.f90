!! R458 type-param-spec
!   is [ keyword = ] type-param-value
!

Module TPS

type param1(k)
!TODO-F08   INTEGER, KIND :: k
END TYPE
type param2(k1,k2)
!TODO-F08   INTEGER, KIND :: k1, k2
END TYPE

!TODO-F08 type(param1(4))   :: beauty
!TODO-F08 type(param2(4,8)) :: beast
!TODO-F08 type(ugly(dim=a)) :: lies
!TODO-F08 type(this(3,4,that=5)) :: theother

end module
