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
pANTLR3_COMMON_TOKEN  token;

/* token list
 */
extern pANTLR3_VECTOR  tlist;

extern pANTLR3_TOKEN_FACTORY   tfactory;
extern pANTLR3_STRING_FACTORY  sfactory;

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
   tlist->add(tlist, token, NULL);
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
