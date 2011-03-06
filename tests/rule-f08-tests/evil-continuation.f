C
* Tests continuation for fixed format.  No rule number
! as continuation is not officially part of the grammar (lexer issue)
c
100   format (1h1,58x,1h!,/,60x,/,59x,1h*,/)

200   format (1h1,58x,2h!)
     &)

      end
