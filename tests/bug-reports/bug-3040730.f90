! This bug was reported by Rice.  The output of parser actions led to ROSE
! interpreting unary operators incorrectly.  To see if this file runs
! correctly, the output should be checked so that the signed_operand is
! called

   i = -j + k
end
