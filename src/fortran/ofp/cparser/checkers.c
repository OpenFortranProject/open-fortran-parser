#include <stdio.h>
#include "OFP_Type.h"
#include "OFPTokenSource.h"
#include "CFortranParser.h"
#include "ImplicitNone.h"
#include "support.h"

#define PRINT_TOKENS 0
#define PRINT_TREE   0

pImplicitNone    OFPImplicitNoneNew  (pANTLR3_COMMON_TREE_NODE_STREAM instream);
pANTLR3_VECTOR   get_tokens          (const char * token_file);

int main(int argc, char * argv[])
{
   int i;

   pANTLR3_VECTOR                 tlist;
   pANTLR3_TOKEN_SOURCE           tsource;
   pANTLR3_COMMON_TOKEN_STREAM    tstream;
   pCFortranParser                parser;

   pANTLR3_BASE_TREE parser_ast_tree;
   
   char * tok_file = argv[1];
   char * src_file = argv[2];

   if (argc < 3) {
      printf("usage: unparse token_file src_file\n");
      exit(1);
   }

   /* Lexer phase
    *    - Call the token parser to read the tokens from the token file.
    */

   tlist = get_tokens(tok_file);

   /* print tokens
    */
#if PRINT_TOKENS == 1
   for (i = 0; i < tlist->size(tlist); i++) {
      //print_token_text((pANTLR3_COMMON_TOKEN) tlist->get(tlist, i));
      print_token((pANTLR3_COMMON_TOKEN) tlist->get(tlist, i));
   }
   printf("\n");
#endif

   /* Parser phase
    *    - Call the parser with the token source which uses the token
    *      list obtained from the token file.
    */

   tsource  =  ofpTokenSourceNew                 ( (pANTLR3_UINT8) src_file, tlist );
   tstream  =  antlr3CommonTokenStreamSourceNew  ( ANTLR3_SIZE_HINT, tsource );
   parser   = CFortranParserNew                  ( tstream );

   //   parser_ast_tree = parser->main_program(parser).tree;
   parser_ast_tree = parser->subroutine_subprogram(parser).tree;

   if (parser->pParser->rec->state->errorCount > 0)
   {
      fprintf(stderr, "The parser returned %d errors, tree walking aborted.\n", parser->pParser->rec->state->errorCount);
   }
   else
   {
      pANTLR3_COMMON_TREE_NODE_STREAM nodes;
      pImplicitNone tree_parser;

      FTreeWalker_set_tokens(tlist);

#if PRINT_TREE == 1
      printf("\n");
      printf("Tree : %s\n", main_ast.tree->toStringTree(main_ast.tree)->chars);
      printf("\n");
#endif

      nodes = antlr3CommonTreeNodeStreamNewTree(parser_ast_tree, ANTLR3_SIZE_HINT);

      tree_parser = OFPImplicitNoneNew(nodes);
      //      tree_parser->main_program(tree_parser);
      tree_parser->subroutine_subprogram(tree_parser);

      nodes       ->free(nodes);          nodes       = NULL;
      tree_parser ->free(tree_parser);    tree_parser = NULL;
   }

   parser  ->free(parser);                parser      = NULL;
   tstream ->free(tstream);               tstream     = NULL;
   // TODO tsource ->free(tsource);               tsource     = NULL;

   return 0;
}

pImplicitNone OFPImplicitNoneNew (pANTLR3_COMMON_TREE_NODE_STREAM instream)
{
   pOFP_TYPE_TABLE type_table = ofpTypeTableNew();
   ofpPushTypeTable(type_table);

   return ImplicitNoneNew(instream);
}
