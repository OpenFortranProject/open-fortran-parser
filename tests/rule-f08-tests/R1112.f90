
! Testing only list
module mymodule2
 integer :: this
 integer :: that
 integer :: theother
end module mymodule2

use mymodule2 , only : this, that, theother
end
