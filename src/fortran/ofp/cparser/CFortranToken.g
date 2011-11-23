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

/* current working token
 */
pANTLR3_COMMON_TOKEN   token;
pANTLR3_TOKEN_FACTORY  tfactory;
pANTLR3_STRING_FACTORY sfactory;

/* token list
 */
pANTLR3_VECTOR toklist;

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

int main(int argc, char * argv[])
{
   int i;

   pANTLR3_INPUT_STREAM          input;
   pCFortranTokenLexer           lex;
   pANTLR3_COMMON_TOKEN_STREAM   tokens;
   pCFortranTokenParser          parser;

   /* initialize
    */
   toklist  = antlr3VectorNew(0);
   tfactory = antlr3TokenFactoryNew(input);
   sfactory = antlr3StringFactoryNew( ANTLR3_ENC_8BIT );

   /* initialize antlr structures
    */
   input   = antlr3FileStreamNew               ( (pANTLR3_UINT8) argv[1], ANTLR3_ENC_8BIT );
   lex     = CFortranTokenLexerNew             ( input );
   tokens  = antlr3CommonTokenStreamSourceNew  ( ANTLR3_SIZE_HINT, TOKENSOURCE(lex) );
   parser  = CFortranTokenParserNew            ( tokens );

   parser->ftokens(parser);

   /* print tokens
    */
   for (i = 0; i < toklist->size(toklist); i++) {
      printToken((pANTLR3_COMMON_TOKEN) toklist->get(toklist, i));
   }

   /* must manually clean up
    */
   parser ->free(parser);
   tokens ->free(tokens);
   lex    ->free(lex);
   input  ->close(input);

   return 0;
}

}

/*
 * parser rules
 */

ftokens  :  ftoken ftoken*
         ;

ftoken
@init {
   token = tfactory->newToken(tfactory);
}
@after {
   toklist->add(toklist, token, NULL);
}
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
              token->setTokenIndex(token, (ANTLR3_MARKER)index);
          }
   ;             

ftoken_type
   :   '<' NUMBER '>'
          {
             int type = atoi($NUMBER.text->chars);
             token->setType(token, (ANTLR3_UINT32)type);
          }
   ;             

channel_spec
   :   'channel' '=' NUMBER
          {
             int channel = atoi($NUMBER.text->chars);
             token->setChannel(token, (ANTLR3_UINT32)channel);
          }
   ;             

start_index
   :   NUMBER
          {
             int start = atoi($NUMBER.text->chars);
             token->setStartIndex(token, (ANTLR3_MARKER)start);
          }
   ;

stop_index
   :   NUMBER
          {
             int stop = atoi($NUMBER.text->chars);
             token->setStopIndex(token, (ANTLR3_MARKER)stop);
          }
   ;

line
   :   NUMBER
          {
             int line = atoi($NUMBER.text->chars);
             token->setLine(token, (ANTLR3_UINT32)line);
          }
   ;

column
   :   NUMBER
          {
             int pos = atoi($NUMBER.text->chars);
             token->setCharPositionInLine(token, (ANTLR3_UINT32)pos);
          }
   ;

text
   :   T_CHAR_CONSTANT
          {
              char * text_chars = strdup( & $T_CHAR_CONSTANT.text->chars [1] );
              int    text_len   = strlen(text_chars);

              /* 'delete' the trailing quote character */
              text_chars[text_len-1] = '\0';
              text_len -= 1;

              pANTLR3_STRING str = sfactory->newSize(sfactory, text_len);
              str->set(str, text_chars);
              token->setText(token, str);
              free(text_chars);
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
