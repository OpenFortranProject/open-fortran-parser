parser grammar CFortranParser;

options {
   language=C;
   tokenVocab=FortranLexer;

   // If generating AST or a tree walker...
   //
   output=AST;
   ASTLabelType=pANTLR3_BASE_TREE;
}

/*
 * This is the header for the Java target.
 */
///@header {
///package fortran.ofp.parser.java;
///}

@members {

#include    <stdio.h>

/*
 * These are the members for the Java target.
 */
///   int gCount1;
///   int gCount2;
///
///   public void initialize(String[] args, String kind, String filename, String path)
///   {
///      action = FortranParserActionFactory.newAction(args, this, kind, filename);
///      initialize(this, action, filename, path);
///      action.start_of_file(filename, path);
///   }
///
///   public void eofAction()
///   {
///      action.end_of_file(filename, pathname);
///   }

}

//tokens {
//   OFP_Program;
//}

/*
 * Section/Clause 1: Overview
 */


/*
 * Section/Clause 2: Fortran concepts
 */


/*
 * Got rid of the following rules: 
 * program
 * program_unit
 * external_subprogram
 *
 * this was done because Main() should now handle the top level rules
 * to try and reduce the amount of backtracking that must be done!
 * --Rickett, 12.07.06
 *
 * for some reason, leaving these three rules in, even though main() 
 * does NOT call them, prevents the parser from failing on the tests:
 * main_program.f03
 * note_6.24.f03
 * it appears to be something with the (program_unit)* part of the 
 * program rule.  --12.07.06
 *  --resolved: there's a difference in the code that is generated for 
 *              the end_of_stmt rule if these three rules are in there.
 *              to get around this, i modified the end_of_stmt rule.  
 *              see it for more details.  --12.11.06
 * 
 */

/*
 * R201-F08 program
 *    is program-unit 
 *       [ program-unit ] ... 
 */

////////////
// R201-F08
//
// Removed from grammar and called explicitly
//


/*
 * R202-F08 program-unit
 *    is main-program
 *    or external-subprogram
 *    or module
 *    or submodule     // NEW_TO_2008
 *    or block-data
 */

////////////
// R202-F08
//
// Removed from grammar and called explicitly
//


/*
 * R203-F08 external-subprogram
 *    is function-subprogram 
 *    or subroutine-subprogram
 */

////////////
// R203-F08
//
// Removed from grammar and called explicitly
//


//----------------------------------------------------------------------------------------
//
/* R312-F08 label
 *   is digit [digit [digit [digit [digit ]]]]
 */
//
// This should be checked to make sure the label is five characters or less.
//
//----------------------------------------------------------------------------------------
label
   :  T_DIGIT_STRING
          {
              //action.label($T_DIGIT_STRING);
          }
   ;


//----------------------------------------------------------------------------------------
//
/* R1101-F08 main-program
 *   is [ program-stmt ]
 *         [ specification-part ]
 *         [ execution-part ]
 *         [ internal-subprogram-part ]
 *         end-program-stmt
 */
//
//
// This is one of the entry points to the parser.
//
// specification_part made non-optional to remove END ambiguity (as it can be empty)
//
//----------------------------------------------------------------------------------------
main_program
@init
{
   ANTLR3_BOOLEAN  hasProgramStmt              = ANTLR3_FALSE;
   ANTLR3_BOOLEAN  hasExecutionPart            = ANTLR3_FALSE;
   ANTLR3_BOOLEAN  hasInternalSubprogramPart   = ANTLR3_FALSE;
   //c_action_main_program__begin();
}
@after
{
   //c_action_main_program(hasProgramStmt, hasExecutionPart, hasInternalSubprogramPart);
}
   :   ( program_stmt {hasProgramStmt = ANTLR3_FALSE;} )?

//       specification_part
//       ( execution_part {hasExecutionPart = true;} )?
//       ( internal_subprogram_part {hasInternalSubprogramPart = true;} )?

         end_program_stmt
   -> ^(program_stmt)
   ;




/**
 * Section/Clause 11: Program units
 */


//----------------------------------------------------------------------------------------
//
/* R1102-F08 program-stmt
 *   is PROGRAM [ program-name ]
 */
//
// T_IDENT inlined for program_name
//
//----------------------------------------------------------------------------------------
program_stmt
@init
{
   pANTLR3_COMMON_TOKEN  lbl = NULL;
}
@after
{
   //checkForInclude();
}
   :   (label {lbl=$label.start;})?
       T_PROGRAM!  T_IDENT  end_of_stmt

          {
             //c_action_program_stmt(lbl, $T_PROGRAM, $T_IDENT, $end_of_stmt.start);
             printf("program_stmt: \%s \%s\n", $T_PROGRAM->getText($T_PROGRAM)->chars,
                                               $T_IDENT  ->getText($T_IDENT)  ->chars  );
          }

   ;


//----------------------------------------------------------------------------------------
//
/* R1103-F08 end-program-stmt
 *   is END [ PROGRAM [ program-name ] ]
 */
//
// T_IDENT inlined for program_name
//
//----------------------------------------------------------------------------------------
end_program_stmt
@init
{
   pANTLR3_COMMON_TOKEN  lbl = NULL;
   pANTLR3_COMMON_TOKEN  id  = NULL;
}
@after
{
   //checkForInclude();
}
   :  (label {lbl=$label.start;})?
      T_END  T_PROGRAM  (T_IDENT {id=$T_IDENT;})?   end_of_stmt

         {
             //action.end_program_stmt(lbl, $T_END, $T_PROGRAM, id, $end_of_stmt.start);
             printf("end_program_stmt: \%s \%s\n", $T_PROGRAM->getText($T_PROGRAM)->chars,
                                                   $T_IDENT  ->getText($T_IDENT)  ->chars  );
         }

   |   (label {lbl=$label.start;})?
       T_ENDPROGRAM     (T_IDENT {id=$T_IDENT;})?   end_of_stmt

         {
             //action.end_program_stmt(lbl, $T_ENDPROGRAM, null, id, $end_of_stmt.start);
         }

   |   (label {lbl=$label.start;})?
       T_END                                        end_of_stmt

         {
             //action.end_program_stmt(lbl, $T_END, null, null, $end_of_stmt.start);
         }

   ;


//----------------------------------------------------------------------------------------
// This rule added to allow matching of T_EOS or EOF combination.
//----------------------------------------------------------------------------------------
end_of_stmt
   :  T_EOS
          {
              //action.end_of_stmt($T_EOS);
          }
    ->
   |  T_EOF
          {
             //action.end_of_stmt($T_EOF);
          }
    ->
   ;
