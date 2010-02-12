parser grammar FortranParser08;

options {
    language=Java;
    superClass=FortranParser;
    tokenVocab=FortranLexer;
}

import FortranParser03;

@header {
  package fortran.ofp.parser.java;
  import fortran.ofp.parser.java.IActionEnums;
}

@members {

   public void initialize(String[] args, String kind, String filename) {
      action = FortranParserActionFactory.newAction(args, this, kind, filename);

      initialize(this, action, filename);
      gFortranParser03.initialize(this, action, filename);

      action.start_of_file(this.filename);
   }

} // end members



/***
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
   boolean hasProgramStmt = false;
   boolean hasExecutionPart = false;
   boolean hasInternalSubprogramPart = false;
}
    :       {
               action.main_program__begin();
            }

        ( program_stmt {hasProgramStmt = true;} )?

        specification_part

        ( execution_part {hasExecutionPart = true;} )?

        ( internal_subprogram_part {hasInternalSubprogramPart = true;} )?

        end_program_stmt
            {
               action.main_program(hasProgramStmt, hasExecutionPart, 
                                   hasInternalSubprogramPart);
            }
    ;


/***
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
 * R204 speciﬁcation-part
 *    is [ use-stmt ] ... 
 *       [ import-stmt ] ... 
 *       [ implicit-part ] 
 *       [ declaration-construct ] ... 
 */


/*
 * C201-F08   (R208) An execution-part shall not contain an end-function-stmt,
 *  end-mp-subprogram-stmt, end-program-stmt, or end-subroutine-stmt.
 */


/*
 * R214-F08 action-stmt
 *    is allocate-stmt
 *    or allstop-stmt                  // NEW_TO_2008
 *    or assignment-stmt
 *    or backspace-stmt
 *    or call-stmt
 *    or close-stmt
 *    or continue-stmt
 *    or cycle-stmt
 *    or deallocate-stmt
 *    or end-function-stmt
 *    or end-mp-subprogram-stmt        // NEW_TO_2008
 *    or end-program-stmt
 *    or end-subroutine-stmt
 *    or endfile-stmt
 *    or exit-stmt
 *    or flush-stmt
 *    or forall-stmt
 *    or goto-stmt
 *    or if-stmt
 *    or inquire-stmt
 *    or lock-stmt                     // NEW_TO_2008
 *    or nullify-stmt
 *    or open-stmt
 *    or pointer-assignment-stmt
 *    or print-stmt
 *    or read-stmt
 *    or return-stmt
 *    or rewind-stmt
 *    or stop-stmt
 *    or sync-all-stmt                 // NEW_TO_2008
 *    or sync-images-stmt              // NEW_TO_2008
 *    or sync-memory-stmt              // NEW_TO_2008
 *    or unlock-stmt                   // NEW_TO_2008
 *    or wait-stmt
 *    or where-stmt
 *    or write-stmt
 *    or arithmetic-if-stmt
 *    or computed-goto-stmt
 */

////////////
// R214-F08
//
// C201-F08   (R208) An execution-part shall not contain an end-function-stmt,
//  end-mp-subprogram-stmt, end-program-stmt, or end-subroutine-stmt.
//
//     (But they can be in a branch target statement, which is not in the grammar,
//      so the end-xxx-stmts deleted.)
// TODO continue-stmt is ambiguous with same in end-do, check for label and if
// label matches do-stmt label, then match end-do there
// the original generated rules do not allow the label, so add (label)?
//
action_stmt
@after {
    action.action_stmt();
}
// Removed backtracking by inserting extra tokens in the stream by the prepass
// that signals whether we have an assignment-stmt, a pointer-assignment-stmt,
// or an arithmetic if.  This approach may work for other parts of backtracking
// also.  However, need to see if there is a way to define tokens w/o defining
// them in the lexer so that the lexer doesn't have to add them to it's parsing.
//  02.05.07
   :   allocate_stmt
   |   allstop_stmt              // NEW_TO_2008
   |   assignment_stmt
   |   backspace_stmt
   |   call_stmt
   |   close_stmt
   |   continue_stmt
   |   cycle_stmt
   |   deallocate_stmt
//   |   end_function_stmt
//   |   end_mp_subprogram_stmt        // NEW_TO_2008
//   |   end_program_stmt
//   |   end_subroutine_stmt
   |   endfile_stmt
   |   exit_stmt
   |   flush_stmt
   |   forall_stmt
   |   goto_stmt
   |   if_stmt
   |   inquire_stmt  
   |   lock_stmt                     // NEW_TO_2008
   |   nullify_stmt
   |   open_stmt
   |   pointer_assignment_stmt
   |   print_stmt
   |   read_stmt
   |   return_stmt
   |   rewind_stmt
   |   stop_stmt
   |   sync_all_stmt                 // NEW_TO_2008
//   |   sync_images_stmt              // NEW_TO_2008
//   |   sync_memory_stmt              // NEW_TO_2008
//   |   unlock_stmt                   // NEW_TO_2008
   |   wait_stmt
   |   where_stmt
   |   write_stmt
   |   arithmetic_if_stmt
   |   computed_goto_stmt
   |   assign_stmt                   // ADDED?
   |   assigned_goto_stmt            // ADDED?
   |   pause_stmt                    // ADDED?
   ;


/*
 * R856-F08 allstop-stmt
 *    is ALL STOP [ stop-code ]
 */

////////////
// R856-F08
//
allstop_stmt
@init {Token lbl = null; boolean hasStopCode = false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_ALL T_STOP (stop_code {hasStopCode=true;})? 
            end_of_stmt
            { action.allstop_stmt(lbl, $T_ALL, $T_STOP, $end_of_stmt.tk, hasStopCode); }
    ;


/*
 * R858-F08 sync-all-stmt
 *    is SYNC ALL [([ sync-stat-list ])]
 */
 
////////////
// R858-F08
//
sync_all_stmt
@init {Token lbl = null; boolean hasSyncStatList = false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_SYNC T_ALL
             (sync_stat_list {hasSyncStatList=true;})?
             end_of_stmt
             { action.sync_all_stmt(lbl, $T_SYNC, $T_ALL, $end_of_stmt.tk, hasSyncStatList); }
    ;


/*
 * R859-F08 sync-stat
 *    is STAT = stat-variable
 *    or ERRMSG = errmsg-variable
 */
 
////////////
// R859-F08
//
sync_stat
    :    T_IDENT T_EQUALS expr    // expr is a stat-variable or an errmsg-variable
             /* {'STAT','ERRMSG'} exprs are variables */
             { action.sync_stat($T_IDENT); }
    ;

sync_stat_list
@init{int count=0;}
    :       {action.sync_stat_list__begin();}
        sync_stat {count++;} ( T_COMMA sync_stat {count++;} )*
            {action.sync_stat_list(count);}
    ;


/*
 * R863-F08 lock-stmt
 *    is LOCK ( lock-variable [, lock-stat-list ] )
 */
 
////////////
// R863-F08
//
lock_stmt
@init {Token lbl = null; boolean hasLockStatList = false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_LOCK lock_variable
             (lock_stat_list {hasLockStatList=true;})?
             end_of_stmt
             { action.lock_stmt(lbl, $T_LOCK, $end_of_stmt.tk, hasLockStatList); }
    ;

/*
 * R864-F08 lock-stat
 *    is ACQUIRED_LOCK = scalar-logical-variable
 *    or sync-stat
 */
 
////////////
// R864-F08
//
// TODO - replace expr with scalar_logical_variable
lock_stat 
   :   T_ACQUIRED_LOCK T_EQUALS expr    // expr is a scalar-logical-variable
          { action.lock_stat($T_ACQUIRED_LOCK); }
   |   sync_stat
   ;

lock_stat_list
@init{int count=0;}
    :       {action.lock_stat_list__begin();}
        lock_stat {count++;} ( T_COMMA lock_stat {count++;} )*
            {action.lock_stat_list(count);}
    ;


/*
 * R866-F08 lock-variable
 *    is scalar-variable
 */
 
////////////
// R866-F08
//
// TODO - make expr a scalar-variable
lock_variable
   :   expr    // expr is a scalar-variable
          { action.lock_variable(); }
   ;

