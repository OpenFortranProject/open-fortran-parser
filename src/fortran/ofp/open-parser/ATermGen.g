///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//  ATermGen.g - grammar extensions for unparsing                            //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

tree grammar ATermGen;

options {
   language       = C;
   tokenVocab     = FortranParser;
   output         = AST;
   ASTLabelType   = pANTLR3_BASE_TREE;
}

import FTreeWalker;

@header {
#include <aterm1.h>
#include "ofpbase.h"
#include "traversal.h"
}

@members {

FILE * out;

extern      pANTLR3_VECTOR      tlist;
extern      ANTLR3_MARKER       next_token;


void
ofpATermGen_setOutStream(FILE * fp)
{
   out = fp;
}

static int
ofplist_count(pANTLR3_BASE_TREE ofpList)
{
   return ofpList->getChildCount(ofpList);
}

static void
print_token_text(pANTLR3_COMMON_TOKEN tok)
   {
      if (tok->getType(tok) == T_EOS) {
         printf("\n");
      }
      else {
         printf("\%s", tok->getText(tok)->chars);
      }
   }

static ATerm
ofp_annotate_start_stop(ATerm term, pANTLR3_BASE_TREE tree)
{
   pOFP_BASE_RTN pos = (pOFP_BASE_RTN) tree->u;
   if (pos != NULL && pos->start != NULL && pos->stop != NULL) {
      ATerm start = ATmake("start");
      ATerm stop  = ATmake("stop");
      term = ATsetAnnotation(term, stop,  ATmake("<int>", pos->stop ->index));
      term = ATsetAnnotation(term, start, ATmake("<int>", pos->start->index));
   }
   return term;
}

static ATerm
aterm_opt_str(pANTLR3_BASE_TREE tree, const char * term_name)
{
   int len = strlen(term_name) + strlen("(<str>)");
   char * pattern = (char *) malloc(1+len);

   ATerm aterm;
   if (tree->getChildCount(tree) > 0) {
      pANTLR3_BASE_TREE tname = tree->getChild(tree,0);
      sprintf(pattern, "\%s(<str>)", term_name);
      aterm = ATmake(pattern, tname->getText(tname)->chars);
      aterm = ofp_annotate_start_stop(aterm, tree);
   }
   else {
      sprintf(pattern, "\%s()", term_name);
      aterm = ATmake(pattern);
   }
   free(pattern);

   return aterm;
}

static ATerm
aterm_opt_term(pANTLR3_BASE_TREE tree, const char * term_name)
{
   int len = strlen(term_name) + strlen("(<term>)");
   char * pattern = (char *) malloc(1+len);

   ATerm aterm;
   if (tree->getChildCount(tree) > 0) {
      /* WARNING, this is a hack, assumes all tree types are a main_program 
       * Assumes all tree types return an ATerm as first return parameter.
       */
      ATermGen_main_program_return * t = tree->getChild(tree,0);
      sprintf(pattern, "\%s(<term>)", term_name);
      aterm = ATmake(pattern, t->aterm);
   }
   else {
      sprintf(pattern, "\%s()", term_name);
      aterm = ATmake(pattern);
   }
   free(pattern);

   return aterm;
}

static ANTLR3_MARKER
unparseTokens(ANTLR3_MARKER start, ANTLR3_MARKER stop)
   {
      int i;

      stop = (stop < tlist->count) ? stop : tlist->count - 1;

      for (i = start; i <= stop; i++) {
         print_token_text((pANTLR3_COMMON_TOKEN) tlist->get(tlist, i));
      }
      return (stop + 1);
   }

static ANTLR3_MARKER
unparse(pANTLR3_BASE_TREE btn, ANTLR3_MARKER next)
   {
      pANTLR3_COMMON_TREE  ctn;
      pANTLR3_STRING       str;

      if (btn->isNilNode(btn)) {
         printf("unparse: node is nil\n");
         return;
      }
      if (btn->getType(btn) == ANTLR3_TOKEN_DOWN || btn->getType(btn) == ANTLR3_TOKEN_UP) {
         printf("unparse: transition node type \%d found\n", btn->getType(btn));
         return;
      }

      ctn = (pANTLR3_COMMON_TREE) btn->super;
      str = btn->toString(btn);

      // unparse any preceeding whitespace
      //
      if (next < ctn->startIndex) {
         unparseTokens(next, ctn->startIndex - 1);
      }
      return unparseTokens(ctn->startIndex, ctn->stopIndex);
   }

static void
unparse_label(FILE * fp, pANTLR3_BASE_TREE ofpLabel)
{
   ATerm t;
   if (ofpLabel->getChildCount(ofpLabel) > 0) {
      pANTLR3_BASE_TREE label = ofpLabel->getChild(ofpLabel, 0);
      fprintf(fp, "label = OFPLabel(\%s)\n", label->getText(label)->chars);
      t = ATmake("label(<int>)", atoi(label->getText(label)->chars));
      ATprintf("\%t\n", t);
   }
   else {
      t = ATmake("label()");
      fprintf(fp, "label = OFPLabel(None)\n");
   }
}

static void
unparse_OFPName(FILE * fp, pANTLR3_BASE_TREE ofpname, const char * sep)
{
   if (ofpname->getChildCount(ofpname) > 0) {
      pANTLR3_BASE_TREE   name = ofpname->getChild(ofpname, 0);
      fprintf(fp, "\%s\%s", name->getText(name)->chars, sep);
   }
}

static void
unparse_entity_decl_list(FILE * fp, pANTLR3_BASE_TREE ofpList)
{
// entity_decl
//   :   T_IDENT ( T_LPAREN array_spec T_RPAREN  )?
//               ( T_LBRACKET coarray_spec T_RBRACKET  )?
//               ( T_ASTERISK char_length  )?
//               ( initialization  )?
//
//   :   ^(SgInitializedName T_IDENT array_spec?)

   int i, count;

   count = ofplist_count(ofpList);
   for (i = 0; i < count; i++) {
      pANTLR3_BASE_TREE   sgname = ofpList->getChild(ofpList, i);
      if (i < count-1) {
         unparse_OFPName(out, sgname, ", ");
      }
      else {
         unparse_OFPName(out, sgname, "");
      }
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

static void
unparse_name(FILE * fp, pANTLR3_BASE_TREE tree, const char * node_name, const char * node_type)
{
   char * name = "None";

   if (tree != NULL && tree->getChildCount(tree) > 0) {
      pANTLR3_BASE_TREE tname = tree->getChild(tree, 0);
      name = tname->getText(tname)->chars;
   }

   fprintf(fp, "\%s = \%s(\"\%s\")\n", node_name, node_type, name);
}

/**
 * unparse_comments
 */
static void
unparse_comments(FILE * fp, pANTLR3_BASE_TREE tree)
{
   int i;

   fprintf(fp, "comments = []\n");

   for (i = 0; i < tree->getChildCount(tree); i++) {
      pANTLR3_BASE_TREE text = tree->getChild(tree, i);
      fprintf(fp, "comments.append(\%s)\n", text->getText(text)->chars);
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

opt_label returns [ATerm aterm]
   :  ^(OFPLabel lbl=T_DIGIT_STRING?)
           {
              if ($OFPLabel->getChildCount($OFPLabel) > 0) {
                 retval.aterm = ATmake("label(<int>)", atoi(lbl->getText(lbl)->chars));
              } else {
                 retval.aterm = ATmake("label()");
              }
              retval.aterm = ofp_annotate_start_stop(retval.aterm, $OFPLabel);
           }
   ;


/**
 * Section/Clause 4: Types
 */


//========================================================================================
// R404-F08 intrinsic-type-spec
//----------------------------------------------------------------------------------------
intrinsic_type_spec
   :   ^( SgTypeInt    {fprintf(out,"Integer");}   kind_selector? )  {fprintf(out, " :: ");}
   |   ^( SgTypeFloat  {fprintf(out,"Real"   );}   kind_selector? )  {fprintf(out, " :: ");}
   |      SgTypeDouble
   |   ^( SgTypeComplex   kind_selector? )
   |      SgTypeDComplex                      // TODO - what is the real SgType?
   |   ^( SgTypeChar      char_selector? )
   |   ^( SgTypeBool      kind_selector? )
   ;


/**
 * Section/Clause 5: Attribute declarations and specifications
 */


//========================================================================================
// R501-F08 type-declaration-stmt
//----------------------------------------------------------------------------------------
type_declaration_stmt
   :   ^(SgVariableDeclaration ^(OFPLabel label?)
          declaration_type_spec
          ^(OFPAttrSpec attr_spec*  )
          ^(OFPList entity_decl+)
        )
           {
              unparse_entity_decl_list(out, $OFPList);
              fprintf(out, "\n");
           }
   ;

//========================================================================================
// R560-F08 implicit-stmt
//----------------------------------------------------------------------------------------
implicit_stmt
   :   // implicit none if OFPList is empty
       ^(SgImplicitStatement ofplabel ^(OFPList implicit_spec*))
           {
              fprintf(out, "Implicit None");
              fprintf(out, "\n");
           }
   ;

//========================================================================================
// R1101-F08 main-program
//----------------------------------------------------------------------------------------
main_program returns [ATerm aterm]
   :   ^(OFPMainProgram
           program_stmt
              ^(OFPSpecificationPart       specification_part?       )
              ^(OFPExecutionPart           execution_part?           )
              ^(OFPInternalSubprogramPart  internal_subprogram_part? )
           end_program_stmt
        )

        {
           ATerm at_program_stmt;
           ATerm at_specification_part = ATmake("specification-part()");
           ATerm at_exe_part           = ATmake("execution-part()");
           ATerm at_int_sub_part       = ATmake("internal-subprogram-part()");
           if ($program_stmt.tree->getChildCount($program_stmt.tree) > 0) {
                  at_program_stmt = $program_stmt.aterm;
           } else at_program_stmt = ATmake("program-stmt()");
           //if ($OFPSpecificationPart->getChildCount($OFPSpecificationPart) > 0) {
           //} else at_specification_part = ATmake("specification-part()");

           retval.aterm = ATmake("main-program(<term>,<term>,<term>,<term>,<term>)",
                                  at_program_stmt,
                                  at_specification_part,
                                  at_exe_part,
                                  at_int_sub_part,
                                  $end_program_stmt.aterm);
           retval.aterm = ofp_annotate_start_stop(retval.aterm, $OFPMainProgram);
           ATprintf("\%t\n\n", retval.aterm);

           ofp_traverse_main_program(retval.aterm);
           printf("\n");
        }
   ;


//========================================================================================
// R1102-F08 program-stmt
//----------------------------------------------------------------------------------------
program_stmt returns [ATerm aterm]
   :  ^(OFPProgramStmt opt_label
          ^(OFPProgramName T_IDENT)
       )

       {
          ATerm name = aterm_opt_str($OFPProgramName, "program-name");
          retval.aterm = ATmake("program-stmt(<term>, <term>)", $opt_label.aterm, name);
          retval.aterm = ofp_annotate_start_stop(retval.aterm, $OFPProgramStmt);
       }
   ;


//========================================================================================
// R1103-F08 end-program-stmt
//----------------------------------------------------------------------------------------
end_program_stmt returns [ATerm aterm]
   :  ^(OFPEndProgramStmt opt_label
          ^(OFPProgramName T_IDENT?)
       )

       {
          ATerm name = aterm_opt_str($OFPProgramName, "program-name");
          retval.aterm = ATmake("end-program-stmt(<term>, <term>)", $opt_label.aterm, name);
          retval.aterm = ofp_annotate_start_stop(retval.aterm, $OFPEndProgramStmt);
       }
   ;


//========================================================================================
// R1104-F08 module
//----------------------------------------------------------------------------------------
module
   :  ^(OFPModule module_stmt
          ^(SgBasicBlock
              specification_part
          // TODO - ( module_subprogram_part )?
           )
           end_module_stmt
       )
          {
             fprintf(out, "module = ast.module(module_stmt, end_module_stmt)\n");
          }
   ;

//========================================================================================
// R1105-F08 module-stmt
//----------------------------------------------------------------------------------------
module_stmt
   :  ^(OFPModuleStmt  ofplabel  ^(OFPModuleName T_IDENT) )
          {
             fprintf(out, "module_stmt = ast.module_stmt(label, module_name)\n");
          }
   ;


//========================================================================================
// R1106-F08 end-program-stmt
//----------------------------------------------------------------------------------------
end_module_stmt
   :  ^(OFPEndModuleStmt  ^(OFPLabel label?)  ^(OFPModuleName T_IDENT?) )
          {
             fprintf(out, "end_module_stmt = ast.end_module_stmt(label, module_name)\n");
          }
   ;


//========================================================================================
// R1234-F08 subroutine-stmt
//----------------------------------------------------------------------------------------
subroutine_stmt
   :   ^(OFPBeginStmt ofplabel        T_IDENT                      )
       ^(SgInitializedName            subroutine_name              )
       ^(SgFunctionParameterList      dummy_arg *                  )
       ^(OFPPrefixList                t_prefix ?                   )
       ^(OFPSuffix                    proc_language_binding_spec ? )

          {
             fprintf(out, "Subroutine ");
             unparse_OFPName(out, $SgInitializedName, " ");
             fprintf(out, "\n");
          }
   ;

subroutine_name
   :   T_IDENT
   ;

//========================================================================================
// R1236-F08 end-subroutine-stmt
//----------------------------------------------------------------------------------------
end_subroutine_stmt
   :   ^(OFPEndStmt ofplabel T_IDENT?)
          {
             fprintf(out, "End Subroutine ");
             unparse_token(out, $T_IDENT);
             fprintf(out, "\n");
          }
   ;
