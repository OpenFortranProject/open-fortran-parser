#include "support.h"
#include "OFP_TypeTable.h"

pFTreeWalker OFPTreeWalkerNew (pANTLR3_COMMON_TREE_NODE_STREAM instream)
{
   pOFP_TYPE_TABLE type_table = ofpTypeTableNew();

   return OFPTreeWalkerNew(instream);
}
