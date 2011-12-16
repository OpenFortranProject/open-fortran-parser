parser grammar CFortranParser;

options {
   language=C;
   tokenVocab=CFortranLexer;

   // If generating AST or a tree walker...
   //
   output=AST;
   ASTLabelType=pANTLR3_BASE_TREE;
}

@members {

#include    <stdio.h>

}

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

/*
 * R1101-F08 main-program
 *  is [ program-stmt ]
 *        [ specification-part ]
 *        [ execution-part ]
 *        [ internal-subprogram-part ]
 *        end-program-stmt
 */

////////////
// R1101-F08
//
// We need a start rule as a entry point in the parser
//
// specification_part made non-optional to remove END ambiguity
//   (as can be empty)
//
main_program
@init
{
   int hasProgramStmt = 0;
   int hasExecutionPart = 0;
   int hasInternalSubprogramPart = 0;
   //action.main_program__begin();
}
   :   ( program_stmt {hasProgramStmt = 0;} )?
//       specification_part
//       ( execution_part {hasExecutionPart = true;} )?
//       ( internal_subprogram_part {hasInternalSubprogramPart = true;} )?
//       end_program_stmt
//         {
//           action.main_program(hasProgramStmt, hasExecutionPart, hasInternalSubprogramPart);
//         }
   ;




/**
 * Section/Clause 11: Program units
 */


// R1102
// T_IDENT inlined for program_name
program_stmt
//@init {Token lbl = null;} // @init{INIT_TOKEN_NULL(lbl);}
//@after{checkForInclude();}
	:	/*(label {lbl=$label.tk;})?*/ T_PROGRAM T_IDENT //end_of_stmt
//		{ action.program_stmt(lbl, $T_PROGRAM, $T_IDENT, $end_of_stmt.tk); }
       {
          printf("program_stmt: \%s \%s\n", $T_PROGRAM->getText($T_PROGRAM)->chars,
                                            $T_IDENT  ->getText($T_IDENT)  ->chars  );
       }
	;
