!! R1234 subroutine-stmt
!    is [ prefix ] SUBROUTINE subroutine-name
!           [ ( [ dummy-arg-list ] ) [ proc-language-binding-spec ] ]

11 SUBROUTINE foo
END SUBROUTINE
SUBROUTINE boo(a,b)
END SUBROUTINE
PURE SUBROUTINE coo()
END SUBROUTINE
SUBROUTINE doo() BIND(C)
END SUBROUTINE
END
