!! R1214 proc-decl
!       is procedure-entity-name [ => proc-pointer-init ]

! Testing proc decl list.
PROCEDURE () foo
PROCEDURE () truth, beauty, ugly, lies
!TODO-F08 proc-pointer-init
END
