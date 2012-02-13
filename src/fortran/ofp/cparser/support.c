#include "support.h"
#include "OFP_Type.h"

pUnparser OFPUnparserNew (pANTLR3_COMMON_TREE_NODE_STREAM instream)
{
   pOFP_TYPE_TABLE type_table = ofpTypeTableNew();
   ofpPushTypeTable(type_table);

   return UnparserNew(instream);
}
