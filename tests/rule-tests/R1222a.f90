!! R1222 actual-arg-spec
!    is [ keyword = ] actual-arg

a = foo(keyword=.not.B)
a = foo(keyword = b)
a = foo(keyword = udt%bar)
a = foo(keyword=*10)

END
