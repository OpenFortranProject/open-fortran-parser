!
! The parser should report only -> hasRename=true
!
! Test symbol handling with use statement.
!
module TEST
    integer i
    integer j
end module

use TEST, only : x => i
i = 0
x = 1
END
