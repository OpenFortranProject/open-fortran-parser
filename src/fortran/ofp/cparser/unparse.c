#include "OFPFrontEnd.h"

#include <stdio.h>
//#include "OFP_Type.h"
//#include "OFPTokenSource.h"
#include "CFortranParser.h"
#include "Unparser.h"
//#include "support.h"

#define PRINT_TREE   1

pUnparser       ofpUnparserNew  (pANTLR3_COMMON_TREE_NODE_STREAM instream);
pANTLR3_VECTOR  get_tokens      (const char * token_file);

#ifdef NOT_YET
void ofp_mismatch                 (pANTLR3_BASE_RECOGNIZER recognizer, ANTLR3_UINT32 ttype, pANTLR3_BITSET_LIST follow);
void ofp_reportError              (pANTLR3_BASE_RECOGNIZER recognizer);
void ofp_displayRecognitionError  (pANTLR3_BASE_RECOGNIZER recognizer, pANTLR3_UINT8 * tokenNames);
#endif

int main(int argc, char * argv[])
{
   pOFPFrontEnd         parser;
   pANTLR3_BASE_TREE    parser_ast_tree;

   parser = ofpFrontEndNew(argc, argv);

   parser_ast_tree = parser->program(parser);

#ifdef NOT_YET
   parser->pParser->rec->recoverFromMismatchedToken = ofp_mismatch;
   parser->pParser->rec->reportError                = ofp_reportError;
   parser->pParser->rec->displayRecognitionError    = ofp_displayRecognitionError;
#endif

   if (NULL != parser_ast_tree) {

      pANTLR3_COMMON_TREE_NODE_STREAM nodes;
      pUnparser tree_parser;

      FTreeWalker_set_tokens(parser->tlist);

#if PRINT_TREE == 1
      printf("\n");
      printf("Tree : %s\n", parser_ast_tree->toStringTree(parser_ast_tree)->chars);
      printf("\n");
#endif

      nodes = antlr3CommonTreeNodeStreamNewTree(parser_ast_tree, ANTLR3_SIZE_HINT);

      tree_parser = ofpUnparserNew(nodes);
      tree_parser->program_unit(tree_parser);

      nodes       ->free(nodes);          nodes       = NULL;
      tree_parser ->free(tree_parser);    tree_parser = NULL;

   }

   parser->free(parser);                  parser = NULL;

   return 0;
}

pUnparser ofpUnparserNew (pANTLR3_COMMON_TREE_NODE_STREAM instream)
{
   pOFP_TYPE_TABLE type_table = ofpTypeTableNew();
   ofpPushTypeTable(type_table);

   return UnparserNew(instream);
}
