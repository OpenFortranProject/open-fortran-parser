

! Testing format item list. Ripped off from standard.
! Note that the list must have at least two elements.
! Also, should the second list count as four or six?
10 format (1pe12.4, i10)
20 format (i12, /, ' Dates: ', 2 (2i3, i5))
30 format (i15)
end

