!
! Format statement strings containing single apostrophes fails to parse.
!
program test_format_strings
100 FORMAT ('"')
200 FORMAT ("""")
    print 100
    print 200
    print *, '"'
    print *, """"
end program
