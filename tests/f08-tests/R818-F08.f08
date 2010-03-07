! from NOTE 8.10
!   DO CONCURRENT (I = 1:N)
!   DO CONCURRENT ( )
!   DO CONCURRENT ( )
!      A(I) = B(I)
!   END DO

do CONCURRENT (x > 2)
   x = 1
end do

end
