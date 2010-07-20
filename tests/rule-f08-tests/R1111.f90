
! Testing rename list

module mymodule
   integer :: that
   integer :: bar 
   integer :: beauty
end module mymodule


use mymodule , this=>that, foo=>bar, truth => beauty
end
