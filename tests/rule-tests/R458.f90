!! R458 type-param-spec
!   is [ keyword = ] type-param-value
!

Module TPS

type param1(k)
  INTEGER, KIND :: k
END TYPE
type param2(k1,k2)
  INTEGER, KIND :: k1, k2
END TYPE

type(param1(4))   :: beauty
type(param2(4,8)) :: beast
type(ugly(dim=a)) :: lies
type(this(3,4,that=5)) :: theother

end module
