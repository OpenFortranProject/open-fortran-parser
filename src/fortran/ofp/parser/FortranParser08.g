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
   int gCount1;
   int gCount2;

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
   action.main_program__begin();
}
   :   ( program_stmt {hasProgramStmt = true;} )?
       specification_part
       ( execution_part {hasExecutionPart = true;} )?
       ( internal_subprogram_part {hasInternalSubprogramPart = true;} )?
       end_program_stmt
         {
           action.main_program(hasProgramStmt, hasExecutionPart, hasInternalSubprogramPart);
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


////////////
// R204-F08
//
specification_part
@init{int numUseStmts=0; int numImportStmts=0; gCount1=0; gCount2=0;}
   :   ( use_stmt {numUseStmts++;} )*
       ( import_stmt {numImportStmts++;} )*
       implicit_part_recursion // making nonoptional with predicates fixes ambiguity
       ( declaration_construct {gCount2++;} )*
           {action.specification_part(numUseStmts, numImportStmts, gCount1, gCount2);}
   ;

/*
 * R205-F08   implicit-part           is [ implicit-part-stmt ] ...
 *                                       implicit-stmt
 */

/*
 * R206-F08   implicit-part-stmt      is implicit-stmt
 *                                    or parameter-stmt
 *                                    or format-stmt
 *                                    or entry-stmt
 */

////////////
// R205-F08
// R206-F08 combined
//
implicit_part_recursion
   :   ((label)? T_IMPLICIT)  => implicit_stmt  {gCount1++;} implicit_part_recursion
   |   ((label)? T_PARAMETER) => parameter_stmt {gCount2++;} implicit_part_recursion
   |   ((label)? T_FORMAT)    => format_stmt    {gCount2++;} implicit_part_recursion
   |   ((label)? T_ENTRY)     => entry_stmt     {gCount2++;} implicit_part_recursion
   |   // empty
   ;

/*
 * R207-F08 declaration-construct
 *    is derived-type-def
 *    or entry-stmt
 *    or enum-def                      // NEW_NAME_2008 (was enum-alias-def)
 *    or format-stmt
 *    or interface-block
 *    or parameter-stmt
 *    or procedure-declaration-stmt
 *    or other-specification-stmt      // NEW_NAME_2008 (was specification-stmt)
 *    or type-declaration-stmt
 *    or stmt-function-stmt
 */

////////////
// R207-F08
//
declaration_construct
@after {action.declaration_construct();}
   :   derived_type_def
   |   entry_stmt
   |   enum_def
   |   format_stmt
   |   interface_block
   |   parameter_stmt
   |   procedure_declaration_stmt
   |   other_specification_stmt
   |   type_declaration_stmt
   |   stmt_function_stmt
   ;

/*
 * R210-F08 internal-subprogram-part
 *    is contains-stmt
 *          [ internal-subprogram ] ...  // DIFFERENT_2008 (can have empty contains)
 */

////////////
// R210-F08
//
internal_subprogram_part
@init{int count = 0;}
   :   contains_stmt
       ( internal_subprogram {count += 1;} )*
           { action.internal_subprogram_part(count); }
   ;

/*
 * R212-F08 other-specification-stmt   // NEW_NAME_2008 (was specification-stmt)
 *    is access-stmt
 *    or allocatable-stmt
 *    or asynchronous-stmt
 *    or bind-stmt
 *    or codimension-stmt              // NEW_TO_2008
 *    or common-stmt
 *    or data-stmt
 *    or dimension-stmt
 *    or equivalence-stmt
 *    or external-stmt
 *    or intent-stmt
 *    or intrinsic-stmt
 *    or namelist-stmt
 *    or optional-stmt
 *    or pointer-stmt
 *    or protected-stmt
 *    or save-stmt
 *    or target-stmt
 *    or volatile-stmt
 *    or value-stmt
 */

////////////
// R212-F08
//
other_specification_stmt
@after {action.specification_stmt();}
   :   access_stmt
   |   allocatable_stmt
   |   asynchronous_stmt
   |   bind_stmt
   |   codimension_stmt                // NEW_TO_2008
   |   common_stmt
   |   data_stmt
   |   dimension_stmt
   |   equivalence_stmt
   |   external_stmt
   |   intent_stmt
   |   intrinsic_stmt
   |   namelist_stmt
   |   optional_stmt
   |   pointer_stmt
   |   protected_stmt
   |   save_stmt
   |   target_stmt
   |   volatile_stmt
   |   value_stmt
   ;

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
@after {action.executable_construct();}
   :   action_stmt
   |   associate_construct
   |   block_construct                 // NEW_TO_2008
   |   case_construct
   |   critical_construct              // NEW_TO_2008
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
@after {action.action_stmt();}
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
//////////
// These end functions are not needed because the initiating constructs are called
// explicitly to avoid ambiguities.
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

////////////
// R438-F08, R433-F03
//
// R442-F2008, R441-F03
// R443-F2008, F442-F03
// T_IDENT inlined as component_name
component_decl
@init { 
    boolean hasComponentArraySpec = false; 
	boolean hasCoarraySpec = false;
	boolean hasCharLength = false;
	boolean hasComponentInitialization = false;
}
   :   T_IDENT (T_LPAREN component_array_spec T_RPAREN {hasComponentArraySpec=true;})?
               (T_LBRACKET coarray_spec T_RBRACKET {hasCoarraySpec=true;})?
               (T_ASTERISK char_length {hasCharLength=true;})? 
               (component_initialization {hasComponentInitialization =true;})?
           {action.component_decl($T_IDENT, hasComponentArraySpec, 
                                  hasCoarraySpec, hasCharLength,
                                  hasComponentInitialization);}
   ;


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


/*
Section 5:
 */

// R501
type_declaration_stmt
@init {Token lbl = null; int numAttrSpecs = 0;}
@after{checkForInclude();}
    :	(label {lbl=$label.tk;})? rice_declaration_type_spec
		( (T_COMMA attr_spec {numAttrSpecs += 1;})* T_COLON_COLON )?
		entity_decl_list end_of_stmt
    		{ action.type_declaration_stmt(lbl, numAttrSpecs, 
                    $end_of_stmt.tk); }
    ;

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
@init{
   boolean hasArraySpec=false;
   boolean hasCoarraySpec=false;
   boolean hasCharLength=false;
   boolean hasInitialization=false;
}
   :   T_IDENT ( T_LPAREN array_spec T_RPAREN {hasArraySpec=true;} )?
               ( T_LBRACKET coarray_spec T_RBRACKET {hasCoarraySpec=true;} )?
               ( T_ASTERISK char_length {hasCharLength=true;} )?
               ( initialization {hasInitialization=true;} )?
          {
             action.entity_decl($T_IDENT, hasArraySpec,
                                hasCoarraySpec, hasCharLength, hasInitialization);
          }
   ;

/*
 * R509-F08 coarray-spec
 *    is deferred-coshape-spec-list
 *    or explicit-coshape-spec
 */

////////////
// R509-F08
//
// deferred-coshape-spec-list and explicit-coshape-spec rules are ambiguous so
// we use the same method as for array-spec.  Enough information is provided so
// that the coarray_spec can be figured out by the ctions.  Note, that this
// means the parser can't determine all incorrect syntax as many rules are
// combined into one.  It is the action's responsiblity to enforce correct syntax.
//
coarray_spec
@init{int count=0;}
   :   array_spec_element {count++;} (T_COMMA array_spec_element {count++;})*
			{action.coarray_spec(count);}
	;

/*
 * R510-F08 deferred-coshape-spec
 *    is :
 */

////////////
// R510-F08
//
// deferred_coshape_spec is replaced by array_spec (see R509-F08)
//

/*
 * R511-08 explicit-coshape-spec
 *    is [ [ lower-cobound : ] upper-cobound, ]...
 *           [ lower-cobound : ] *
 */

////////////
// R511-F08
//
// explicit_coshape_spec is replaced by array_spec (see R509-F08)
//

/*
 * R527-F08 allocatable-decl
 *    is object-name [ ( array-spec ) ] [ lbracket ( coarray-spec ) ]
 */

////////////
// R527-F08
//
allocatable_decl
@init{Token objName=null; boolean hasArraySpec=false; boolean hasCoarraySpec=false;}
   :   object_name {objName=$object_name.tk;}
          ( T_LPAREN array_spec T_RPAREN {hasArraySpec=true;} )?
          ( T_LBRACKET coarray_spec T_RBRACKET {hasCoarraySpec=true;} )?
              {action.allocatable_decl(objName, hasArraySpec, hasCoarraySpec);}
   ;

/*
 * R531-F08 codimension-stmt
 *    is CODIMENSION [ :: ] codimension-decl-list
 */

////////////
// R531-F08
//
codimension_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_CODIMENSION ( T_COLON_COLON )? codimension_decl_list end_of_stmt
          { action.codimension_stmt(lbl, $T_CODIMENSION, $end_of_stmt.tk); }
   ;
   
/*
 * R532-08 codimension-decl
 *    is coarray-name lbracket coarray-spec rbracket
 */

////////////
// R532-F08
//
codimension_decl
   :   T_IDENT T_LBRACKET coarray_spec T_RBRACKET
           {action.codimension_decl($T_IDENT, $T_LBRACKET, $T_RBRACKET);}
   ;

codimension_decl_list
@init{int count=0;}
   :       {action.codimension_decl_list__begin();}
       codimension_decl {count++;} ( T_COMMA codimension_decl {count++;} )*
           {action.codimension_decl_list(count);}
   ;

/*
 * R557-F08 target-decl
 *    is   object-name [ ( array-spec ) ]
 *                     [ lbracket coarray-spec rbracket ]
 */

////////////
// R557-F08
//
target_decl
@init{boolean hasArraySpec=false; boolean hasCoarraySpec=false;}
   :   T_IDENT (T_LPAREN array_spec T_RPAREN {hasArraySpec=true;} )?
               (T_LBRACKET coarray_spec T_RBRACKET {hasCoarraySpec=true;} )?
          {action.target_decl($T_IDENT,hasArraySpec,hasCoarraySpec);}
   ;


/**
 * Section/Clause 6: Use of data objects
 */               

// R601
variable
        :       designator {action.variable();}
        ;

// R603
//  :   object-name             // T_IDENT (data-ref isa T_IDENT)
//	|	array-element           // R616 is data-ref
//	|	array-section           // R617 is data-ref [ (substring-range) ] 
//	|	structure-component     // R614 is data-ref
//	|	substring
// (substring-range) may be matched in data-ref
// this rule is now identical to substring
designator
@init{boolean hasSubstringRange = false;}
	:	data_ref (T_LPAREN substring_range {hasSubstringRange=true;} T_RPAREN)?
			{ action.designator(hasSubstringRange); }
	|	char_literal_constant T_LPAREN substring_range T_RPAREN
			{ hasSubstringRange=true; action.substring(hasSubstringRange); }
	;

/*
 * R612-F08 part-ref
 *    is part-name [ ( section-subscript-list ) ] [ image-selector]
 */


////////////
// R612-F08
// R613-F03
//
// T_IDENT inlined for part_name
// with k=2, this path is chosen over T_LPAREN substring_range T_RPAREN
// TODO error: if a function call, should match id rather than 
// (section_subscript_list)
// a = foo(b) is ambiguous YUK...
part_ref
options {k=2;}
@init{boolean hasSSL = false; boolean hasImageSelector = false;}
   :   (T_IDENT T_LPAREN) => T_IDENT T_LPAREN section_subscript_list T_RPAREN
       (image_selector {hasImageSelector=true;})?
           {hasSSL=true; action.part_ref($T_IDENT, hasSSL, hasImageSelector);}
   |   (T_IDENT T_LBRACKET) => T_IDENT image_selector
           {hasImageSelector=true; action.part_ref($T_IDENT, hasSSL, hasImageSelector);}
   |   T_IDENT
           {action.part_ref($T_IDENT, hasSSL, hasImageSelector);}
   ;

/*
 * R624-F08 image-selector
 *    is lbracket cosubscript-list rbracket
 */

////////////
// R624-F08
//
image_selector
   :   T_LBRACKET rice_cosubscript_list T_RBRACKET
           {action.image_selector($T_LBRACKET, $T_RBRACKET);}
   ;

/*
 * R625-F08 cosubscript
 *    is scalar-int-expr
 */

////////////
// R625-F08
//
cosubscript
   :   scalar_int_expr
   ;

cosubscript_list
@init{int count=0;}
   :       {action.cosubscript_list__begin();}
       cosubscript {count++;} ( T_COMMA cosubscript {count++;} )*
           {action.cosubscript_list(count, null);}
   ;

/*
 * R631-08 allocation
 *    is allocate-object [ ( allocate-shape-spec-list ) ]
 *                       [ lbracket allocate-coarray-spec rbracket ]  // NEW_TO_2008
 */

////////////
// R631-F08, R628-F03
//
allocation
@init{boolean hasAllocateShapeSpecList = false; boolean hasAllocateCoarraySpec = false;}
   :   allocate_object
       ( T_LPAREN allocate_shape_spec_list {hasAllocateShapeSpecList=true;} T_RPAREN )?
       ( T_LBRACKET allocate_coarray_spec {hasAllocateCoarraySpec=true;} T_RBRACKET )?
       ( T_LBRACKET rice_allocate_coarray_spec {hasAllocateCoarraySpec=true;} T_RBRACKET )?
           {action.allocation(hasAllocateShapeSpecList, hasAllocateCoarraySpec);}
   ;

/*
 * R636-F08 allocate-coarray-spec
 *    is   [ allocate-coshape-spec-list , ] [ lower-bound-expr : ] *
 */

////////////
// R637-F08
//
allocate_coarray_spec
   :   /* ( allocate_coshape_spec_list T_COMMA )? ( expr T_COLON )? */
       T_ASTERISK
           { action.allocate_coarray_spec(); }
   ;

/*
 * R637-F08 allocate-coshape-spec
 *    is   [ lower-bound-expr : ] upper-bound-expr
 */

////////////
// R637-F08
//
allocate_coshape_spec
@init { boolean hasExpr = false; }
   :   expr ( T_COLON expr { hasExpr = true; })?
           { action.allocate_coshape_spec(hasExpr); }
   ;

allocate_coshape_spec_list
@init{ int count=0;}
   :       {action.allocate_coshape_spec_list__begin();}
       allocate_coshape_spec {count++;} ( T_COMMA allocate_coshape_spec {count++;} )*
           {action.allocate_coshape_spec_list(count);}
   ;


/*
 * Section/Clause 7: Expressions and assignment
 */

/*
 * R724-F08 logical-expr
 *    is expr
 */

////////////
// R724-F08, R724-F03
//
logical_expr
   :   expr
   ;

scalar_logical_expr
   :   expr
   ;


/*
 * R726-08 int-expr
 *    is   expr
 */

////////////
// R726-F08, R727-F03
//
int_expr
   :   expr
   ;

scalar_int_expr
   :   expr
   ;


//----------------------------------------------------------------------------
// additional rules following standard and useful for error checking
//----------------------------------------------------------------------------

scalar_variable
   :   expr
   ;

/*
 * Section/Clause 8: Execution control
 */

/*
 * R807-F08 block-construct
 *    is block-stmt
 *       [ specification-part ]
 *       block
 *       end-block-stmt
 *
 * C806-F08 (R807-F08) The specification-part of a BLOCK construct shall not contain a
 * COMMON, EQUIVALENCE, IMPLICIT, INTENT, NAMELIST, OPTIONAL, statement function, or
 * VALUE statement.
 *
 * C806-F08 means that the implicit-part in specification-part can be removed
 */

////////////
// R807-F08
//
block_construct
@after{action.block_construct();}
   :   block_stmt
         specification_part_and_block
       end_block_stmt
   ;

specification_part_and_block
@init{int numUseStmts=0; int numImportStmts=0; gCount1=0;}
   :   ( use_stmt {numUseStmts++;} )*
       ( import_stmt {numImportStmts++;} )*
       declaration_construct_and_block
           {action.specification_part_and_block(numUseStmts, numImportStmts, gCount1);}
   ;

declaration_construct_and_block
@init{gCount1++;}
   :   ((label)? T_ENTRY)      => entry_stmt       declaration_construct_and_block
   |   ((label)? T_ENUM)       => enum_def         declaration_construct_and_block
   |   ((label)? T_FORMAT)     => format_stmt      declaration_construct_and_block
   |   ((label)? T_INTERFACE)  => interface_block  declaration_construct_and_block
   |   ((label)? T_PARAMETER)  => parameter_stmt   declaration_construct_and_block
   |   ((label)? T_PROCEDURE)  => procedure_declaration_stmt
                                                   declaration_construct_and_block
   |   (derived_type_stmt)     => derived_type_def declaration_construct_and_block
   |   (type_declaration_stmt) => type_declaration_stmt declaration_construct_and_block

   // the following are from other_specification_stmt

   |   ((label)? access_spec)    => access_stmt       declaration_construct_and_block
   |   ((label)? T_ALLOCATABLE)  => allocatable_stmt  declaration_construct_and_block
   |   ((label)? T_ASYNCHRONOUS) => asynchronous_stmt declaration_construct_and_block
   |   ((label)? T_BIND)         => bind_stmt         declaration_construct_and_block
   |   ((label)? T_CODIMENSION)  => codimension_stmt  declaration_construct_and_block
   |   ((label)? T_DATA)         => data_stmt         declaration_construct_and_block
   |   ((label)? T_DIMENSION)    => dimension_stmt    declaration_construct_and_block
   |   ((label)? T_EXTERNAL)     => external_stmt     declaration_construct_and_block
   |   ((label)? T_INTRINSIC)    => intrinsic_stmt    declaration_construct_and_block
   |   ((label)? T_POINTER)      => pointer_stmt      declaration_construct_and_block
   |   ((label)? T_PROTECTED)    => protected_stmt    declaration_construct_and_block
   |   ((label)? T_SAVE)         => save_stmt         declaration_construct_and_block
   |   ((label)? T_TARGET)       => target_stmt       declaration_construct_and_block
   |   ((label)? T_VOLATILE)     => volatile_stmt     declaration_construct_and_block
   |   block {gCount1--; /* decrement extra count as this isn't a declConstruct */}
   ;


/*
 * R808-F08 block-stmt
 *    is [ block-construct-name : ] BLOCK
 */

////////////
// R808-F08
//
block_stmt
@init {Token lbl = null; Token name = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       (T_IDENT T_COLON {name=$T_IDENT;})?
       T_BLOCK end_of_stmt
           {action.block_stmt(lbl, name, $T_BLOCK, $end_of_stmt.tk);}
   ;

/*
 * R809-F08 end-block-stmt
 *    is END BLOCK [ block-construct-name ]
 */

////////////
// R809-F08
//
end_block_stmt
@init {Token lbl = null; Token name = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_END T_BLOCK (T_IDENT {name=$T_IDENT;})? end_of_stmt
           {action.end_block_stmt(lbl, name, $T_END, $T_BLOCK, $end_of_stmt.tk);}
   |   (label {lbl=$label.tk;})?
       T_ENDBLOCK (T_IDENT {name=$T_IDENT;})? end_of_stmt
           {action.end_block_stmt(lbl, name, $T_ENDBLOCK, null, $end_of_stmt.tk);}
   ;

/*
 * R810-F08 critical-construct
 *    is critical-stmt
 *          block
 *       end-critical-stmt
 */

////////////
// R810-F08
//
critical_construct
   :   critical_stmt block end_critical_stmt
           {action.critical_construct();}
   ;

/*
 * R811-F08 critical-stmt
 *    is [ critical-construct-name : ] CRITICAL
 */

////////////
// R811-F08
//
critical_stmt
@init {Token lbl = null; Token name = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       (T_IDENT T_COLON {name=$T_IDENT;})?
       T_CRITICAL end_of_stmt
           {action.critical_stmt(lbl, name, $T_CRITICAL, $end_of_stmt.tk);}
   ;

/*
 * R812-F08 end-critical-stmt
 *    is END CRITICAL [ critical-construct-name ]
 */

////////////
// R812-F08
//
end_critical_stmt
@init {Token lbl = null; Token name = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_END T_CRITICAL (T_IDENT {name=$T_IDENT;})? end_of_stmt
           {action.end_critical_stmt(lbl, name, $T_END, $T_CRITICAL, $end_of_stmt.tk);}
   ;

/*
 * R818-08 loop-control
 *    is   [ , ] do-variable = scalar-int-expr , scalar-int-expr [ , scalar-int-expr ]
 *    or   [ , ] WHILE ( scalar-logical-expr )
 *    or   [ , ] CONCURRENT forall-header
 */

////////////
// R818-F08, R830-F03
//
loop_control
@init {boolean hasOptExpr = false;}
   :   ( T_COMMA )? do_variable T_EQUALS scalar_int_expr T_COMMA scalar_int_expr
       ( T_COMMA scalar_int_expr {hasOptExpr=true;})?
           {action.loop_control(null, IActionEnums.DoConstruct_variable, hasOptExpr);}
   |   ( T_COMMA )? T_WHILE T_LPAREN scalar_logical_expr T_RPAREN 
           {action.loop_control($T_WHILE, IActionEnums.DoConstruct_while, hasOptExpr);}
   |   ( T_COMMA )? T_CONCURRENT forall_header
           {action.loop_control($T_CONCURRENT,
                                IActionEnums.DoConstruct_concurrent, hasOptExpr);}
   ;


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
   :   (label {lbl=$label.tk;})? T_ERROR T_STOP (stop_code {hasStopCode=true;})? 
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
   :   (label {lbl=$label.tk;})?
       T_UNLOCK lock_variable (sync_stat_list {hasSyncStatList=true;})? end_of_stmt
           {action.unlock_stmt(lbl, $T_UNLOCK, $end_of_stmt.tk, hasSyncStatList);}
   ;


/*
 * R866-F08 lock-variable
 *    is scalar-variable
 */
 
////////////
// R866-F08
//
lock_variable
   :   scalar_variable
          { action.lock_variable(); }
   ;


/*
 * Section/Clause 11: Modules
 */

/*
 * R1116-F08 submodule
 *     is submodule-stmt
 *           [ specification-part ]
 *           [ module-subprogram-part ]
 *     end-submodule-stmt
 */

////////////
// R1116-F08
//
submodule
@init {boolean hasModuleSubprogramPart = false;}
@after{action.submodule(hasModuleSubprogramPart);}
   :   submodule_stmt
       specification_part  // non-optional as can be empty
       ( module_subprogram_part {hasModuleSubprogramPart=true;} )?
       end_submodule_stmt
   ;


/*
 * R1117-F08 submodule-stmt
 *     is SUBMODULE ( parent-identifier ) submodule-name
 */

////////////
// R1117-F08
//
submodule_stmt
@init {Token lbl = null; Token t_subname = null;}
@after{checkForInclude();}
   :       {action.submodule_stmt__begin();}
       (label {lbl=$label.tk;})?
       T_SUBMODULE T_LPAREN parent_identifier T_RPAREN
       name {t_subname=$name.tk;} end_of_stmt
           {action.submodule_stmt(lbl, $T_SUBMODULE, t_subname, $end_of_stmt.tk);}
   ;


/*
 * R1118-F08 parent-identifier
 *     is ancestor-module-name [ : parent-submodule-name ]
 */

////////////
// R1118-F08
//
parent_identifier
@init {Token ancestor = null; Token parent = null;}
   :   name {ancestor=$name.tk;}
       ( : T_IDENT {parent=$T_IDENT;} )?
           {action.parent_identifier(ancestor, parent);}
   ;


/*
 * R1119-F08 end-submodule-stmt
 *     is END [ SUBMODULE [ submodule-name ] ]
 */

////////////
// R1119-F08
//
end_submodule_stmt
@init {Token lbl = null; Token t_submod = null; Token t_name = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_END (T_SUBMODULE (name {t_name=$name.tk;})? {t_submod=$T_SUBMODULE;})?
       end_of_stmt
           {action.end_submodule_stmt(lbl, $T_END, t_submod, t_name, $end_of_stmt.tk);}
   ;


/*
 * R1107-F08 module-subprogram-part
 *     is   contains-stmt
 *          [ module-subprogram ] ...
 */

////////////
// R1107-F08
//
module_subprogram_part
@init {int count = 0;}
   :   contains_stmt
       ( module_subprogram {count += 1;} )*
           { action.module_subprogram_part(count); }
   ;

/*
 * R1108-F08 module-subprogram
 *     is   function-subprogram
 *     or   subroutine-subprogram
 *     or   separate-module-subprogram   // NEW_TO_F2008
 */

////////////
// R1107-F08
//
// modified to factor optional prefix
//
module_subprogram
@init {boolean hasPrefix = false;}
@after{action.module_subprogram(hasPrefix);}
   :   (prefix {hasPrefix=true;})? function_subprogram
   |   subroutine_subprogram
   |   separate_module_subprogram
   ;

/*
 * R1237-F08 separate-module-subprogram
 *     is   mp-subprogram-stmt          // NEW_TO_F2008
 *             [ specification-part ]
 *             [ execution-part ]
 *             [ internal-subprogram-part ]
 *          end-mp-subprogram
 */

////////////
// R1237-F08
//
separate_module_subprogram
@init{
   boolean hasExecutionPart = false; boolean hasInternalSubprogramPart = false;
   action.separate_module_subprogram__begin();
}
@after{action.separate_module_subprogram(hasExecutionPart, hasInternalSubprogramPart);}
   :   mp_subprogram_stmt
          specification_part  // non-optional as can be empty
          ( execution_part {hasExecutionPart=true;} )?
          ( internal_subprogram_part {hasInternalSubprogramPart=true;} )?
       end_mp_subprogram_stmt
   ;


/*
 * R1238-F08 mp-subprogram-stmt
 *     is   MODULE PROCEDURE procedure-name
 */

////////////
// R1238-F08
//
mp_subprogram_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})? T_MODULE T_PROCEDURE name end_of_stmt
          {
             action.mp_subprogram_stmt(lbl, $T_MODULE,
                                       $T_PROCEDURE, $name.tk, $end_of_stmt.tk);
          }
   ;


/*
 * R1239-F08 end-mp-subprogram-stmt
 *     is END [ PROCEDURE [ procedure-name ] ]
 */

////////////
// R1239-F08
//
end_mp_subprogram_stmt
@init {Token lbl = null; Token t_proc = null; Token t_name = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_END (T_PROCEDURE (name {t_name=$name.tk;})? {t_proc=$T_PROCEDURE;})?
       end_of_stmt
           {action.end_mp_subprogram_stmt(lbl, $T_END, t_proc, t_name, $end_of_stmt.tk);}
   |   (label {lbl=$label.tk;})?
       T_ENDPROCEDURE (name {t_name=$name.tk;})?
       end_of_stmt
           {
              action.end_mp_subprogram_stmt(lbl, $T_ENDPROCEDURE, null,
                                            t_name, $end_of_stmt.tk);
           }
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
@init {Token idTeam=null;}
   :   T_LBRACKET expr (T_AT T_IDENT {idTeam=$T_IDENT;})? T_RBRACKET
           { action.rice_image_selector(idTeam);	}
   ;

// Laks 2009.01.15: add rice caf allocation
// the allocation is either using asterisk (with means all ranks) or team
rice_allocate_coarray_spec:
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



// R403 (rice version)
rice_intrinsic_type_spec
	:	
		       T_LOCKSET {action.intrinsic_type_spec($T_LOCKSET, null,
                                        IActionEnums.IntrinsicTypeSpec_LOCKSET,
                                        false);}
        |       T_TEAM {action.intrinsic_type_spec($T_TEAM, null,
                                        IActionEnums.IntrinsicTypeSpec_TEAM,
                                        false);}
        |       T_TOPOLOGY {action.intrinsic_type_spec($T_TOPOLOGY, null,
                                        IActionEnums.IntrinsicTypeSpec_TOPOLOGY,
                                        false);}
        |       T_EVENT {action.intrinsic_type_spec($T_EVENT, null,
                                        IActionEnums.IntrinsicTypeSpec_EVENT,
                                        false);}
	;


// R502 (rice version)
rice_declaration_type_spec
	:	// original F03 rule
		declaration_type_spec 	
	|   // rice CAF 2.0 rules
		rice_intrinsic_type_spec
			{ action.declaration_type_spec(null, 
                IActionEnums.DeclarationTypeSpec_INTRINSIC); }
	;


/*
 * R625-F08 cosubscript
 *    is scalar-int-expr
 */

////////////
// R625-F08
//
rice_cosubscript
   :   expr
   ;

rice_cosubscript_list
@init{
 int count=0;
 Token idTeam=null;
 }
   :       {action.cosubscript_list__begin();}
       	rice_cosubscript {count++;} ( T_COMMA rice_cosubscript {count++;} )*
   		 (T_AT T_IDENT {idTeam=$T_IDENT;})?
           {
           		action.cosubscript_list(count, idTeam);
           }
   ;
