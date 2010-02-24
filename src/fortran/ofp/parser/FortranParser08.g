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
 * R213-F08 executable-construct
 *    is action-stmt
 *    or associate-construct
 *    or block-construct               // NEW_TO_2008
 *    or case-construct
 *    or critical-construct            // NEW_TO_2008
 *    or do-construct
 *    or forall-construct
 *    or if-construct
 *    or select-type-construct
 *    or where-construct
 */

////////////
// R214-F08
//
executable_construct
@after {
    action.executable_construct();
}
   :   action_stmt
   |   associate_construct
//   |   block_construct                 // NEW_TO_2008
   |   case_construct
//   |   or critical_construct           // NEW_TO_2008
   |   do_construct
   |   forall_construct
   |   if_construct
   |   select_type_construct
   |   where_construct
   |   rice_with_team_construct
   ;


/*
 * R214-F08 action-stmt
 *    is allocate-stmt
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
 *    or errorstop-stmt                // NEW_TO_2008
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
   |   errorstop_stmt                // NEW_TO_2008
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
   |   sync_images_stmt              // NEW_TO_2008
   |   sync_memory_stmt              // NEW_TO_2008
   |   unlock_stmt                   // NEW_TO_2008
   |   wait_stmt
   |   where_stmt
   |   write_stmt
   |   arithmetic_if_stmt
   |   computed_goto_stmt
   |   assign_stmt                   // ADDED?
   |   assigned_goto_stmt            // ADDED?
   |   pause_stmt                    // ADDED?
   ;

/**
 * Section/Clause 4: Types
 */


/*
 * R437-F08 component-attr-spec
 *    is access-spec
 *    or ALLOCATABLE
 *    or CODIMENSION lbracket coarray-spec rbracket  // NEW_TO_2008
 *    or CONTIGUOUS                                  // NEW_TO_2008
 *    or DIMENSION ( component-array-spec )
 *    or POINTER
 */

////////////
// R437-F08, R441-F03
//
// R441, R442-F2008
// TODO it appears there is a bug in the standard for a parameterized type,
//      it needs to accept KIND, LEN keywords, see NOTE 4.24 and 4.25
component_attr_spec
   :   access_spec
          {action.component_attr_spec(null, IActionEnums.ComponentAttrSpec_access_spec);}
   |   T_ALLOCATABLE
          {action.component_attr_spec($T_ALLOCATABLE, IActionEnums.ComponentAttrSpec_allocatable);}
   |   T_CODIMENSION T_LBRACKET coarray_spec T_RBRACKET          // NEW_TO_2008 
          {action.component_attr_spec($T_CODIMENSION, IActionEnums.ComponentAttrSpec_codimension);}
   |   T_CONTIGUOUS                                              // NEW_TO_2008 
          {action.component_attr_spec($T_CONTIGUOUS, IActionEnums.ComponentAttrSpec_contiguous);}
   |   T_DIMENSION T_LPAREN component_array_spec T_RPAREN
          {action.component_attr_spec($T_DIMENSION, IActionEnums.ComponentAttrSpec_dimension);}
   |   T_POINTER
          {action.component_attr_spec($T_POINTER, IActionEnums.ComponentAttrSpec_pointer);}
    // are T_KIND and T_LEN correct?
//   |   T_KIND
//          {action.component_attr_spec($T_KIND, 
//                  IActionEnums.ComponentAttrSpec_kind);}
//   |   T_LEN
//          {action.component_attr_spec($T_LEN, 
//                  IActionEnums.ComponentAttrSpec_len);}
	;

/*
 * R438-F08 component-decl
 *    is component-name [ ( component-array-spec ) ]
 *                      [ lbracket coarray-spec rbracket ]  // NEW_TO_2008
 *                      [ * char-length ] [ component-initialization ]
 */

/**
 * Section/Clause 5: Attribute declarations and specifications
 */

/*
 * R502-F08 attr-spec
 *    is access-spec
 *    or ALLOCATABLE
 *    or ASYNCHRONOUS
 *    or CODIMENSION lbracket coarray-spec rbracket  // NEW_TO_2008
 *    or CONTIGUOUS                                  // NEW_TO_2008
 *    or DIMENSION ( array-spec )
 *    or EXTERNAL
 *    or INTENT ( intent-spec )
 *    or INTRINSIC
 *    or language-binding-spec
 *    or OPTIONAL
 *    or PARAMETER
 *    or POINTER
 *    or PROTECTED
 *    or SAVE
 *    or TARGET
 *    or VALUE
 *    or VOLATILE
 */

////////////
// R502-F08, R503-F03
//
attr_spec
   :   access_spec
           {action.attr_spec(null, IActionEnums.AttrSpec_access);}
   |   T_ALLOCATABLE
           {action.attr_spec($T_ALLOCATABLE, IActionEnums.AttrSpec_ALLOCATABLE);}
   |   T_ASYNCHRONOUS
           {action.attr_spec($T_ASYNCHRONOUS, IActionEnums.AttrSpec_ASYNCHRONOUS);}
   |   T_CODIMENSION T_LBRACKET coarray_spec T_RBRACKET  // NEW_TO_2008
           {action.attr_spec($T_CODIMENSION, IActionEnums.AttrSpec_CODIMENSION);}
   |   T_CONTIGUOUS                                      // NEW_TO_2008
           {action.attr_spec($T_CONTIGUOUS, IActionEnums.AttrSpec_CONTIGUOUS);}
   |   T_DIMENSION T_LPAREN array_spec T_RPAREN
           {action.attr_spec($T_DIMENSION, IActionEnums.AttrSpec_DIMENSION);}
   |   T_EXTERNAL
           {action.attr_spec($T_EXTERNAL, IActionEnums.AttrSpec_EXTERNAL);}
   |   T_INTENT T_LPAREN intent_spec T_RPAREN
           {action.attr_spec($T_INTENT, IActionEnums.AttrSpec_INTENT);}
   |   T_INTRINSIC
           {action.attr_spec($T_INTRINSIC, IActionEnums.AttrSpec_INTRINSIC);}
   |   language_binding_spec		
           {action.attr_spec(null, IActionEnums.AttrSpec_language_binding);}
   |   T_OPTIONAL
           {action.attr_spec($T_OPTIONAL, IActionEnums.AttrSpec_OPTIONAL);}
   |   T_PARAMETER
           {action.attr_spec($T_PARAMETER, IActionEnums.AttrSpec_PARAMETER);}
   |   T_POINTER
           {action.attr_spec($T_POINTER, IActionEnums.AttrSpec_POINTER);}
   |   T_PROTECTED
           {action.attr_spec($T_PROTECTED, IActionEnums.AttrSpec_PROTECTED);}
   |   T_SAVE
           {action.attr_spec($T_SAVE, IActionEnums.AttrSpec_SAVE);}
   |   T_TARGET
           {action.attr_spec($T_TARGET, IActionEnums.AttrSpec_TARGET);}
   |   T_VALUE
           {action.attr_spec($T_VALUE, IActionEnums.AttrSpec_VALUE);}
   |   T_VOLATILE
           {action.attr_spec($T_VOLATILE, IActionEnums.AttrSpec_VOLATILE);}
// TODO are T_KIND and T_LEN correct?
    |   T_KIND
           {action.attr_spec($T_KIND, IActionEnums.AttrSpec_KIND);}
    |   T_LEN
           {action.attr_spec($T_LEN, IActionEnums.AttrSpec_LEN);}
	;

/*
 * R503-F08 entity-decl
 *    is object-name [( array-spec )]
 *         [ lracket coarray-spec rbracket ]
 *         [ * char-length ] [ initialization ]
 *    or function-name [ * char-length ]
 */

////////////
// R503-F08, R504-F03
//
// T_IDENT inlined for object_name and function_name
// T_IDENT ( T_ASTERISK char_length )? takes character and function
// TODO Pass more info to action....
entity_decl
@init{boolean hasArraySpec=false; boolean hasCoarraySpec=false; boolean hasCharLength=false;}
    : T_IDENT ( T_LPAREN array_spec T_RPAREN {hasArraySpec=true;})?
              ( T_LBRACKET coarray_spec T_RBRACKET {hasCoarraySpec=true;})?
              ( T_ASTERISK char_length {hasCharLength=true;})? ( initialization )?
		{action.entity_decl($T_IDENT, hasArraySpec, hasCoarraySpec, hasCharLength);}
    ;

/*
 * R509-F08 coarray-spec
 *    is deferred-coshape-spec-list
 *    or explicit-coshape-spec
 */

////////////
// R509-F08
//
coarray_spec
@init
{
   boolean hasDeferred = false;
   boolean hasExplicit = false;
}
@after {
    action.coarray_spec(hasDeferred, hasExplicit);
}
   :   deferred_coshape_spec_list  {hasDeferred=true;}
   |   explicit_coshape_spec       {hasExplicit=true;}
   ;

/*
 * R510-F08 deferred-coshape-spec
 *    is :
 */

////////////
// R510-F08
//
deferred_coshape_spec
   :   T_COLON
           { action.deferred_coshape_spec($T_COLON); }
   ;

deferred_coshape_spec_list
@init{int count=0;}
   :       {action.deferred_coshape_spec_list__begin();}
       T_COLON {count++;}( T_COMMA T_COLON {count++;})?
           {action.deferred_coshape_spec_list(count);}
   ;

/*
 * R511-08 explicit-coshape-spec
 *    is [ [ lower-cobound : ] upper-cobound, ]...
 *           [ lower-cobound : ] *
 */

////////////
// R511-F08
//
explicit_coshape_spec
@after {
    action.explicit_coshape_spec();
}
   :   T_XYZ expr explicit_coshape_spec_suffix
   |   T_ASTERISK
   ;

// TODO add more info to action
explicit_coshape_spec_suffix
@after {
    action.explicit_coshape_spec_suffix();
}
   :   T_COLON T_ASTERISK
   |   T_COMMA explicit_coshape_spec
   |   T_COLON expr explicit_coshape_spec
   ;


/**
 * Section/Clause 6: Use of data objects
 */               

/*
 * R624-F08 image-selector
 *    is lbracket cosubscript-list rbracket
 */

////////////
// R624-F08
//
//image_selector
//   :   T_LBRACKET cosubscript_list T_RBRACKET
//           { action.image_selector($T_LBRACKET, $T_RBRACKET); }
//   ;

/*
 * R625-F08 cosubscript
 *    is scalar-int-expr
 */

////////////
// R625-F08
//
//cosubscript
//   :   scalar_int_expr

//cosubscript_list
//@init{int count=0;}
//   :       {action.cosubscript_list__begin();}
//       cosubscript {count++;} ( T_COMMA cosubscript {count++;} )*
//           {action.cosubscript_list(count);}
//   ;

/*
 * R636-F08 allocate-coarray-spec
 *    is   [ allocate-coshape-spec-list , ] [ lower-bound-expr : ] *
 */

////////////
// R637-F08
//
//allocate_coarray_spec
//    :   /* ( allocate_coshape_spec_list T_COMMA )? ( expr T_COLON )? */ 
//            T_ASTERISK
//            { action.allocate_coarray_spec(); }
//    ;

/*
 * R637-F08 allocate-coshape-spec
 *    is   [ lower-bound-expr : ] upper-bound-expr
 */

////////////
// R637-F08
//
//allocate_coshape_spec
//@init { boolean hasExpr = false; }
//    :    expr ( T_COLON expr { hasExpr = true; })?
//            { action.allocate_coshape_spec(hasExpr); }
//    ;

//allocate_coshape_spec_list
//@init{ int count=0;}
//    :  		{action.allocate_coshape_spec_list__begin();}
//		allocate_coshape_spec {count++;} 
//            ( T_COMMA allocate_coshape_spec {count++;} )*
//      		{action.allocate_coshape_spec_list(count);}
//    ;

/*
 * Section/Clause 8: Execution control
 */

/*
 * R807-F08 block-construct
 *    is block-stmt
 *       [ specification-part ]
 *       block
 *       end-block-stmt
 */

/*
 * R808-F08 block-stmt
 *    is [ block-construct-name : ] BLOCK
 */

/*
 * R809-F08 end-block-stmt
 *    is END BLOCK [ block-construct-name ]
 */


/*
 * R856-F08 errorstop-stmt
 *    is ERROR STOP [ stop-code ]
 */

////////////
// R856-F08
//
errorstop_stmt
@init {Token lbl = null; boolean hasStopCode = false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_ERROR T_STOP (stop_code {hasStopCode=true;})? 
            end_of_stmt
            { action.errorstop_stmt(lbl, $T_ERROR, $T_STOP, $end_of_stmt.tk, hasStopCode); }
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
   :   (label {lbl=$label.tk;})? T_SYNC T_ALL
       (T_LPAREN T_RPAREN)? end_of_stmt
             { action.sync_all_stmt(lbl, $T_SYNC, $T_ALL, $end_of_stmt.tk, hasSyncStatList); }
   |   (label {lbl=$label.tk;})? T_SYNC T_ALL
       T_LPAREN sync_stat_list T_RPAREN end_of_stmt
             { action.sync_all_stmt(lbl, $T_SYNC, $T_ALL, $end_of_stmt.tk, true); }
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
 * R860-F08 sync-images-stmt
 *    is SYNC IMAGES ( image-set [, sync-stat-list ] )
 */
 
////////////
// R860-F08
//
sync_images_stmt
@init {Token lbl = null; boolean hasSyncStatList = false;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})? T_SYNC T_IMAGES
       T_LPAREN image_set (T_COMMA sync_stat_list {hasSyncStatList=true;})? T_RPAREN
       end_of_stmt
             { action.sync_images_stmt(lbl, $T_SYNC, $T_IMAGES, $end_of_stmt.tk, hasSyncStatList); }
   ;


/*
 * R861-F08 image-set
 *    is int-expr
 *    or *
 */
 
////////////
// R861-F08
//
image_set
@init {Token asterisk = null; boolean hasIntExpr = false;}
   :   expr 
             { hasIntExpr = true; action.image_set(asterisk, hasIntExpr); }
   |   T_ASTERISK
             { asterisk = $T_ASTERISK; action.image_set(asterisk, hasIntExpr); }
   ;


/*
 * R862-F08 sync-memory-stmt
 *    is SYNC MEMORY [([ sync-stat-list ])]
 */
 
////////////
// R862-F08
//
sync_memory_stmt
@init {Token lbl = null; boolean hasSyncStatList = false;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})? T_SYNC T_MEMORY
       (T_LPAREN T_RPAREN)? end_of_stmt
             { action.sync_memory_stmt(lbl, $T_SYNC, $T_MEMORY, $end_of_stmt.tk, hasSyncStatList); }
   |   (label {lbl=$label.tk;})? T_SYNC T_MEMORY
       T_LPAREN sync_stat_list T_RPAREN end_of_stmt
             { action.sync_memory_stmt(lbl, $T_SYNC, $T_MEMORY, $end_of_stmt.tk, true); }
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
 * R865-F08 unlock-stmt
 *    is UNLOCK ( lock-variable [, lock-stat-list ] )
 */
 
////////////
// R865-F08
//
unlock_stmt
@init {Token lbl = null; boolean hasSyncStatList = false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_UNLOCK lock_variable
             (sync_stat_list {hasSyncStatList=true;})?
             end_of_stmt
             { action.unlock_stmt(lbl, $T_UNLOCK, $end_of_stmt.tk, hasSyncStatList); }
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


//----------------------------------------------------------------------------
// RICE CO-ARRAY FORTRAN RULES
// ---------------------------
// All Rice's rules and actions will prefixed with "rice_" keyword
//----------------------------------------------------------------------------

// Laks 2009.01.13: add declaration of rice caf
rice_coshape_spec:
	T_ASTERISK
	;
	
// Laks 2009.01.15: add rice caf reference
rice_image_selector
@init {
    Token idTeam=null;
}
	:	T_LBRACKET expr (T_AT T_IDENT {idTeam=$T_IDENT;})? T_RBRACKET
            { action.rice_image_selector(idTeam);	}
	;

// Laks 2009.01.15: add rice caf allocation
// the allocation is either using asterisk (with means all ranks) or team
rice_allocate_coarray_spec:
		T_ASTERISK	{ action.rice_allocate_coarray_spec(0,null); }
	|
		T_AT T_IDENT { action.rice_allocate_coarray_spec(1,$T_IDENT); }
	|
		{ action.rice_allocate_coarray_spec(-1,null); }
	;

// Laks 2009.02.03: in order to make "with team" more structured, we need to force
// it into a construct block instead of statement. A disadvantage of this approach is
// lack of flexibility and users are forced to use "end with team"
rice_with_team_construct
	: rice_co_with_team_stmt block rice_end_with_team_stmt
	;
	
// Laks 2009.01.20: the default team construct	
// statement to specify the default team
rice_co_with_team_stmt
@init{Token lbl = null;}
	:	
	(label {lbl=$label.tk;})? (T_WITHTEAM | T_WITH T_TEAM) T_IDENT
	end_of_stmt
	{
	  action.rice_co_with_team_stmt(lbl, $T_IDENT);
	}
	;
	

// R824
// T_IDENT inlined for select_construct_name
rice_end_with_team_stmt
@init{Token lbl = null; Token id = null;}
	: 
	 (label {lbl=$label.tk;})? T_END (T_WITHTEAM | T_WITH T_TEAM) 
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.rice_end_with_team_stmt(lbl, id, 
                $end_of_stmt.tk);}
	;
