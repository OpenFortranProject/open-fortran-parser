#include <antlr3tokenstream.h>

/*
 * Defines the data structure for OFP_TOKEN_SOURCE, an implementation of
 * an ANTLR3_TOKEN_SOURCE.
 */

#ifndef	_OFP_TOKENSOURCE_H
#define	_OFP_TOKENSOURCE_H

#ifdef __cplusplus
extern "C" {
#endif

typedef	struct OFP_TOKEN_SOURCE_struct * pOFP_TOKEN_SOURCE;

pANTLR3_TOKEN_SOURCE   ofpTokenSourceNew(pANTLR3_UINT8 fileName, pANTLR3_VECTOR tokens);

/** Definition of a token source, which has a pointer to a function that 
 *  returns the next token.  This implementation stores the tokens in a
 *  list and returns the next token from the list.
 */
typedef struct OFP_TOKEN_SOURCE_struct
{
    /** Index of the next token to pull from the list.
     */
    int                     index;

    /** List of tokens for this source.
     */
    pANTLR3_VECTOR          tokens;

    /** Implementation of the interface for the token source.
     */
    pANTLR3_TOKEN_SOURCE    base;
}
    OFP_TOKEN_SOURCE;


#ifdef __cplusplus
}
#endif

#endif

