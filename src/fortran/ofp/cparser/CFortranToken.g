grammar CFortranToken;

options {
   language=C;

   // If generating AST or a tree walker...
   //
   // ASTLabelType=pANTLR3_BASE_TREE;

}

@members {

#include <stdio.h>
#include "CFortranTokenLexer.h"

FILE * fp;
char * text_chars;
int    text_len;

int main(int argc, char * argv[])
{
   pANTLR3_INPUT_STREAM          input;
   pCFortranTokenLexer           lex;
   pANTLR3_COMMON_TOKEN_STREAM   tokens;
   pCFortranTokenParser          parser;

   fp = fopen("tokens.src.out", "w");
   text_chars = strdup(" ");

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

   fclose(fp);
   free(text_chars);

   return 0;
}

}

ftokens  :  ftoken ftoken*
         ;

ftoken
@init  {printf("[");}
@after {printf("]\n");}
   :   '['
        ftoken_index  ','
        start_index   ':'
        stop_index    '='
        text          ','
        ftoken_type   ','
      ( channel_spec  ',' )?
        line          ':'
        column
        ']'
    ;

ftoken_index
   :   '@' NUMBER
          {
              int index = atoi($NUMBER.text->chars);
              printf("@\%d,", index);
          }
   ;             

ftoken_type
   :   '<' NUMBER '>'
          {
             int type = atoi($NUMBER.text->chars);
             printf("<\%d>,", type);
          }
   ;             

channel_spec
   :   'channel' '=' NUMBER
          {
             int channel = atoi($NUMBER.text->chars);
             printf("channel=\%d,", channel);
          }
   ;             

start_index
   :   NUMBER
          {
             int start = atoi($NUMBER.text->chars);
             text_len = start;
             printf("\%d:", start);
          }
   ;

stop_index
   :   NUMBER
          {
              int stop = atoi($NUMBER.text->chars);
              text_len = 1 + stop - text_len;
              printf("\%d=", stop);
          }
   ;

line
   :   NUMBER
          {
              int line = atoi($NUMBER.text->chars);
              printf("\%d:", line);
          }
   ;

column
   :   NUMBER
          {
              int col = atoi($NUMBER.text->chars);
              printf("\%d", col);
          }
   ;

text
   :   T_CHAR_CONSTANT
          {
              free(text_chars);
              text_chars = strdup(& $T_CHAR_CONSTANT.text->chars [1]);
              char * term = strrchr(text_chars, '\'');
//              text_chars[term] = '\0';
              *term = '\0';
              printf("\%s,", $T_CHAR_CONSTANT.text->chars);
              // TODO - there should be a better way to output '\n' and what about '\t'?
              if (text_chars[0] == '\\' && text_chars[1] == 'n') {
                 fprintf(fp, "\n");
              }
              else {
                 fprintf(fp, "\%s", text_chars);
              }
          }
   ;

// R427 from char-literal-constant
T_CHAR_CONSTANT
   :   ('\'' ( SQ_Rep_Char )* '\'')+
   |   ('\"' ( DQ_Rep_Char )* '\"')+
   ;

NUMBER
   :   Digit_String
   ;

WS :  (' ' | '\r'| '\t' | '\n'| '\u000C')
         {
             $channel = HIDDEN;
         }
   ;


/*
 * fragments
 */

// R409 digit_string
fragment
Digit_String : Digit+  ;

// R302 alphanumeric_character
fragment
Alphanumeric_Character : Letter | Digit | '_' ;

fragment
Special_Character
    :    ' ' .. '/' 
    |    ':' .. '@' 
    |    '[' .. '^' 
    |    '`' 
    |    '{' .. '~' 
    ;

fragment
Rep_Char : ~('\'' | '\"') ;

fragment
SQ_Rep_Char : ~('\'') ;
fragment
DQ_Rep_Char : ~('\"') ;

fragment
Letter : ('a'..'z' | 'A'..'Z') ;

fragment
Digit : '0'..'9'  ;

fragment
STRING_CHARS  :  'a'..'z' ' ' ;
