#include "traversal.h"

ATbool ofp_tranverse_label(ATerm term)
{
   int    label;
   ATbool matched = ATfalse;
   if (ATmatch(term, "label(<int>)", &label) == ATtrue)
   {
      printf("%d ", label);
      matched = ATtrue;
   }
   return matched;
}

ATbool ofp_tranverse_program_name(ATerm term)
{
   char * name;
   ATbool matched = ATfalse;
   if (ATmatch(term, "program-name(<str>)", &name) == ATtrue)
   {
      printf(" %s", name);
      matched = ATtrue;
   }
   return matched;
}

//========================================================================================
// R204-F08 specification-part
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_specification_part(ATerm term)
{
   ATbool   matched;
   ATerm    decl_construct_list;

   matched = ATmatch(term, "specification-part(<term>)", &decl_construct_list);
   if (!matched) return ATfalse;

   if (ofp_traverse_declaration_construct_list(decl_construct_list) == ATfalse) return ATfalse;

   return ATtrue;
}

//========================================================================================
// R207-F08 declaration-construct
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_declaration_construct(ATerm term)
{
   ATbool  matched;
   ATerm   decl_construct;
   ATerm   t1, t2, t3;

   matched = ATmatch(term, "declaration-construct(<term>)", &decl_construct);
   if (!matched) return ATfalse;

   if (matched = ATmatch(decl_construct,"type-declaration-stmt(<term>,<term>,<term>)",&t1,&t2,&t3)) {
      matched = ofp_traverse_type_declaration_stmt(decl_construct);
   }

   return matched;
}

ATbool ofp_traverse_declaration_construct_list(ATerm term)
{
   ATerm     head;
   ATermList tail;

   if ( ATmatch(term, "declaration-construct-list(<list>)", &tail) != ATtrue ) return ATfalse;

   while (!ATisEmpty(tail)) {
      head = ATgetFirst (tail);
      tail = ATgetNext  (tail);
      if ( ofp_traverse_declaration_construct(head) != ATtrue) return ATfalse;
   }

   return ATtrue;
}

/**
 * Section/Clause 4: Types
 */

//========================================================================================
// R403-F08 declaration-type-spec
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_declaration_type_spec(ATerm term)
{
   ATbool  matched;
   ATerm   intrinsic_type_spec;

   matched = ATmatch(term, "declaration-type-spec(<term>)", &intrinsic_type_spec);
   if (!matched) return ATfalse;

   if (ofp_traverse_intrinsic_type_spec (intrinsic_type_spec) == ATfalse) return ATfalse;

   return matched;
}

//========================================================================================
// R404-F08 intrinsic-type-spec
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_intrinsic_type_spec(ATerm term)
{
   ATbool  matched;
   ATerm   type, kind;

   matched = ATmatch(term, "intrinsic-type-spec(<term>,<term>)", &type, &kind);
   if (!matched) return ATfalse;

   if (ATmatch(type, "REAL")) {printf("REAL"); return;}

   ATprintf("%t", kind);

   return matched;
}

/**
 * Section/Clause 5: Attribute declarations and specifications
 */

//========================================================================================
// R501-F08 type-declaration-stmt
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_type_declaration_stmt(ATerm term)
{
   ATbool     matched;
   ATerm      decl_construct;
   ATerm      label, decl_type_spec;
   ATerm      entity_decl_list;

   matched = ATmatch(term, "type-declaration-stmt(<term>, <term>, <term>)",
                     &label,
                     &decl_type_spec,
                     &entity_decl_list);
   if (!matched) return ATfalse;

   ofp_tranverse_label(label);   /* optional */

   if ( ofp_traverse_declaration_type_spec (decl_type_spec) != ATtrue ) return ATfalse;
   printf(" :: ");

   if ( ofp_traverse_entity_decl_list (entity_decl_list)    != ATtrue ) return ATfalse;
   printf("\n");

   return ATtrue;
}

//========================================================================================
// R503-F08 entity-decl
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_entity_decl(ATerm term)
{
   char *  object;

   if ( ATmatch(term, "object-name(name(<str>))", &object) != ATtrue ) return ATfalse;
   printf("%s", object);

   return ATtrue;
}

ATbool ofp_traverse_entity_decl_list(ATerm term)
{
   ATerm     head;
   ATermList tail;
   char *    comma   = "";

   if ( ATmatch(term, "entity-decl-list(<term>)", &tail) != ATtrue ) return ATfalse;

   while (!ATisEmpty(tail)) {
      head = ATgetFirst (tail);
      tail = ATgetNext  (tail);
      printf("%s", comma);      comma = ",";
      if ( ofp_traverse_entity_decl (head) != ATtrue ) return ATfalse;
   }

   return ATtrue;
}


//========================================================================================
// R1101-F08 main-program
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_main_program(ATerm term)
{
   ATbool matched;
   ATerm  prgm_stmt, spec_part, exe_part, sub_part, end_prgm_stmt;

   matched = ATmatch(term, "main-program(<term>,<term>,<term>,<term>,<term>)",
                     &prgm_stmt,
                     &spec_part,
                     &exe_part,
                     &sub_part,
                     &end_prgm_stmt);
   if (!matched) return ATfalse;
 
   if (!(matched = ofp_traverse_program_stmt         (prgm_stmt)     )) return ATfalse;
   if (!(matched = ofp_traverse_specification_part   (spec_part)     )) return ATfalse;
   if (!(matched = ofp_traverse_end_program_stmt     (end_prgm_stmt) )) return ATfalse;

   return matched;
}

//========================================================================================
// R1102-F08 program-stmt
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_program_stmt(ATerm term)
{
   ATbool matched;
   ATerm label, name;

   /* program-stmt is optional */
   if (ATmatch(term, "program-stmt")) return ATtrue;

   matched = ATmatch(term, "program-stmt(<term>, <term>)", &label, &name);
   if (!matched) return ATfalse;

   ofp_tranverse_label(label);   /* optional */
   printf("PROGRAM");

   matched = ofp_tranverse_program_name(name);
   printf("\n");

   return matched;
}

//========================================================================================
// R1103-F08 end-program-stmt
//----------------------------------------------------------------------------------------
ATbool ofp_traverse_end_program_stmt(ATerm term)
{
   ATbool matched;
   ATerm  label, name;

   matched = ATmatch(term, "end-program-stmt(<term>, <term>)", &label, &name);
   if (!matched) return ATfalse;

   ofp_tranverse_label(label);         /* optional */
   printf("END PROGRAM");

   ofp_tranverse_program_name(name);   /* optional */
   printf("\n");

   return matched;
}
