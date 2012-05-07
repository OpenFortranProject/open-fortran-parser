module ASSIGNMENT 

  contains 
  subroutine foo()
    print *, "in foo"
  end subroutine 

end module 

program p 
 use ASSIGNMENT
 call foo()
end program

