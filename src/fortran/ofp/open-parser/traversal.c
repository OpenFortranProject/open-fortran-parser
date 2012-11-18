#include "traversal.h"

ATbool ofp_tranverse_label(ATerm term)
{
   ATbool matched = ATfalse;
   int label;
   if (ATmatch(term, "label(<int>)", &label))
   {
       printf("%d ", label);
       matched = ATtrue;
   }
   return matched;
}

ATbool ofp_tranverse_program_name(ATerm term)
{
   ATbool matched = ATfalse;
   char * name;
   if (ATmatch(term, "program-name(<str>)", &name))
   {
       printf(" %s", name);
       matched = ATtrue;
   }
   return matched;
}

ATbool ofp_traverse_main_program(ATerm term)
{
   ATbool matched;
   ATerm prgm_stmt, spec_part, exe_part, sub_part, end_prgm_stmt;

   matched = ATmatch(term, "main-program(<term>,<term>,<term>,<term>,<term>)",
                     &prgm_stmt,
                     &spec_part,
                     &exe_part,
                     &sub_part,
                     &end_prgm_stmt);
   if (!matched) return ATfalse;
 
   if (!(matched = ofp_traverse_program_stmt      (prgm_stmt)     )) return ATfalse;
   if (!(matched = ofp_traverse_end_program_stmt  (end_prgm_stmt) )) return ATfalse;

   return matched;
}

ATbool ofp_traverse_program_stmt(ATerm term)
{
   ATbool matched;
   ATerm label, name;

   matched = ATmatch(term, "program-stmt(<term>, <term>)", &label, &name);
   if (!matched) return ATfalse;

   ofp_tranverse_label(label);   /* optional */
   printf("Program");

   matched = ofp_tranverse_program_name(name);
   printf("\n");

   return matched;
}

ATbool ofp_traverse_end_program_stmt(ATerm term)
{
   ATbool matched;
   ATerm  label, name;

   matched = ATmatch(term, "end-program-stmt(<term>, <term>)", &label, &name);
   if (!matched) return ATfalse;

   ofp_tranverse_label(label);         /* optional */
   printf("End Program");

   ofp_tranverse_program_name(name);   /* optional */
   printf("\n");

   return matched;
}
