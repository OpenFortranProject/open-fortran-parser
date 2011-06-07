!
! Bug 3313167.  The problem is that the two function calls were
! essentially being skipped over in conversion to idents.
!
   localCount ( :numDims+1) = (/ len(values(1)), shape(values) /)
end
