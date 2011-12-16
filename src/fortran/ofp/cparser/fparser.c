#include <stdio.h>
#include "OFPTokenSource.h"
#include "CFortranParser.h"

pANTLR3_VECTOR    get_tokens(const char * token_file);
void              printToken(pANTLR3_COMMON_TOKEN tok);

int main(int argc, char * argv[])
{
   int i;

   pANTLR3_VECTOR                 tlist;
   pANTLR3_TOKEN_SOURCE           tsource;
   pANTLR3_COMMON_TOKEN_STREAM    tstream;
   pCFortranParser                parser;
   
   char * tok_file = argv[1];
   char * src_file = argv[2];

   if (argc < 3) {
      printf("usage: ftokens token_file src_file\n");
      exit(1);
   }

   /* Lexer phase
    *    - Call the token parser to read the tokens from the token file.
    */

   tlist = get_tokens(tok_file);

   /* print tokens
    */
   //   for (i = 0; i < tlist->size(tlist); i++) {
   //      printToken((pANTLR3_COMMON_TOKEN) tlist->get(tlist, i));
   //   }

   /* Parser phase
    *    - Call the parser with the token source which uses the token
    *      list obtained from the token file.
    */

   tsource  =  ofpTokenSourceNew                 ( (pANTLR3_UINT8) src_file, tlist );
   tstream  =  antlr3CommonTokenStreamSourceNew  ( ANTLR3_SIZE_HINT, tsource );
   parser   = CFortranParserNew                  ( tstream );

   parser->main_program(parser);

   return 0;
}

void printToken(pANTLR3_COMMON_TOKEN tok)
{
   printf("[");
     printf("@\%d,", (int)tok->getTokenIndex(tok));
     printf("\%d:", (int)tok->getStartIndex(tok));
     printf("\%d=", (int)tok->getStopIndex(tok));
     printf("'\%s',", tok->getText(tok)->chars);
     printf("<\%d>,", (int)tok->getType(tok));
     if (tok->getChannel(tok) > ANTLR3_TOKEN_DEFAULT_CHANNEL) {
        printf("channel=\%d,", (int)tok->getChannel(tok));
     }
     printf("\%d:", (int)tok->getLine(tok));
     printf("\%d", (int)tok->getCharPositionInLine(tok));
   printf("]\n");
}
