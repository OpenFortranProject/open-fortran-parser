///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//  FortranParserOFP.g - grammar extensions for the OFP research effort in   //
//  programming models for Fortran.                                          //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

tree grammar ImplicitNone;

options {
   language       = C;
   tokenVocab     = CFortranParser;
   output         = AST;
   ASTLabelType   = pANTLR3_BASE_TREE;
}

import FTreeWalker;

@header {
   int junk;
}

// R549
implicit_stmt
   :   label? T_IMPLICIT implicit_spec_list end_of_stmt
   |   label? T_IMPLICIT T_NONE end_of_stmt
      {
           printf("implicit_stmt rule: implicit none statement found\m");
      }
   ;

