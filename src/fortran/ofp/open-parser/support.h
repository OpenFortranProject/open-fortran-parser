#ifndef	OFP_SUPPORT_H
#define	OFP_SUPPORT_H

#include    <antlr3.h>


/* Macros useful for checkers
 */
#define START_LINE (retval.start->getLine(retval.start))

void  print_token_text  (pANTLR3_COMMON_TOKEN tok);
void  print_token       (pANTLR3_COMMON_TOKEN tok);

#endif
