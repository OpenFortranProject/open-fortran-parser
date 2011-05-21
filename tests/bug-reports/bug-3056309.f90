!
! This is reported as bug 3056328
!
  IF( LSAME( TYPE, 'G' ) ) THEN
     ITYPE = 0
  ELSEIF( LSAME( TYPE, 'L' ) ) THEN
     ITYPE = 1
  ELSE
     ITYPE = -1
  ENDIF
end
