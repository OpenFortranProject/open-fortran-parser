!
! This file tests for bug 3044538.  The problem is that the lexer can't 
! read integer portion of the edit descriptor 2es16.9 as it isn't a
! proper identifier.  Bug was fixed by adding T_INT_IDENT so the lexer
! didn't fail and FortranLexicalPrepass could replace it with a data
! descriptor.
!
180 format( a35, ' ', ' = ', 2es16.9)
end
