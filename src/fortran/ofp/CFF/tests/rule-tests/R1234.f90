!! R1234 subroutine-stmt
!    is [ prefix ] SUBROUTINE subroutine-name
!           [ ( [ dummy-arg-list ] ) [ proc-language-binding-spec ] ]

11 SUBROUTINE foo
END SUBROUTINE
SUBROUTINE boo(a,b)
END SUBROUTINE
!TODO-F08 PURE SUBROUTINE coo()
!TODO-F08 END SUBROUTINE
SUBROUTINE doo() BIND(C)
END SUBROUTINE
END
