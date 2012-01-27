#include "OFP_Type.h"

/* Number of slots for the vectors and name table
 */
#define NUM_TYPE_BUCKETS    8
#define NUM_KIND_BUCKETS   16
#define NUM_RANK_BUCKETS   16
#define NUM_NAME_BUCKETS   32


/* the current type table
 *   NOTE: a separate type table may be needed for each scope, this
 *         will do for now
 */
static pOFP_TYPE_TABLE type_table;

pOFP_TYPE_TABLE
ofpGetTypeTable()
{
   return type_table;
}
void
ofpPushTypeTable(pOFP_TYPE_TABLE table)
{
   type_table = table;
}


static void
ofpTypeFree(pOFP_TYPE type)
{
   if (type->name != NULL) {
      free(type->name);
   }
   free(type);
}

static pOFP_TYPE
ofpTypeNew(int id, int kind, int rank, const char * name)
{
   pOFP_TYPE type = (pOFP_TYPE) malloc(sizeof(OFP_TYPE));

   if (type == NULL)  return  NULL;

   type->id    = id;
   type->kind  = kind;
   type->rank  = rank;
   type->name = NULL;

   if (type->name != NULL) {
      type->name  = strdup(name);
   }

   type->free = ofpTypeFree;

   return type;
}


/* Initialize the type table
 */
pOFP_TYPE_TABLE
ofpTypeTableNew()
{
   int itype, ikind, irank;

   pOFP_TYPE_TABLE table = (pOFP_TYPE_TABLE) malloc(sizeof(OFP_TYPE_TABLE));

   if (table == NULL)  return  NULL;

   pANTLR3_VECTOR intrinsics = antlr3VectorNew(NUM_TYPE_BUCKETS);

   if (intrinsics == NULL) {
      free(table);
      return NULL;
   }

   table->intrinsics = intrinsics;
   table->free       = NULL;   // TODO - add free function

   for (itype = 0; itype < NUM_TYPE_BUCKETS; itype++) {
      /* create a kind vector for every intrinsic type
       */
      pANTLR3_VECTOR kinds = antlr3VectorNew(NUM_KIND_BUCKETS);
      intrinsics->set(intrinsics, itype, kinds, NULL, ANTLR3_FALSE);

      /* create a default kind
       */
      pANTLR3_VECTOR ranks = antlr3VectorNew(NUM_RANK_BUCKETS);
      kinds->set(kinds, KIND_DEFAULT, ranks, NULL, ANTLR3_FALSE);

      /* all other kinds are initially NULL
       */
      for (ikind = 1; ikind < NUM_KIND_BUCKETS; ikind++) {
         kinds->set(kinds, ikind, NULL, NULL, ANTLR3_FALSE);
      }

      if (itype != DERIVED) {
         /* actual type is in slot for scalar */
         pOFP_TYPE type = ofpTypeNew(itype, KIND_DEFAULT, RANK_SCALAR, NULL);
         ranks->set(ranks, 0, type, (void (ANTLR3_CDECL *) (void *))ofpTypeFree, ANTLR3_TRUE);
      }
      else {
         /* name table is in slot for scalar and initially has no names */
         pANTLR3_HASH_TABLE table = antlr3HashTableNew(NUM_NAME_BUCKETS);
         ranks->set(ranks, 0, table, NULL, ANTLR3_FALSE);
      }

      /* all ranks other than scalar are NULL
f       */
      for (irank = 1; irank < NUM_RANK_BUCKETS; irank++) {
         ranks->set(ranks, irank, NULL, NULL, ANTLR3_FALSE);
      }
   } // end loop over itype

   return table;
}

/* Add a new type to the table (ignore if already present)
 */
void
addType(pOFP_TYPE_TABLE table, pOFP_TYPE type)
{
   type = getType(table, type->id, type->kind, type->rank, type->name);
   if (type != NULL) return;

   pANTLR3_VECTOR kinds = table->intrinsics->get(table->intrinsics, type->id);
   if (kinds == NULL) {
      /* help */
   }

   pANTLR3_VECTOR ranks = kinds->get(kinds, type->kind);
   if (ranks == NULL) {
      /* help */
   }

   if (type->id != DERIVED) {
      pOFP_TYPE should_be_null = ranks->get(ranks, type->rank);
      if (should_be_null != NULL) {
         /* help, should not be a type here yet */
      }
      ranks->set(ranks, type->rank, type, (void (ANTLR3_CDECL *) (void *))ofpTypeFree, ANTLR3_TRUE);
      
   }
   else {
      /* get type based on name
       */
      pANTLR3_HASH_TABLE names = ranks->get(ranks, type->rank);
      if (names == NULL) {
         /* help, should be a string table here */
      }

      pOFP_TYPE should_be_null = names->get(names, type->name);
      if (should_be_null != NULL) {
         /* help, should not be a type here yet */
      }

      type = (pOFP_TYPE) names->get(names, (char*)type->name);

      names->put(names, type->name, type, (void (ANTLR3_CDECL *) (void *))type->free);
   }

}


/* Get a type from the table (NULL if not present)
 */
pOFP_TYPE
getType(pOFP_TYPE_TABLE table, int id, int kind, int rank, const char * name)
{
   pANTLR3_VECTOR  kinds, ranks;
   pOFP_TYPE       type;

   kinds = (pANTLR3_VECTOR) table->intrinsics->get(table->intrinsics, id);
   if (kinds == NULL) {
      return NULL;
   }

   ranks = (pANTLR3_VECTOR) kinds->get(kinds, kind);
   if (ranks == NULL) {
      return NULL;
   }

   type = (pOFP_TYPE) ranks->get(ranks, rank);
   if (type == NULL) {
      return NULL;
   }

   if (id == DERIVED) {
      /* get type based on name
       */
      pANTLR3_HASH_TABLE names = (pANTLR3_HASH_TABLE) type;
      type = (pOFP_TYPE) names->get(names, (char*)name);
   }

   return type;
}
