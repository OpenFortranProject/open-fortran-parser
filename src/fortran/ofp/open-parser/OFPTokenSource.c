#include "OFPTokenSource.h"

static pANTLR3_COMMON_TOKEN
nextToken (pANTLR3_TOKEN_SOURCE ts)
{
   pANTLR3_COMMON_TOKEN ct = NULL;

   OFP_TOKEN_SOURCE * this = (OFP_TOKEN_SOURCE *) ts->super;

   ct = (pANTLR3_COMMON_TOKEN) this->tokens->get(this->tokens, this->index++);

   return ct;
}

pANTLR3_TOKEN_SOURCE
ofpTokenSourceNew(pANTLR3_UINT8 fileName, pANTLR3_VECTOR tokens)
{
    pOFP_TOKEN_SOURCE     ts;
    pANTLR3_STRING        str;
    pANTLR3_COMMON_TOKEN  token;

    ts  = (pOFP_TOKEN_SOURCE) ANTLR3_MALLOC(sizeof(OFP_TOKEN_SOURCE));
    if (ts == NULL)
       {
          return  NULL;
       }

    /* Memory for the interface structure
     */
    ts->base = (pANTLR3_TOKEN_SOURCE) ANTLR3_CALLOC(1, sizeof(ANTLR3_TOKEN_SOURCE));
    if (ts->base == NULL)
       {
          /* TODO - create and use free method */
          ANTLR3_FREE(ts);
          return  NULL;
       }

    /* Initialize base object
     */

    ts->base->super         = ts;
    ts->base->nextToken     = nextToken;
    ts->base->strFactory    = antlr3StringFactoryNew( ANTLR3_ENC_8BIT );

    /* Initialise the eof token                                                                      
     */
    token                 = &(ts->base->eofToken);
    antlr3SetTokenAPI  (token);
    token->setType     (token, ANTLR3_TOKEN_EOF);
    token->factoryMade    = ANTLR3_TRUE;      // Prevent things trying to free() it
    token->strFactory     = NULL;
    token->textState      = ANTLR3_TEXT_NONE;
    token->custom         = NULL;
    token->user1          = 0;
    token->user2          = 0;
    token->user3          = 0;

   /* Initialize the skip token.                                                                
    */
    token                 = &(ts->base->skipToken);
    antlr3SetTokenAPI  (token);
    token->setType     (token, ANTLR3_TOKEN_INVALID);
    token->factoryMade    = ANTLR3_TRUE;     // Prevent things trying to free() it
    token->strFactory     = NULL;
    token->textState      = ANTLR3_TEXT_NONE;
    token->custom         = NULL;
    token->user1          = 0;
    token->user2          = 0;
    token->user3          = 0;

    /* Initialize this object
     */
    ts->index    = 0;
    ts->tokens   = tokens;

    /* create file name
     */
    str                 = ts->base->strFactory->newRaw(ts->base->strFactory);
    str->set(str, fileName);
    ts->base->fileName  = str;

    return ts->base;
}
