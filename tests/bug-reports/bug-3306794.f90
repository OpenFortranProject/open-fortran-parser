!
! A format statement containing a repetition group where the
! group begins with a '/' causes ofp to freeze.  Tested with
! latest version from git repository.  Reported by rlander.
!
program test_format_freeze
10 FORMAT(3(/))
end
