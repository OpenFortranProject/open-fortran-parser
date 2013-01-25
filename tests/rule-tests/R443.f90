!! R443 component-decl
!    is component-name [ ( component-array-spec ) ] [ lbracket co-array-spec rbracket ]
!                      [ * char-length ] [ component-initialization ]
!
type nasty
	integer truth, beauty, ugly, lies
	real foo(3,4,5:9), bar[:]
	integer this*35, that =4;
	real ridiculous(5,6)[:]*12=>theother()
end type
end
