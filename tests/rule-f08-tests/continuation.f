!
C test continued token
  !
      int
     &eger i

* test with blank and comment lines in middle
      int
       ! this is a comment line followed by two blank lines within a continued line
    
 
     1eger j
     0real x

! continue line without splitting tokens
      integer :: 
    
     &               k
     
* test empty continuation lines
     0integer :: l! 'comment immediately before continuation
     1
     2,
     3
     4m

c TODO add TAB continuation tests

! comment will end file (no '\n' before EOF)
      end!
