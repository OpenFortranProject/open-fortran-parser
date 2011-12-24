tree grammar FTreeWalker;

options {
   language       = C;
   tokenVocab     = FortranLexer;
   ASTLabelType   = pANTLR3_BASE_TREE;
}

main_program
   :   ^(SgProgramHeaderStatement program_stmt end_program_stmt)
   ;

program_stmt
   :   T_IDENT
          {
             printf("PROGRAM \%s\n", $T_IDENT->getText($T_IDENT)->chars);
          }
   ;

end_program_stmt
   :  T_IDENT
          {
             printf("END PROGRAM \%s\n", $T_IDENT->getText($T_IDENT)->chars);
          }
   ;
