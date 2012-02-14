///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//  Unparser.g - grammar extensions for unparsing                            //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

tree grammar Unparser;

options {
   language       = C;
   tokenVocab     = CFortranParser;
   output         = AST;
   ASTLabelType   = pANTLR3_BASE_TREE;
}

import FTreeWalker;

// R560-F08
implicit_stmt
@after
      {
           printf("implicit_stmt rule: implicit none statement found\n");
      }
   :   // implicit none if OFPList is empty
       ^(SgImplicitStatement ^(OFPList implicit_spec*) label?)
   ;
