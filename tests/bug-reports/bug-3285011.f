      character(1) :: class
      double precision :: dtref
c bug causes the lexer to fail on the comment below
      class = 'W'  !SPEC95fp size
      dtref = 1.5d-3
      end
