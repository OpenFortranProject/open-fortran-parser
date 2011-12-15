#include <antlr3tokenstream.h>

/*
 * Defines the data structure for OFP_TOKEN_SOURCE, an implementation of
 * an ANTLR3_TOKEN_SOURCE.  This file is adapted from antrl3tokenstream.h
 * and the original license is included below.
 */

#ifndef	_OFP_TOKENSOURCE_H
#define	_OFP_TOKENSOURCE_H

// [The "BSD licence"]
// Copyright (c) 2005-2009 Jim Idle, Temporal Wave LLC
// http://www.temporal-wave.com
// http://www.linkedin.com/in/jimidle
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifdef __cplusplus
extern "C" {
#endif


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

    /** Pointer to a function that returns the next token in the stream. 
     */
    pANTLR3_COMMON_TOKEN    (*nextToken)(struct ANTLR3_TOKEN_SOURCE_struct * tokenSource);

    /** Whoever is providing tokens, needs to provide a string factory too
     */
    pANTLR3_STRING_FACTORY  strFactory;

    /** A special pre-allocated token, which signifies End Of Tokens. Because this must
     *  be set up with the current input index and so on, we embed the structure and 
     *  return the address of it. It is marked as factoryMade, so that it is never
     *  attempted to be freed.
     */
    ANTLR3_COMMON_TOKEN	    eofToken;

   /** A special pre-allocated token, which is returned by mTokens() if the
    * lexer rule said to just skip the generated token altogether.
    * Having this single token stops us wasting memory by have the token factory
    * actually create something that we are going to SKIP(); anyway.
    */
    ANTLR3_COMMON_TOKEN     skipToken;

    /** Whatever is supplying the token source interface, needs a pointer to 
     *  itself so that this pointer can be passed to it when the nextToken
     *  function is called.
     */
    void                    * super;

    /** When the token source is constructed, it is populated with the file
     *  name from whence the tokens were produced by the lexer. This pointer is a
     *  copy of the one supplied by the CharStream (and may be NULL) so should
     *  not be manipulated other than to copy or print it.
     */
    pANTLR3_STRING          fileName;
}
    OFP_TOKEN_SOURCE;


#ifdef __cplusplus
}
#endif

#endif

