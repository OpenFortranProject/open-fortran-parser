! Test data-edit-desc
!      data-edit-desc  is  Iw[.m]
!                      or  Bw[.m]
!                      or  Ow[.m]
!                      or  Zw[.m]
!                      or  Fw.d
!                      or  Ew.d[Ee]
!                      or  ENw.d[Ee]
!                      or  ESw.d[Ee]
!                      or  Gw.d[Ee]
!                      or  Lw
!                      or  A[w]
!                      or  Dw.d
!                      or  DT[char-literal-constant][(v-list)]
!
!      w  is  int-literal-constant
!      m  is  int-literal-constant
!      d  is  int-literal-constant
!      e  is  int-literal-constant
!      v  is  signed-int-literal-constant
!
! Tested as part of a format-stmt.
001 format(i1)
002 format(i1.2)
003 format(B1)
004 format(B1.2)
005 format(O1)
006 format(O1.2)
007 format(Z1)
008 format(Z1.2)
009 format(F1.2)
010 format(E1.2)
011 format(E1.2E2)
012 format(EN1.2)
013 format(EN1.2E3)
014 format(ES1.2)
015 format(ES1.2E3)
016 format(G1.2)
017 format(G1.2E3)
018 format(L1)
019 format(A)
020 format(A1)
021 format(D1.2)
022 format(DT'hello')
023 format(DT'hello'(10))

end

