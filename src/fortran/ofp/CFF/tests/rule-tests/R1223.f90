!! R1223 actual-arg
!    is expr
!    or variable
!    or procedure-name
!    or proc-component-ref
!    or alt-return-spec

a = foo(.not.B)
a = foo(b)
a = foo(udt%bar)
!TODO-F08 a = foo(*10)           ! alt-return-spec

! procedure-name
a = foo(1)(.not.B)
a = foo(1)(b)
a = foo(1)(udt%bar)
!TODO-F08 a = foo(1)(*10)        ! alt-return-spec

END
