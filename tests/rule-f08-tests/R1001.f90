! Test format-stmt
!      format-stmt  is  FORMAT format-specification
!   
!      format-specification  is  ( [ format-item-list ] )
!
! Not [completely] tested here: format-item-list.
001 format (I12, i1)
002 format (1pe12.4)
003 format (1PE12.4, I10)
004 format (I12 / 'Dates:', 22I3)
005 format (1x, "isn" ''t'', 1x)
006 format(//)
007 format(:)
008 format(:::)
009 format(::)
010 format(I12, /, ' Dates: ', 2 (2I3, I5))
011 format (I12 / 'Dates:', (2I3, I5))
012 format (I12 / 'Dates:', 2(2I3, I5))
013 format (1x, i1, 1x, 'isn''t', 1x, i1)
014 format(1x, 2(f10.3, i5))
015 format (1x, f10.3, i5, f10.3, i5, f10.3, i5)

end

