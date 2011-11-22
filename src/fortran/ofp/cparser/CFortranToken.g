grammar CFortranToken;

options {
   language=C;

   // If generating AST or a tree walker...
   //
   // ASTLabelType=pANTLR3_BASE_TREE;

}

@members {

#include "CFortranTokenLexer.h"

int main(int argc, char * argv[])
{
   pANTLR3_INPUT_STREAM          input;
   pCFortranTokenLexer           lex;
   pANTLR3_COMMON_TOKEN_STREAM   tokens;
   pCFortranTokenParser          parser;

   input   = antlr3FileStreamNew               ( (pANTLR3_UINT8) argv[1], ANTLR3_ENC_8BIT );
   lex     = CFortranTokenLexerNew             ( input );
   tokens  = antlr3CommonTokenStreamSourceNew  ( ANTLR3_SIZE_HINT, TOKENSOURCE(lex) );
   parser  = CFortranTokenParserNew            ( tokens );

   parser->ftokens(parser);

   // must manually clean up
   //
   parser ->free(parser);
   tokens ->free(tokens);
   lex    ->free(lex);
   input  ->close(input);

   return 0;
}

}

ftokens  :  ftoken ftoken*
         ;

ftoken   :   '['
             ftoken_index  ','
             start_index   ':'
             stop_index    '='
             text          ','
             ftoken_type   ','
             line          ':'
             column
             ']'
         ;

ftoken_index
   :   '@' NUMBER
          {
               printf("   ftoken_index  == '\%s'\n", $NUMBER.text->chars);
          }
   ;             

ftoken_type
   :   '<' NUMBER '>'
          {
               printf("    ftoken_type  == '\%s'\n", $NUMBER.text->chars);
          }
   ;             

start_index
   :   NUMBER
          {
               printf("    start_index  == '\%s'\n", $NUMBER->getText($NUMBER)->chars);
          }
   ;

stop_index
   :   NUMBER
          {
               printf("     stop_index  == '\%s'\n", $NUMBER->getText($NUMBER)->chars);
          }
   ;

line
   :   NUMBER
          {
               printf("           line  == '\%s'\n", $NUMBER->getText($NUMBER)->chars);
          }
   ;

column
   :   NUMBER
          {
               printf("         column  == '\%s'\n", $NUMBER->getText($NUMBER)->chars);
          }
   ;

text
   :   STRING_LITERAL
          {
               printf("           text  == '\%s'\n", $STRING_LITERAL.text->chars);
          }
   ;

NUMBER   : (DIGIT)+
         ;


STRING_LITERAL
   :   '\'' (STRING_CHARS)* '\''
   ;

WHITESPACE  :  ( '\t' | ' ' | '\r' | '\n' )+
                  {
                     $channel = HIDDEN;
                  }
            ;

fragment
DIGIT      :  '0'..'9'  ;

fragment
STRING_CHARS  :  'a'..'z'  ;
