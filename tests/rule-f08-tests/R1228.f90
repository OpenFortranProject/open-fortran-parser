! Testing function-stmt, R1228
11 FUNCTION foo()
  foo = 1
end function
function boo(a,b)
   boo = 2
end function
integer function coo()
   coo = 3
end function
!integer(C_INT) function doo() BIND(C)
integer function doo() !BIND(C)
   use, intrinsic :: ISO_C_BINDING
   doo = 1
end function
