!! R1228 function-stmt
!    is   [ prefix ] FUNCTION function-name
!                ( [ dummy-arg-name-list ] ) [ suffix ]

11 FUNCTION foo()
END FUNCTION
FUNCTION boo(a,b)
END FUNCTION
INTEGER FUNCTION coo()
END FUNCTION
FUNCTION doo() BIND(C)
END FUNCTION
END
