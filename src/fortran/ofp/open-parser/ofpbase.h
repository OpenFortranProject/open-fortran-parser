#ifndef	OFP_BASE_RTN_H
#define	OFP_BASE_RTN_H

#include <antlr3commontoken.h>

/** Generic return type for synthetic OFP tree nodes.  Allows
 *  information regarding encompassing start and stop tokens to
 *  be stored.
 */
typedef struct OFP_BASE_RTN_struct
{
    pANTLR3_COMMON_TOKEN    start;
    pANTLR3_COMMON_TOKEN    stop;
}
    OFP_BASE_RTN, * pOFP_BASE_RTN;

#endif
