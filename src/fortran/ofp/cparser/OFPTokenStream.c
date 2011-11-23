#include <antlr3.h>

typedef struct OFP_TOKEN_SOURCE_struct
{
    int index;
    pANTLR3_VECTOR toklist;
} OFP_TOKEN_SOURCE;


static pANTLR3_COMMON_TOKEN
nextToken (pANTLR3_TOKEN_SOURCE ts)
{
   pANTLR3_COMMON_TOKEN ct = NULL;

   OFP_TOKEN_SOURCE * ofp_src = (OFP_TOKEN_SOURCE *) ts->super;

   ct = (pANTLR3_COMMON_TOKEN) ofp_src->toklist->get(ofp_src->toklist, ofp_src->index++);

   return ct;
}

ANTLR3_API pANTLR3_TOKEN_SOURCE
ofpTokenSourceNew(pANTLR3_UINT8 fileName)
{
    pANTLR3_TOKEN_SOURCE   ts;
    pANTLR3_STRING         str;

    /* Memory for the interface structure
     */
    ts  = (pANTLR3_TOKEN_SOURCE) ANTLR3_MALLOC(sizeof(ANTLR3_TOKEN_SOURCE));

    ts->super = (OFP_TOKEN_SOURCE *) ANTLR3_MALLOC(sizeof(OFP_TOKEN_SOURCE));

    /* make sure special pre-allocated tokens aren't freed
     */
    ts->eofToken.factoryMade   =  1;
    ts->skipToken.factoryMade  =  1;

    /* create string factory
     */
    ts->strFactory = antlr3StringFactoryNew( ANTLR3_ENC_8BIT );

    /* create file name
     */
    str = ts->strFactory->newRaw(ts->strFactory);
    str->set(str, fileName);
    ts->fileName = str;

    ts->nextToken = nextToken;

    return ts;
}
