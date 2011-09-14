subroutine copy_char_array(cmdname, array)
   implicit none
   integer, parameter :: nchar = 16
   character(*),  intent(in) :: cmdname
   character(nchar), intent(inout) :: array(1)

   character :: val_array(nchar)
   integer   :: c

   print *, cmdname
   print *, array(1)

   do c = 1, nchar
      val_array(c) = array(1)(c:c)
   enddo
   print *, val_array

   do c = 1, nchar
! this line causes problems with ROSE      
      array(1)(c:c) = val_array(c)
   enddo

end subroutine


program test_char_array
   integer, parameter :: nchar = 16
   character(nchar) :: array(1) = "1234567890123456"
   character(5) :: cmdname = "HELLO"

   call copy_char_array(cmdname, array)

   print *, cmdname
   print *, array(1)

end program




