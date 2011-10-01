!
! Format statement strings containing single apostrophes fails to parse.
!
program test_format_strings
050 format(' num''ber:')
100 FORMAT ('"')
200 FORMAT ("""")
300 FORMAT ('hellno')
 10200 format(' number of separate'' processes to treat:')
end program

