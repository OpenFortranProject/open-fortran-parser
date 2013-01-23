!! R1222 actual-arg-spec
!    is [ keyword = ] actual-arg

a = foo(keyword=.not.B)
a = foo(keyword = b)
a = foo(keyword = udt%bar)
!TODO-F08 a = foo(keyword=*10)

!TODO-F08 a = foo(1)(keyword=.not.B)
!TODO-F08 a = foo(1)(keyword = b)
!TODO-F08 a = foo(1)(keyword = udt%bar)
!TODO-F08 a = foo(1)(keyword=*10)

END
