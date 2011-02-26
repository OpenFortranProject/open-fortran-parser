! This file tests for the very evil hollerith "1h!" as an edit descriptor.  In
c this case, '!' ... can't be treated as as comment.
  ! (this is also a comment line)
C  
 100     format (1h1,58x,1h!,/,60x,/,59x,1h*,/)
       end
