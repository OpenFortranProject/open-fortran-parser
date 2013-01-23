!! R1222 actual-arg-spec
!    is [ keyword = ] actual-arg

a = foo(1)(keyword=.not.B)
a = foo(1)(keyword = b)
a = foo(1)(keyword = udt%bar)
a = foo(1)(keyword=*10)

END
