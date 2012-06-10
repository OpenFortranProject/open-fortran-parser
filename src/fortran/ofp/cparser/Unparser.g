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
unparse_label(FILE * fp, pANTLR3_BASE_TREE ofpLabel)
{
   if (ofpLabel->getChildCount(ofpLabel) > 0) {
      pANTLR3_BASE_TREE   label = ofpLabel->getChild(ofpLabel, 0);
      fprintf(fp, "\%s ", label->getText(label)->chars);
   }
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

/**
 * unparse_begin_stmt -> ^(OFPBeginStmt ^(OFPLable label?) name?)
 */
static void
unparse_begin_stmt(FILE * fp, pANTLR3_BASE_TREE tree, const char * text)
{
   unparse_label(fp, tree->getChild(tree,0));
   fprintf(fp, "\%s ", text);

   if (tree->getChildCount(tree) > 1) {
      pANTLR3_BASE_TREE   name = tree->getChild(tree, 1);
      fprintf(fp, "\%s", name->getText(name)->chars);
   }
   fprintf(fp, "\n");
}

/**
 * unparse_end_stmt -> ^(OFPEndStmt ^(OFPLable label?) name?)
 */
static void
unparse_end_stmt(FILE * fp, pANTLR3_BASE_TREE tree, const char * text)
{
   pANTLR3_BASE_TREE name = tree->getChild(tree,1);

   unparse_label(fp, tree->getChild(tree,0));

   fprintf(fp, "End \%s \%s\n", text, name->getText(name)->chars);
}

} // end members


//========================================================================================
// R560-F08 implicit-stmt
//----------------------------------------------------------------------------------------
implicit_stmt
   :   // implicit none if OFPList is empty
       ^(SgImplicitStatement ^(OFPLabel label?) ^(OFPList implicit_spec*))
          {
             //unparse_label(out, $label.tree);
             fprintf(out, "Implicit None");
             fprintf(out, "\n");
          }
   ;


//========================================================================================
// R1101-F08 main-program
//----------------------------------------------------------------------------------------
main_program
   :   ^(SgProgramHeaderStatement program_stmt? end_program_stmt
                    {
                       unparse_begin_stmt(out, $program_stmt.tree, "Program");
                    }
          ^(SgFunctionDefinition 
               ^(SgBasicBlock
                  ^(OFPSpecificationPart       specification_part          )
                )
            )
                    {
                       unparse_end_stmt(out, $end_program_stmt.tree, "Program");
                    }
        )
   ;


//========================================================================================
// R1102-F08 program-stmt
//----------------------------------------------------------------------------------------
program_stmt
   :  ^(OFPBeginStmt ^(OFPLabel label?) T_IDENT)
   ;


//========================================================================================
// R1103-F08 end-program-stmt
//----------------------------------------------------------------------------------------
end_program_stmt
   :  ^(OFPEndStmt ^(OFPLabel label?) T_IDENT?)
   ;


//========================================================================================
// R1234-F08 subroutine-stmt
//----------------------------------------------------------------------------------------
subroutine_stmt
   :   ^(OFPBeginStmt ^(OFPLabel label?) T_IDENT)
          {
             //unparse_label(out, $label.tree);
             fprintf(out, "Subroutine ");
             unparse_token(out, $T_IDENT);
             fprintf(out, "\n");
          }
   ;

//========================================================================================
// R1236-F08 end-subroutine-stmt
//----------------------------------------------------------------------------------------
end_subroutine_stmt
   :   ^(OFPEndStmt ^(OFPLabel label?) T_IDENT?)
          {
             //unparse_label(out, $label.tree);
             fprintf(out, "End Subroutine ");
             unparse_token(out, $T_IDENT);
             fprintf(out, "\n");
          }
   ;
