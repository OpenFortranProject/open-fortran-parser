!
! This tests R732 assignment-stmt
!
!  assignment-stmt is variable = expr
!
! This file tests assignment statements with keywords for variable and expr
!
   integer :: external(10), subroutine(10,10)
   program = if
   if = goto
   data = program
   external(1) = subroutine(3,3)
end
