! R1219 function-reference
!   is procedure-designator ( [ actual-arg-spec-list ] )
a = foo()

!! these are parsed as data-ref
a = foo(1)
a = foo(m)
a = foo(1,2)
END
