#ifndef	OFP_TYPE_H
#define	OFP_TYPE_H

#include <antlr3basetree.h>
#include <antlr3collections.h>

#define KIND_DEFAULT 0
#define RANK_SCALAR  0

typedef enum {
   INTEGER = 0,
   REAL,
   DOUBLEPRECISION,
   COMPLEX,
   DOUBLECOMPLEX,
   CHARACTER,
   LOGICAL,
   DERIVED     /* derived must occur last */
} Intrinsic_Type_Spec;


/* Structure representing a type
 */
typedef struct OFP_TYPE_struct
{
   int      id;         /* type id or tag */
   int      kind;
   int      rank;
   char *   name;       /* name if a derived type, null otherwise */

   /** Pointer to function to delete this type
    */
   void    (*free)             (struct OFP_TYPE_struct * type);
}
   OFP_TYPE, *pOFP_TYPE;

static pOFP_TYPE
ofpTypeNew(int id, int kind, int rank, const char * name);


/* Structure representing a type table
 */
typedef struct OFP_TYPE_TABLE_struct
{
   /* Head of the table is a vector containing a type hierarchy.
    * The hierarchy is type_id.kind.rank (TKR).
    */
   pANTLR3_VECTOR intrinsics;

   /** Pointer to function to insert an intrinsic type into the table
    */
   void     (*putIntrinsic)     (struct OFP_TYPE_TABLE_struct * table, pANTLR3_BASE_TREE tree);

   /** Pointer to function to completely delete this table
    */
   void     (*free)             (struct OFP_TYPE_TABLE_struct * type);
}
   OFP_TYPE_TABLE, *pOFP_TYPE_TABLE;


/* Create a type table
 */
pOFP_TYPE_TABLE
ofpTypeTableNew();

/* Free the type table
 */
pOFP_TYPE_TABLE
ofpTypeTableFree();

/* Retrieve a type from the table
 */
pOFP_TYPE
getType(pOFP_TYPE_TABLE table, int id, int kind, int rank, const char * name);

/* Add a new type to the table (ignore if already present)
 */
void
addType(pOFP_TYPE_TABLE table, pOFP_TYPE type);

/* Access to the type table(s)
 */
pOFP_TYPE_TABLE   ofpGetTypeTable   ();
void              ofpPushTypeTable  (pOFP_TYPE_TABLE table);


#endif
