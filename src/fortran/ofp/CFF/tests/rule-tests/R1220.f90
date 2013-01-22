!!
! R1220 call-stmt
!    is CALL procedure-designator [ ( [ actual-arg-spec-list ] ) ]
!
CALL foo1
CALL foo2()
CALL foo3(1)
CALL foo4(1,2)
CALL foo5(a)
CALL foo6(keyword=.not.B)
CALL foo7(keyword = b)
CALL foo8(keyword = udt%bar)
CALL foo9(keyword=*10)
END
