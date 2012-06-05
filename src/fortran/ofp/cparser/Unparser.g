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

@members {
  FILE * out;

void
ofpUnparser_setOutStream(FILE * fp)
{
   out = fp;
}

static void
unparse_label(FILE * fp, pANTLR3_BASE_TREE tree)
{
   if (tree == NULL) return;
   pANTLR3_COMMON_TOKEN label = tree->getToken(tree);
   fprintf(fp, "\%s ", label->getText(label)->chars);
}

static void
unparse_token(FILE * fp, pANTLR3_BASE_TREE tree)
{
   if (tree == NULL) return;

   pANTLR3_COMMON_TOKEN tok = tree->getToken(tree);
   if (tok->getType(tok) == T_EOS) {
      fprintf(fp, "\n");
   }
   else {
      fprintf(fp, "\%s", tok->getText(tok)->chars);
   }
}

} // end members


// R560-F08
implicit_stmt
@after
      {
           printf("implicit_stmt rule: implicit none statement found\n");
      }
   :   // implicit none if OFPList is empty
       ^(SgImplicitStatement ^(OFPLabel label?) ^(OFPList implicit_spec*))
   ;


//========================================================================================
// R1102-F08 program-stmt
//----------------------------------------------------------------------------------------
program_stmt
   :  ^(OFPBeginStmt ^(OFPLabel label?) T_IDENT)
          {
             unparse_label(out, $label.tree);
             fprintf(out, "Program ");
             unparse_token(out, $T_IDENT);
             fprintf(out, "\n");
          }
   ;


//========================================================================================
// R1103-F08 end-program-stmt
//----------------------------------------------------------------------------------------
end_program_stmt
   :  ^(OFPEndStmt ^(OFPLabel label?) T_IDENT?)
          {
             unparse_label(out, $label.tree);
             fprintf(out, "End Program ");
             unparse_token(out, $T_IDENT);
             fprintf(out, "\n");
          }
   ;
