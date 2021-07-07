/*
 * This is the base Fortran language grammar starting with many of the F2008
 * features.  However the goal is to move many of the new F2008 features to
 * FortranParser2008.g as the root grammar and import the base language.
 *
 * Breaking up the grammar into composites helps keep Java from blowing up.
 *
 * NOTES
 *
 * R303, R406, R417, R427, R428 underscore - added _ to rule (what happened 
 * to it?) * R410 sign - had '?' rather than '-'
 * R1209 import-stmt: MISSING a ]
 *
 * check comments regarding deleted for correctness
 *
 * Replace all occurrences of T_EOS with end_of_stmt rule call so there is 
 * a way to look ahead at the next token to see if it belongs to the same 
 * input stream as the current one.  This serves as a way to detect that an 
 * include statement had occurred during the lexical phase.
 *
 * TODO add (label)? to all statements...
 *    finished: continue-stmt, end-do-stmt
 *
 */


// added (label)? to any rule for a statement (*_stmt, for the most 
// part) because the draft says a label can exist with any statement.  
// questions are:
// - what about constructs such as if/else; where can labels all occur?
// - or the masked_elsewhere_stmt rule...


parser grammar FortranParserBase;

//options {
//   language=Java;
//   superClass=FortranParser;
//////////////
// NOTE: tokenVocab causes an antlr warning if used in conjuction
// with FortranParserExtras.  The warning should be ignored as an inconsistent
// tokens file will be generated otherwise.
//--------------------------------------
// MAY nOT BE NECESSARY WITH REFACTORING
// tokenVocab=FortranLexer;
//}

// If the package (in header) is defined (see below), antlr v3.2 will
// emit an error.  However, the error can be safely ignored and
// rerunning make will build the OFP jar file correctly.
//
//@header {
//package fortran.ofp.parser.java;
//}

@members {
   int gCount1;
   int gCount2;

   public void initialize(String[] args, String kind, String filename, String path) {
      action = FortranParserActionFactory.newAction(args, this, kind, filename);
      initialize(this, action, filename, path);
      action.start_of_file(filename, path);
   }

   public void eofAction() {
      action.end_of_file(filename, pathname);
   }
}


/**
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

// added rule so could have one rule for main() to call for attempting
// to match a function subprogram.  the original rule, 
// external_subprogram, has (prefix)? for a function_subprogram.
ext_function_subprogram
@init{boolean hasPrefix=false;}
    :   (prefix {hasPrefix=true;})? function_subprogram
			{action.ext_function_subprogram(hasPrefix);}
    ;

////////////
// R204
//
// This rule is overridden in FortranParserExtras grammar
//
// ERR_CHK 204 see ERR_CHK 207, implicit_part? removed (was after import_stmt*)
specification_part
@init{int numUseStmts=0; int numImportStmts=0; int numDeclConstructs=0;}
	:	( use_stmt {numUseStmts++;})*
		( import_stmt {numImportStmts++;})*
		( declaration_construct {numDeclConstructs++;})*
			{action.specification_part(numUseStmts, numImportStmts, 
                                       0, numDeclConstructs);}
	;

// R205 implicit_part removed from grammar (see ERR_CHK 207)

// R206 implicit_part_stmt removed from grammar (see ERR_CHK 207)

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

// R208
execution_part
@init{int count = 0;}
@after {
	action.execution_part(count);
}
	:	executable_construct
		( execution_part_construct {count += 1;} )*
	;

// R209
execution_part_construct
@after {
    action.execution_part_construct();
}
	:	executable_construct  
	|	format_stmt
	|	entry_stmt
	|	data_stmt
	;

/*
 * R210-F08 internal-subprogram-part
 *    is contains-stmt
 *          [ internal-subprogram ] ...  // DIFFERENT_2008 (can have contains only)
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

// R211
// modified to factor optional prefix
internal_subprogram
@after {
    action.internal_subprogram();
}
	:	( prefix )? function_subprogram
	|	subroutine_subprogram
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
   |   other_spec_stmt_extension
   ;

// language extension point
other_spec_stmt_extension : T_NO_LANGUAGE_EXTENSION ;

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
// R213-F03
//
// This rule is overridden in FortranParserExtras grammar
//
executable_construct
@after {action.executable_construct();}
   :   action_stmt
   |   associate_construct
   |   case_construct
   |   do_construct
   |   forall_construct
   |   if_construct
   |   select_type_construct
   |   where_construct
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
// R214
//
// This rule is overridden in FortranParserExtras grammar
//
// C201 (R208) An execution-part shall not contain an end-function-stmt, end-program-stmt, or
//             end-subroutine-stmt.  (But they can be in a branch target statement, which
//             is not in the grammar, so the end-xxx-stmts deleted.)
// TODO continue-stmt is ambiguous with same in end-do, check for label and if
// label matches do-stmt label, then match end-do there
// the original generated rules do not allow the label, so add (label)?
action_stmt
@after {
    action.action_stmt();
    checkForInclude();
}
// Removed backtracking by inserting extra tokens in the stream by the 
// prepass that signals whether we have an assignment-stmt, a 
// pointer-assignment-stmt, or an arithmetic if.  this approach may work for
// other parts of backtracking also.  however, need to see if there is a way
// to define tokens w/o defining them in the lexer so that the lexer doesn't
// have to add them to it's parsing..  02.05.07
	:	allocate_stmt
	|	assignment_stmt
	|	backspace_stmt
	|	call_stmt
	|	close_stmt
	|	continue_stmt
	|	cycle_stmt
	|	deallocate_stmt
	|	endfile_stmt
	|	exit_stmt
	|	flush_stmt
	|	forall_stmt
	|	goto_stmt
	|	if_stmt
    |   inquire_stmt  
	|	nullify_stmt
	|	open_stmt
	|	pointer_assignment_stmt
	|	print_stmt
	|	read_stmt
	|	return_stmt
	|	rewind_stmt
	|	stop_stmt
	|	wait_stmt
	|	where_stmt
	|	write_stmt
	|	arithmetic_if_stmt
	|	computed_goto_stmt
    |   assign_stmt 
    |   assigned_goto_stmt
    |   pause_stmt
	;

// R215
keyword returns [Token tk]
@after {
    action.keyword();
}
	:	name {tk = $name.tk;}
	;

/**
 * Section/Clause 3: Lexical tokens and source form
 */

// R301 character not used

// R302 alphanumeric_character converted to fragment

// R303 underscore inlined

// R304
name returns [Token tk]
	:	T_IDENT		{ tk = $T_IDENT; action.name(tk); }
	;

// R305
// ERR_CHK 305 named_constant replaced by T_IDENT 
constant
	:	literal_constant	{ action.constant(null); }
	|	T_IDENT				{ action.constant($T_IDENT); }
	;

scalar_constant
@after {
    action.scalar_constant();
}
    :    constant
    ;

// R306
literal_constant
@after {
    action.literal_constant();
}
   :   int_literal_constant
   |   real_literal_constant
   |   complex_literal_constant
   |   logical_literal_constant
   |   char_literal_constant
   |   boz_literal_constant
   |   hollerith_literal_constant  // deleted in F77
   ;

// R307 named_constant was name inlined as T_IDENT

// R308
// C302 R308 int_constant shall be of type integer
// inlined integer portion of constant
int_constant
	:	int_literal_constant	{ action.int_constant(null); }
	|	T_IDENT					{ action.int_constant($T_IDENT); }
	;

// R309
// C303 R309 char_constant shall be of type character
// inlined character portion of constant
char_constant
	:	char_literal_constant	{ action.int_constant(null); }
	|	T_IDENT					{ action.int_constant($T_IDENT); }
	;

// R310
intrinsic_operator returns [Token tk]
@after {
    action.intrinsic_operator();
}
	:	power_op	{ tk = $power_op.tk; }
	|	mult_op		{ tk = $mult_op.tk; }
	|	add_op		{ tk = $add_op.tk; }
	|	concat_op	{ tk = $concat_op.tk; }
	|	rel_op		{ tk = $rel_op.tk; }
	|	not_op		{ tk = $not_op.tk; }
	|	and_op		{ tk = $and_op.tk; }
	|	or_op		{ tk = $or_op.tk; }
	|	equiv_op	{ tk = $equiv_op.tk; }
	;

// R311
// removed defined_unary_op or defined_binary_op ambiguity with T_DEFINED_OP
defined_operator
	:	T_DEFINED_OP			
            { action.defined_operator($T_DEFINED_OP, false); }
	|	extended_intrinsic_op	
            { action.defined_operator($extended_intrinsic_op.tk, true); }
	;

// R312
extended_intrinsic_op returns [Token tk]
@after {
    action.extended_intrinsic_op();
}
	:	intrinsic_operator	{ tk = $intrinsic_operator.tk; }
	;

// R313
// ERR_CHK 313 five characters or less
label returns [Token tk]
    : T_DIGIT_STRING { tk = $T_DIGIT_STRING; action.label($T_DIGIT_STRING); }
    ;

// action.label called here to store label in action class
label_list
@init{ int count=0;}
    :  		{action.label_list__begin();}
		lbl=label {count++;} 
            ( T_COMMA lbl=label {count++;} )*
      		{action.label_list(count);}
    ;


/**
 * Section/Clause 4: Types
 */


// R401
type_spec
@after {
    action.type_spec();
}
	:	intrinsic_type_spec
	|	derived_type_spec
	;

// R402
// ERR_CHK 402 scalar_int_expr replaced by expr
type_param_value
	:	expr		{ action.type_param_value(true, false, false); }
	|	T_ASTERISK	{ action.type_param_value(false, true, false); }
	|	T_COLON 	{ action.type_param_value(false, false, true); }
	;

// inlined scalar_int_expr C101 shall be a scalar

// inlined scalar_expr

// R403
// Nonstandard Extension: source BLAS
//	|	T_DOUBLE T_COMPLEX
//	|	T_DOUBLECOMPLEX
intrinsic_type_spec
@init{boolean hasKindSelector = false;}
	:	T_INTEGER (kind_selector {hasKindSelector = true;})?
			{action.intrinsic_type_spec($T_INTEGER, null, 
                                        IActionEnums.IntrinsicTypeSpec_INTEGER,
                                        hasKindSelector);}
	|	T_REAL (kind_selector {hasKindSelector = true;})?
			{action.intrinsic_type_spec($T_REAL, null, 
                                        IActionEnums.IntrinsicTypeSpec_REAL, 
                                        hasKindSelector);}
	|	T_DOUBLE T_PRECISION
			{action.intrinsic_type_spec($T_DOUBLE, $T_PRECISION, 
                                        IActionEnums.
                                        IntrinsicTypeSpec_DOUBLEPRECISION, 
                                        false);}
	|	T_DOUBLEPRECISION
			{action.intrinsic_type_spec($T_DOUBLEPRECISION, null, 
                                        IActionEnums.
                                        IntrinsicTypeSpec_DOUBLEPRECISION, 
                                        false);}
	|	T_COMPLEX (kind_selector {hasKindSelector = true;})?
			{action.intrinsic_type_spec($T_COMPLEX, null, 
                                        IActionEnums.IntrinsicTypeSpec_COMPLEX,
                                        hasKindSelector);}
	|	T_DOUBLE T_COMPLEX
			{action.intrinsic_type_spec($T_DOUBLE, $T_COMPLEX, 
                                        IActionEnums.
                                        IntrinsicTypeSpec_DOUBLECOMPLEX, 
                                        false);}
	|	T_DOUBLECOMPLEX
			{action.intrinsic_type_spec($T_DOUBLECOMPLEX, null, 
                                        IActionEnums.
                                        IntrinsicTypeSpec_DOUBLECOMPLEX, 
                                        false);}
	|	T_CHARACTER (char_selector {hasKindSelector = true;})?
			{action.intrinsic_type_spec($T_CHARACTER, null, 
                                        IActionEnums.
                                        IntrinsicTypeSpec_CHARACTER, 
                                        hasKindSelector);}
	|	T_LOGICAL (kind_selector {hasKindSelector = true;})?
			{action.intrinsic_type_spec($T_LOGICAL, null, 
                                        IActionEnums.IntrinsicTypeSpec_LOGICAL,
                                        hasKindSelector);}
	;

// R404
// ERR_CHK 404 scalar_int_initialization_expr replaced by expr
// Nonstandard extension: source common practice
//	| T_ASTERISK T_DIGIT_STRING  // e.g., COMPLEX*16	
// TODO - check to see if second alternative is where it should go
kind_selector
@init{Token tk1=null; Token tk2=null;}
    : T_LPAREN (T_KIND T_EQUALS {tk1=$T_KIND; tk2=$T_EQUALS;})? expr T_RPAREN
    	{ action.kind_selector(tk1, tk2, true); } 
    | T_ASTERISK T_DIGIT_STRING
    	{ action.kind_selector($T_ASTERISK, $T_DIGIT_STRING, false); }	
    ;

// R405
signed_int_literal_constant
@init{Token sign = null;} 
	:	(T_PLUS {sign=$T_PLUS;} | T_MINUS {sign=$T_MINUS;})?
		int_literal_constant
			{ action.signed_int_literal_constant(sign); }
	;

// R406
int_literal_constant
@init{Token kind = null;} 
	:	T_DIGIT_STRING (T_UNDERSCORE kind_param {kind = $kind_param.tk;})?
			{action.int_literal_constant($T_DIGIT_STRING, kind);}
	;

// R407
// T_IDENT inlined for scalar_int_constant_name
kind_param returns [Token tk]
	:	T_DIGIT_STRING 
            { tk = $T_DIGIT_STRING; action.kind_param($T_DIGIT_STRING); }
	|	T_IDENT 
            { tk = $T_IDENT; action.kind_param($T_IDENT); }
	;

// R408 signed_digit_string inlined

// R409 digit_string converted to fragment

// R410 sign inlined

// R411
boz_literal_constant
	:	BINARY_CONSTANT { action.boz_literal_constant($BINARY_CONSTANT); }
	|	OCTAL_CONSTANT { action.boz_literal_constant($OCTAL_CONSTANT); }
	|	HEX_CONSTANT { action.boz_literal_constant($HEX_CONSTANT); }
	;

// R412 binary-constant converted to terminal

// R413 octal_constant converted to terminal

// R414 hex_constant converted to terminal

// R415 hex_digit inlined

// R416
signed_real_literal_constant
@init{Token sign = null;} 
	:	(T_PLUS {sign=$T_PLUS;} | T_MINUS {sign=$T_MINUS;})?
		real_literal_constant
			{action.signed_real_literal_constant(sign);}
	;

// R417 modified to use terminal
// Grammar Modified slightly to prevent problems with input such as: 
// if(1.and.1) then ... 
real_literal_constant
@init{Token kind = null;} 
//		WARNING must parse T_REAL_CONSTANT in action (look for D)
    :   T_REAL_CONSTANT (T_UNDERSCORE kind_param {kind = $kind_param.tk;})? 
            { action.real_literal_constant($T_REAL_CONSTANT, kind); }
        
    ;

// R418 significand converted to fragment

// R419 exponent_letter inlined in new Exponent

// R420 exponent inlined in new Exponent

// R421
complex_literal_constant
@after {
    action.complex_literal_constant();
}
	:	T_LPAREN real_part T_COMMA imag_part T_RPAREN
	;

// R422
// ERR_CHK 422 named_constant replaced by T_IDENT
real_part
	:	signed_int_literal_constant	 
            { action.real_part(true, false, null); }
	|	signed_real_literal_constant 
            { action.real_part(false, true, null); }
	|	T_IDENT					     
            { action.real_part(false, false, $T_IDENT); }
	;

// R423
// ERR_CHK 423 named_constant replaced by T_IDENT
imag_part
	:	signed_int_literal_constant		
            { action.imag_part(true, false, null); }
	|	signed_real_literal_constant	
            { action.imag_part(false, true, null); }
	|	T_IDENT							
            { action.imag_part(false, false, $T_IDENT); }
	;

// R424
// ERR_CHK 424a scalar_int_initialization_expr replaced by expr
// ERR_CHK 424b T_KIND, if type_param_value, must be a 
// scalar_int_initialization_expr
// ERR_CHK 424c T_KIND and T_LEN cannot both be specified
char_selector
@init {
    int kindOrLen1; kindOrLen1 = IActionEnums.KindLenParam_none;
    int kindOrLen2; kindOrLen2 = IActionEnums.KindLenParam_none;
    Token tk = null;
    boolean hasAsterisk = false;
}
   // length-selector without type-param-value
   :   T_ASTERISK char_length (T_COMMA)?
          {
            hasAsterisk=true; 
            action.char_selector(null, null, kindOrLen1, kindOrLen2, hasAsterisk);
          }
   // type-param-value but no LEN=
   |   T_LPAREN type_param_value
          (  T_COMMA (T_KIND T_EQUALS {tk=$T_KIND;})? expr
             {kindOrLen2=IActionEnums.KindLenParam_kind;}
          )?
       T_RPAREN
          {
            kindOrLen1 = IActionEnums.KindLenParam_len;
            action.char_selector(null, tk, kindOrLen1, kindOrLen2, hasAsterisk);
          }
   // type-param-value with LEN=
   |   T_LPAREN T_LEN T_EQUALS type_param_value
          (  T_COMMA T_KIND T_EQUALS expr
             {kindOrLen2=IActionEnums.KindLenParam_kind; tk=$T_KIND;}
          )?
       T_RPAREN
          {
            kindOrLen1 = IActionEnums.KindLenParam_len;
            action.char_selector($T_LEN, tk, kindOrLen1, kindOrLen2, hasAsterisk);
          }
   // KIND= first
   |   T_LPAREN T_KIND T_EQUALS expr
          (  T_COMMA (T_LEN T_EQUALS {tk=$T_LEN;})? type_param_value
             {kindOrLen2=IActionEnums.KindLenParam_len;}
          )?
       T_RPAREN
          {
            kindOrLen1 = IActionEnums.KindLenParam_kind;
            action.char_selector($T_KIND, tk, kindOrLen1, kindOrLen2, hasAsterisk);
          }
   ;

// R425
length_selector
@init {Token len = null;}
   :   T_LPAREN ( T_LEN { len=$T_LEN; } T_EQUALS )? type_param_value T_RPAREN
          { action.length_selector(len, IActionEnums.KindLenParam_len, false); }
   |   T_ASTERISK char_length (T_COMMA)?
          { action.length_selector(len, IActionEnums.KindLenParam_none, true); }
   ; 

// R426
char_length
   :   T_LPAREN type_param_value T_RPAREN   { action.char_length(true); }
   |   scalar_int_literal_constant          { action.char_length(false); }
   ;

scalar_int_literal_constant
@after {action.scalar_int_literal_constant();}
   :   int_literal_constant
   ;

// R427
// char_literal_constant
// // options {k=2;}
// 	:	T_DIGIT_STRING T_UNDERSCORE T_CHAR_CONSTANT
//         // removed the T_UNDERSCORE because underscores are valid characters 
//         // for identifiers, which means the lexer would match the T_IDENT and 
//         // T_UNDERSCORE as one token (T_IDENT).
// 	|	T_IDENT T_CHAR_CONSTANT
// 	|	T_CHAR_CONSTANT
//     ;
char_literal_constant
   :   T_DIGIT_STRING T_UNDERSCORE T_CHAR_CONSTANT
          { action.char_literal_constant($T_DIGIT_STRING, null, $T_CHAR_CONSTANT); }
       // removed the T_UNDERSCORE because underscores are valid characters 
       // for identifiers, which means the lexer would match the T_IDENT and 
       // T_UNDERSCORE as one token (T_IDENT).
   |   T_IDENT T_CHAR_CONSTANT
          { action.char_literal_constant(null, $T_IDENT, $T_CHAR_CONSTANT); }
   |   T_CHAR_CONSTANT
          { action.char_literal_constant(null, null, $T_CHAR_CONSTANT); }
   ;

//
// Note: Hollerith constants were deleted in F77; Hollerith edit descriptors
// deleted in F95.
//
hollerith_literal_constant
    :   T_HOLLERITH
            { action.hollerith_literal_constant($T_HOLLERITH); }
    ;

// R428
logical_literal_constant
@init{Token kind = null;} 
	:	T_TRUE ( T_UNDERSCORE kind_param {kind = $kind_param.tk;})?
			{action.logical_literal_constant($T_TRUE, true, kind);}
	|	T_FALSE ( T_UNDERSCORE kind_param {kind = $kind_param.tk;})?
			{action.logical_literal_constant($T_FALSE, false, kind);}
	;

// R429
//	( component_part )? inlined as ( component_def_stmt )*
derived_type_def
@after {
    action.derived_type_def();
}
	:	derived_type_stmt
        // matches T_INTEGER possibilities in component_def_stmt
		type_param_or_comp_def_stmt_list  
		( private_or_sequence )*
	  { /* ERR_CHK 429
	     * if private_or_sequence present, component_def_stmt in 
         * type_param_or_comp_def_stmt_list
	     * is an error
	     */
	  }
		( component_def_stmt )*
		( type_bound_procedure_part )?
		end_type_stmt
	;

// Includes:
//    ( type_param_def_stmt)*
//    ( component_def_stmt )* if starts with T_INTEGER (could be a parse error)
// REMOVED T_INTEGER junk (see statement above) with k=1
// TODO this must be tested can we get rid of this????
type_param_or_comp_def_stmt_list
@after {
    action.type_param_or_comp_def_stmt_list();
}
///options {k=1;}
//	:	(T_INTEGER) => (kind_selector)? T_COMMA type_param_or_comp_def_stmt
//			type_param_or_comp_def_stmt_list
	:	(kind_selector)? T_COMMA type_param_or_comp_def_stmt
			type_param_or_comp_def_stmt_list
	|
		{ /* ERR_CHK R435
		   * type_param_def_stmt(s) must precede component_def_stmt(s)
		   */
		}
	;

type_param_or_comp_def_stmt
	:	type_param_attr_spec T_COLON_COLON type_param_decl_list end_of_stmt 
            // TODO: See if this is reachable now that type_param_attr_spec is 
            // tokenized T_KIND or T_LEN. See R435
			{action.type_param_or_comp_def_stmt($end_of_stmt.tk,
				IActionEnums.TypeParamOrCompDef_typeParam);}
	|	component_attr_spec_list T_COLON_COLON component_decl_list end_of_stmt 
            // See R440
			{action.type_param_or_comp_def_stmt($end_of_stmt.tk,
				IActionEnums.TypeParamOrCompDef_compDef);}
	;

// R430
// generic_name_list substituted for type_param_name_list
derived_type_stmt
@init {
    Token lbl=null; 
    boolean hasTypeAttrSpecList=false; 
    boolean hasGenericNameList=false;
}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_TYPE
		( ( T_COMMA type_attr_spec_list {hasTypeAttrSpecList=true;} )? 
            T_COLON_COLON )? T_IDENT
		    ( T_LPAREN generic_name_list T_RPAREN {hasGenericNameList=true;} )?
            end_of_stmt
			{action.derived_type_stmt(lbl, $T_TYPE, $T_IDENT, $end_of_stmt.tk,
                hasTypeAttrSpecList, hasGenericNameList);}
	;

type_attr_spec_list
@init{int count = 0;}
	:		{action.type_attr_spec_list__begin();}
		type_attr_spec {count++;} ( T_COMMA type_attr_spec {count++;} )*
			{action.type_attr_spec_list(count);}
	;

generic_name_list
@init{int count = 0;}
	:		{action.generic_name_list__begin();}
		ident=T_IDENT
			{
				count++;
				action.generic_name_list_part(ident);
			} ( T_COMMA ident=T_IDENT 
			{
				count++;
				action.generic_name_list_part(ident);
			} )*
			{action.generic_name_list(count);}
	;

// R431
// T_IDENT inlined for parent_type_name
type_attr_spec
	:	access_spec
			{action.type_attr_spec(null, null, 
                                   IActionEnums.TypeAttrSpec_access_spec);}
	|	T_EXTENDS T_LPAREN T_IDENT T_RPAREN
			{action.type_attr_spec($T_EXTENDS, $T_IDENT, 
                                   IActionEnums.TypeAttrSpec_extends);}
	|	T_ABSTRACT
			{action.type_attr_spec($T_ABSTRACT, null, 
                                   IActionEnums.TypeAttrSpec_abstract);}
	|	T_BIND T_LPAREN T_IDENT /* 'C' */ T_RPAREN
			{action.type_attr_spec($T_BIND, $T_IDENT, 
                                   IActionEnums.TypeAttrSpec_bind);}
	;

// R432
private_or_sequence
@after {
    action.private_or_sequence();
}
    :   private_components_stmt
    |   sequence_stmt
    ;

// R433
end_type_stmt
@init {Token lbl = null;Token id=null;} 
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_TYPE ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_type_stmt(lbl, $T_END, $T_TYPE, id, $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDTYPE ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_type_stmt(lbl, $T_ENDTYPE, null, id, $end_of_stmt.tk);}
	;

// R434
sequence_stmt
@init {Token lbl = null;} 
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_SEQUENCE end_of_stmt
			{action.sequence_stmt(lbl, $T_SEQUENCE, $end_of_stmt.tk);}
	;

// R435 type_param_def_stmt inlined in type_param_or_comp_def_stmt_list

// R436
// ERR_CHK 436 scalar_int_initialization_expr replaced by expr
// T_IDENT inlined for type_param_name
type_param_decl
@init{ boolean hasInit=false; }
    :    T_IDENT ( T_EQUALS expr {hasInit=true;})?
			{action.type_param_decl($T_IDENT, hasInit);}
    ;

type_param_decl_list
@init{int count=0;}
	:		{action.type_param_decl_list__begin();}
        type_param_decl {count++;} ( T_COMMA type_param_decl {count++;} )*
			{action.type_param_decl_list(count);}
    ;

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
   |   component_attr_spec_extension
    // are T_KIND and T_LEN correct?
//   |   T_KIND
//          {action.component_attr_spec($T_KIND, 
//                  IActionEnums.ComponentAttrSpec_kind);}
//   |   T_LEN
//          {action.component_attr_spec($T_LEN, 
//                  IActionEnums.ComponentAttrSpec_len);}
  ;
  
// language extension point
component_attr_spec_extension : T_NO_LANGUAGE_EXTENSION ;

component_attr_spec_list
@init{int count=1;}
    :		{action.component_attr_spec_list__begin();}
        component_attr_spec ( T_COMMA component_attr_spec {count++;} )*
    		{action.component_attr_spec_list(count);}
    ;

// R437
// ADD isKind boolean.
type_param_attr_spec
	: 	T_IDENT /* { KIND | LEN } */ 
            { action.type_param_attr_spec($T_IDENT); }
	;

// R438 component_part inlined as ( component_def_stmt )* in R429

// R439
component_def_stmt
@after{checkForInclude();}
	:	data_component_def_stmt
			{action.component_def_stmt(IActionEnums.ComponentDefType_data);}
	|	proc_component_def_stmt
			{action.component_def_stmt(IActionEnums.
                                       ComponentDefType_procedure);}
	;


// R440
data_component_def_stmt
@init {Token lbl = null; boolean hasSpec=false; }
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? declaration_type_spec 
            ( ( T_COMMA component_attr_spec_list {hasSpec=true;})? 
            T_COLON_COLON )? component_decl_list end_of_stmt
			{action.data_component_def_stmt(lbl, $end_of_stmt.tk, hasSpec);}
    ;


/*
 * R438-F08 component-decl
 *    is component-name [ ( component-array-spec ) ]
 *                      [ lbracket coarray-spec rbracket ]  // NEW_TO_2008
 *                      [ * char-length ] [ component-initialization ]
 */

////////////
// R438-F08, R442-F03
//
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

component_decl_list
@init{int count=0;}
   :       {action.component_decl_list__begin();}
       component_decl {count++;} ( T_COMMA component_decl {count++;} )*
           {action.component_decl_list(count);}
   ;

// R443
component_array_spec
	:	explicit_shape_spec_list
			{action.component_array_spec(true);}
	|	deferred_shape_spec_list
			{action.component_array_spec(false);}
	;

// deferred_shape_spec replaced by T_COLON
deferred_shape_spec_list
@init{int count=0;}
    :    	{action.deferred_shape_spec_list__begin();}
        T_COLON {count++;} ( T_COMMA T_COLON {count++;} )*
        	{action.deferred_shape_spec_list(count);}
    ;

// R444
// R447-F2008 can also be => initial_data_target, see NOTE 4.40 in J3/07-007
// ERR_CHK 444 initialization_expr replaced by expr
component_initialization
@after {
    action.component_initialization();
}
	:	T_EQUALS expr
	|	T_EQ_GT null_init
	;

// R445
proc_component_def_stmt
@init {Token lbl = null; boolean hasInterface=false;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_PROCEDURE T_LPAREN 
            ( proc_interface {hasInterface=true;})? T_RPAREN T_COMMA
		    proc_component_attr_spec_list T_COLON_COLON proc_decl_list 
            end_of_stmt
				{action.proc_component_def_stmt(lbl, $T_PROCEDURE, 
                    $end_of_stmt.tk, hasInterface);}
	;

// R446
// T_IDENT inlined for arg_name
proc_component_attr_spec
@init{ Token id=null; }
    :    T_POINTER
			{action.proc_component_attr_spec($T_POINTER, id, 
                                             IActionEnums.
                                             ProcComponentAttrSpec_pointer);}
    |    T_PASS ( T_LPAREN T_IDENT T_RPAREN {id=$T_IDENT;} )?
			{action.proc_component_attr_spec($T_PASS, id, 
                                             IActionEnums.
                                             ProcComponentAttrSpec_pass);}
    |    T_NOPASS
			{action.proc_component_attr_spec($T_NOPASS, id, 
                                             IActionEnums.
                                             ProcComponentAttrSpec_nopass);}
    |    access_spec
			{action.
                proc_component_attr_spec(null, id, 
                                         IActionEnums.
                                         ProcComponentAttrSpec_access_spec);}
    ;

proc_component_attr_spec_list
@init{int count=0;}
    :    	{action.proc_component_attr_spec_list__begin();}
        proc_component_attr_spec {count++;} 
            ( T_COMMA proc_component_attr_spec {count++;})*
        	{action.proc_component_attr_spec_list(count);}
    ;

// R447
private_components_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_PRIVATE end_of_stmt
			{action.private_components_stmt(lbl, $T_PRIVATE, $end_of_stmt.tk);}
	;

// R448
type_bound_procedure_part
@init{int count=1; boolean hasBindingPrivateStmt=false;}
   :   contains_stmt
       ( binding_private_stmt  {hasBindingPrivateStmt=true;} )?
       proc_binding_stmt ( proc_binding_stmt {count++;} )*
           {action.type_bound_procedure_part(count,hasBindingPrivateStmt);}
   ;

// R449
binding_private_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_PRIVATE end_of_stmt
			{action.binding_private_stmt(lbl, $T_PRIVATE, $end_of_stmt.tk);}
	;

// R450
proc_binding_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? specific_binding end_of_stmt
			{action.proc_binding_stmt(lbl,
                IActionEnums.BindingStatementType_specific, $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? generic_binding end_of_stmt
			{action.proc_binding_stmt(lbl,
                IActionEnums.BindingStatementType_generic, $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? final_binding end_of_stmt
			{action.proc_binding_stmt(lbl,
                IActionEnums.BindingStatementType_final, $end_of_stmt.tk);}
	;

// R451
// T_IDENT inlined for interface_name, binding_name and procedure_name
specific_binding
@init {
    Token interfaceName=null;
	Token bindingName=null; 
	Token procedureName=null;
	boolean hasBindingAttrList=false;
} 
    :   T_PROCEDURE (T_LPAREN tmpId1=T_IDENT T_RPAREN {interfaceName=tmpId1;})?
            ( ( T_COMMA binding_attr_list {hasBindingAttrList=true;})? 
                T_COLON_COLON )?
            tmpId2=T_IDENT {bindingName=tmpId2;} 
            ( T_EQ_GT tmpId3=T_IDENT {procedureName=tmpId3;})?
			{ action.specific_binding($T_PROCEDURE, interfaceName, bindingName,
                                      procedureName, hasBindingAttrList);}
    ;

// R452
// generic_name_list substituted for binding_name_list
generic_binding
@init{boolean hasAccessSpec=false;}
    :    T_GENERIC ( T_COMMA access_spec {hasAccessSpec=true;})? T_COLON_COLON 
            generic_spec T_EQ_GT generic_name_list
			{action.generic_binding($T_GENERIC, hasAccessSpec);}
    ;

// R453
// T_IDENT inlined for arg_name
binding_attr
@init{Token id = null;}
    : T_PASS ( T_LPAREN T_IDENT T_RPAREN {id=$T_IDENT;})?
        { action.binding_attr($T_PASS, IActionEnums.AttrSpec_PASS, id); }
    | T_NOPASS			
        { action.binding_attr($T_NOPASS, IActionEnums.AttrSpec_NOPASS, id); }
    | T_NON_OVERRIDABLE	
        { action.binding_attr($T_NON_OVERRIDABLE, 
                              IActionEnums.AttrSpec_NON_OVERRIDABLE, id); }
    | T_DEFERRED		
        { action.binding_attr($T_DEFERRED, IActionEnums.AttrSpec_DEFERRED, 
                              id); }
    | access_spec		
        { action.binding_attr(null, IActionEnums.AttrSpec_none, id); }
    ;

binding_attr_list
@init{int count=0;}
    :		{action.binding_attr_list__begin();}
        binding_attr {count++;} ( T_COMMA binding_attr {count++;} )*
    		{action.binding_attr_list(count);}
    ;

// R454
// generic_name_list substituted for final_subroutine_name_list
final_binding
	:	T_FINAL ( T_COLON_COLON )? generic_name_list 
            { action.final_binding($T_FINAL); }
	;

// R455
derived_type_spec
@init{boolean hasList = false;}
    : T_IDENT ( T_LPAREN type_param_spec_list {hasList=true;} T_RPAREN )?
    	{ action.derived_type_spec($T_IDENT, hasList); }
    ;

// R456
type_param_spec
@init{ Token keyWord=null; }
    : ( keyword T_EQUALS {keyWord=$keyword.tk;})? type_param_value
			{action.type_param_spec(keyWord);}
    ;

type_param_spec_list
@init{int count=0;}
    :    	{action.type_param_spec_list__begin();} 
        type_param_spec {count++;}( T_COMMA type_param_spec {count++;})*
        	{action.type_param_spec_list(count);} 
    ;

// R457
// inlined derived_type_spec (R662) to remove ambiguity using backtracking
// ERR_CHK R457 
// If any of the type-param-specs in the list are an '*' or ':', the 
// component-spec-list is required.
// the second alternative to the original rule for structure_constructor is 
// a subset of the first alternative because component_spec_list is a 
// subset of type_param_spec_list.  by combining these two alternatives we can
// remove the backtracking on this rule.
structure_constructor
// options {backtrack=true;}
//     : T_IDENT T_LPAREN type_param_spec_list T_RPAREN
// 		T_LPAREN
// 		( component_spec_list )?
// 		T_RPAREN
//     | T_IDENT
// 		T_LPAREN
// 		( component_spec_list )?
// 		T_RPAREN
    : T_IDENT T_LPAREN type_param_spec_list T_RPAREN
		(T_LPAREN
		( component_spec_list )?
		T_RPAREN)?
        { action.structure_constructor($T_IDENT); }
	;

// R458
component_spec
@init { Token keyWord = null; }
    :   ( keyword T_EQUALS { keyWord=$keyword.tk; })? component_data_source
            { action.component_spec(keyWord); }
    ;

component_spec_list
@init{int count=0;}
    :    	{action.component_spec_list__begin();} 
        component_spec {count++;}( T_COMMA component_spec {count++;})*
        	{action.component_spec_list(count);} 
    ;

// R459
// is (expr | data-target | proc-target)
// data_target isa expr so data_target deleted
// proc_target isa expr so proc_target deleted
component_data_source
	:	expr 
            { action.component_data_source(); }
	;

// R460
enum_def
@init{ int numEls=1; }
	:	enum_def_stmt
		enumerator_def_stmt
		( enumerator_def_stmt {numEls++;})*
		end_enum_stmt
			{action.enum_def(numEls);}
	;

// R461
enum_def_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ENUM T_COMMA T_BIND T_LPAREN 
            T_IDENT /* 'C' */ T_RPAREN end_of_stmt
			{action.enum_def_stmt(lbl, $T_ENUM, $T_BIND, $T_IDENT, 
                $end_of_stmt.tk);}
	;

// R462
enumerator_def_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ENUMERATOR ( T_COLON_COLON )? 
            enumerator_list end_of_stmt
			{action.enumerator_def_stmt(lbl, $T_ENUMERATOR, $end_of_stmt.tk);}
	;

// R463
// ERR_CHK 463 scalar_int_initialization_expr replaced by expr
// ERR_CHK 463 named_constant replaced by T_IDENT
enumerator
@init{boolean hasExpr = false;}
    :   T_IDENT ( T_EQUALS expr { hasExpr = true; })?
            { action.enumerator($T_IDENT, hasExpr); }
    ;

enumerator_list
@init{int count=0;}
    :    	{action.enumerator_list__begin();} 
        enumerator {count++;}( T_COMMA enumerator {count++;})*
        	{action.enumerator_list(count);} 
    ;

// R464
end_enum_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_END T_ENUM end_of_stmt 
            { action.end_enum_stmt(lbl, $T_END, $T_ENUM, $end_of_stmt.tk); }
	|	(label {lbl=$label.tk;})? T_ENDENUM end_of_stmt 
            { action.end_enum_stmt(lbl, $T_ENDENUM, null, $end_of_stmt.tk); }
	;

// R465
array_constructor
	:	T_LPAREN T_SLASH ac_spec T_SLASH T_RPAREN
			{ action.array_constructor(); }
	|	T_LBRACKET ac_spec T_RBRACKET
			{ action.array_constructor(); }
	;

// R466
// refactored to remove optional from lhs
ac_spec
options {backtrack=true;}
@after {
    action.ac_spec();
}
    : type_spec T_COLON_COLON (ac_value_list)?
    | ac_value_list
    ;

// R467 left_square_bracket inlined as T_LBRACKET

// R468 right_square_bracket inlined as T_RBRACKET

// R469
ac_value
options {backtrack=true;}
@after {
    action.ac_value();
}
	:	expr
	|	ac_implied_do
	;

ac_value_list
@init{int count=0;}
    :    	{action.ac_value_list__begin();} 
        ac_value {count++;}( T_COMMA ac_value {count++;})*
        	{action.ac_value_list(count);} 
    ;

// R470
ac_implied_do
	:	T_LPAREN ac_value_list T_COMMA ac_implied_do_control T_RPAREN
			{action.ac_implied_do();}
	;

// R471
// ERR_CHK 471a scalar_int_expr replaced by expr
// ERR_CHK 471b ac_do_variable replaced by do_variable
ac_implied_do_control
@init{boolean hasStride=false;}
    :    do_variable T_EQUALS expr T_COMMA expr ( T_COMMA expr {hasStride=true;})?
			{action.ac_implied_do_control(hasStride);}
    ;

// R472 inlined ac_do_variable as scalar_int_variable (and finally T_IDENT) 
// in R471
// C493 (R472) ac-do-variable shall be a named variable
scalar_int_variable
    :   variable
            { action.scalar_int_variable(); }
    ;


/**
 * Section/Clause 5: Attribute declarations and specifications
 */


////////////
// R501
//
// This rule is overridden in FortranParserExtras grammar
//
type_declaration_stmt
@init {Token lbl = null; int numAttrSpecs = 0;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})? declaration_type_spec
       ( (T_COMMA attr_spec {numAttrSpecs += 1;})* T_COLON_COLON )?
       entity_decl_list end_of_stmt
           { action.type_declaration_stmt(lbl, numAttrSpecs, $end_of_stmt.tk); }
   ;

// R502
declaration_type_spec
	:	intrinsic_type_spec
			{ action.declaration_type_spec(null, 
                IActionEnums.DeclarationTypeSpec_INTRINSIC); }
	|	T_TYPE T_LPAREN	derived_type_spec T_RPAREN
			{ action.declaration_type_spec($T_TYPE, 
                IActionEnums.DeclarationTypeSpec_TYPE); }
	|	T_CLASS	T_LPAREN derived_type_spec T_RPAREN
			{ action.declaration_type_spec($T_CLASS, 
                IActionEnums.DeclarationTypeSpec_CLASS); }
	|	T_CLASS T_LPAREN T_ASTERISK T_RPAREN
			{ action.declaration_type_spec($T_CLASS,
                IActionEnums.DeclarationTypeSpec_unlimited); }
	;


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
    |   attr_spec_extension
	;
	
// language extension point
attr_spec_extension : T_NO_LANGUAGE_EXTENSION ;


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

entity_decl_list
@init{int count = 0;}
    :		{action.entity_decl_list__begin();}
    	entity_decl {count += 1;} ( T_COMMA entity_decl {count += 1;} )*
    		{action.entity_decl_list(count);}
    ;

/*
 * R505-F03 object-name
 *    is name
 */

////////////
// R505-F03, R504-F08
//
object_name returns [Token tk]
   :   T_IDENT   {tk = $T_IDENT;}
   ;

// R506
// ERR_CHK 506 initialization_expr replaced by expr
initialization
	:	T_EQUALS expr		{ action.initialization(true, false); }
	|	T_EQ_GT null_init	{ action.initialization(false, true); }
	;

// R507
// C506 The function-reference shall be a reference to the NULL intrinsic 
// function with no arguments.
null_init
	:	T_IDENT /* 'NULL' */ T_LPAREN T_RPAREN
			{ action.null_init($T_IDENT); }
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
// that the coarray_spec can be figured out by the actions.  Note, that this
// means the parser can't determine all incorrect syntax as many rules are
// combined into one.  It is the action's responsiblity to enforce correct syntax.
//
coarray_spec
@init{int count=0;}
   :   array_spec_element {count++;} (T_COMMA array_spec_element {count++;})*
           {action.coarray_spec(count);}
   ;

// R508
access_spec
	:	T_PUBLIC
			{action.access_spec($T_PUBLIC,  IActionEnums.AttrSpec_PUBLIC);}
	|	T_PRIVATE
			{action.access_spec($T_PRIVATE, IActionEnums.AttrSpec_PRIVATE);}
	;

// R509
// ERR_CHK 509 scalar_char_initialization_expr replaced by expr
language_binding_spec
@init{boolean hasName = false;}
    :	T_BIND T_LPAREN T_IDENT /* 'C' */ 
            (T_COMMA name T_EQUALS expr {hasName=true;})? T_RPAREN
    		{ action.language_binding_spec($T_BIND, $T_IDENT, hasName); }
    ;

// R510
array_spec
@init{int count=0;}
	:	array_spec_element {count++;}
		(T_COMMA array_spec_element {count++;})*
			{action.array_spec(count);}
	;

// Array specifications can consist of these beasts. Note that we can't 
// mix/match arbitrarily, so we have to check validity in actions.
// Types: 	0 expr (e.g. 3 or m+1)
// 			1 expr: (e.g. 3:)
// 			2 expr:expr (e.g. 3:5 or 7:(m+1))
// 			3 expr:* (e.g. 3:* end of assumed size)
// 			4 *  (end of assumed size)
// 			5 :	 (could be part of assumed or deferred shape)
array_spec_element
@init{int type=IActionEnums.ArraySpecElement_expr;}
	:   expr ( T_COLON {type=IActionEnums.ArraySpecElement_expr_colon;}
        	(  expr {type=IActionEnums.ArraySpecElement_expr_colon_expr;}
        	 | T_ASTERISK 
                {type=IActionEnums.ArraySpecElement_expr_colon_asterisk;} )?
          )?
			{ action.array_spec_element(type); }
	|   T_ASTERISK
			{ action.array_spec_element(IActionEnums.
                ArraySpecElement_asterisk); }
	|	T_COLON
			{ action.array_spec_element(IActionEnums.ArraySpecElement_colon); }
	;

// R511
// refactored to remove conditional from lhs and inlined lower_bound and 
// upper_bound
explicit_shape_spec
@init{boolean hasUpperBound=false;}
    : 	expr (T_COLON expr {hasUpperBound=true;})?
			{action.explicit_shape_spec(hasUpperBound);}
	;

explicit_shape_spec_list
@init{ int count=0;}
	:		{action.explicit_shape_spec_list__begin();}
     	explicit_shape_spec {count++;} 
            ( T_COMMA explicit_shape_spec {count++;})*
			{action.explicit_shape_spec_list(count);}
    ;

// R512 lower_bound was specification_expr inlined as expr

// R513 upper_bound was specification_expr inlined as expr

// R514 assumed_shape_spec was ( lower_bound )? T_COLON not used in R510 
// array_spec

// R515 deferred_shape_spec inlined as T_COLON in deferred_shape_spec_list

// R516 assumed_size_spec absorbed into array_spec.

// R517
intent_spec
	:	T_IN		{ action.intent_spec($T_IN, null, 
                IActionEnums.IntentSpec_IN); }
	|	T_OUT		{ action.intent_spec($T_OUT, null, 
                IActionEnums.IntentSpec_OUT); }
	|	T_IN T_OUT	{ action.intent_spec($T_IN, $T_OUT, 
                IActionEnums.IntentSpec_INOUT); }
	|	T_INOUT		{ action.intent_spec($T_INOUT, null, 
                IActionEnums.IntentSpec_INOUT); }
	;

// R518
access_stmt
@init {Token lbl = null;boolean hasList=false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? access_spec ( ( T_COLON_COLON )? 
            access_id_list {hasList=true;})? end_of_stmt
			{ action.access_stmt(lbl,$end_of_stmt.tk,hasList); }
    ;

// R519
// T_IDENT inlined for use_name
// generic_spec can be T_IDENT so T_IDENT deleted
// TODO - can this only be T_IDENTS?  generic_spec is more than that..
access_id
	:	generic_spec
            { action.access_id(); }
	;

access_id_list
@init{ int count=0;}
    :  		{action.access_id_list__begin();}
		access_id {count++;} ( T_COMMA access_id {count++;} )*
      		{action.access_id_list(count);}
    ;

////////////
// R520-F03, R526-F08
//     - form of F08 used with allocatable_decl_list
//
allocatable_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_ALLOCATABLE ( T_COLON_COLON )? allocatable_decl_list end_of_stmt
           {action.allocatable_stmt(lbl, $T_ALLOCATABLE, $end_of_stmt.tk);}
   ;

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

allocatable_decl_list
@init{int count=0;}
   :       {action.allocatable_decl_list__begin();}
       allocatable_decl {count++;} ( T_COMMA allocatable_decl {count++;} )*
           {action.allocatable_decl_list(count);}
   ;

// R521
// generic_name_list substituted for object_name_list
asynchronous_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ASYNCHRONOUS ( T_COLON_COLON )?
		generic_name_list end_of_stmt
			{action.asynchronous_stmt(lbl,$T_ASYNCHRONOUS,$end_of_stmt.tk);}
	;

// R522
bind_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? language_binding_spec
		( T_COLON_COLON )? bind_entity_list end_of_stmt
			{ action.bind_stmt(lbl, $end_of_stmt.tk); }
	;

// R523
// T_IDENT inlined for entity_name and common_block_name
bind_entity
	:	T_IDENT 
        { action.bind_entity($T_IDENT, false); }// isCommonBlockName=false
	|	T_SLASH T_IDENT T_SLASH 
        { action.bind_entity($T_IDENT, true); }// isCommonBlockname=true
	;

bind_entity_list
@init{ int count=0;}
    :  		{action.bind_entity_list__begin();}
		bind_entity {count++;} ( T_COMMA bind_entity {count++;} )*
      		{action.bind_entity_list(count);}
    ;

// R524
data_stmt
@init {Token lbl = null; int count=1;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_DATA data_stmt_set ( ( T_COMMA )? 
            data_stmt_set {count++;})* end_of_stmt
			{ action.data_stmt(lbl, $T_DATA, $end_of_stmt.tk, count); }
    ;

// R525
data_stmt_set
	:	data_stmt_object_list
		T_SLASH
		data_stmt_value_list
		T_SLASH
            { action.data_stmt_set(); }
	;

// R526
data_stmt_object
@after {
    action.data_stmt_object();
}
	:	variable
	|	data_implied_do
	;

data_stmt_object_list
@init{ int count=0;}
    :  		{action.data_stmt_object_list__begin();}
		data_stmt_object {count++;} ( T_COMMA data_stmt_object {count++;} )*
      		{action.data_stmt_object_list(count);}
    ;


// R527
// ERR_CHK 527 scalar_int_expr replaced by expr
// data_i_do_variable replaced by T_IDENT
data_implied_do
@init {
    boolean hasThirdExpr = false;
}
    : T_LPAREN data_i_do_object_list T_COMMA T_IDENT T_EQUALS
        expr T_COMMA expr ( T_COMMA expr { hasThirdExpr = true; })? T_RPAREN
        { action.data_implied_do($T_IDENT, hasThirdExpr); }
    ;

// R528
// data_ref inlined for scalar_structure_component and array_element
data_i_do_object
@after {
    action.data_i_do_object();
}
	:	data_ref
	|	data_implied_do
	;

data_i_do_object_list
@init{ int count=0;}
    :  		{action.data_i_do_object_list__begin();}
		data_i_do_object {count++;} ( T_COMMA data_i_do_object {count++;} )*
      		{action.data_i_do_object_list(count);}
    ;

// R529 data_i_do_variable was scalar_int_variable inlined as T_IDENT
// C556 (R529) The data-i-do-variable shall be a named variable.

// R530
// ERR_CHK R530 designator is scalar-constant or integer constant when 
// followed by '*'
// data_stmt_repeat inlined from R531
// structure_constructure covers null_init if 'NULL()' so null_init deleted
// TODO - check for other cases of signed_real_literal_constant and 
// real_literal_constant problems
data_stmt_value
options {backtrack=true; k=3;}
@init {Token ast = null;}
@after{action.data_stmt_value(ast);}
   :   designator (T_ASTERISK data_stmt_constant {ast=$T_ASTERISK;})?
   |   int_literal_constant (T_ASTERISK data_stmt_constant {ast=$T_ASTERISK;})?
   |   signed_real_literal_constant
   |   signed_int_literal_constant
   |   complex_literal_constant
   |   logical_literal_constant
   |   char_literal_constant
   |   boz_literal_constant
   |   structure_constructor       // is null_init if 'NULL()'
   |   hollerith_literal_constant  // deleted in F77
   ;

data_stmt_value_list
@init{ int count=0;}
    :  		{action.data_stmt_value_list__begin();}
		data_stmt_value {count++;} ( T_COMMA data_stmt_value {count++;} )*
      		{action.data_stmt_value_list(count);}
    ;

// R531 data_stmt_repeat inlined as (int_literal_constant | designator) in R530
// ERRCHK 531 int_constant shall be a scalar_int_constant
// scalar_int_constant replaced by int_constant replaced by 
// int_literal_constant as T_IDENT covered by designator
// scalar_int_constant_subobject replaced by designator

scalar_int_constant
    :   int_constant
            { action.scalar_int_constant(); }
    ;

// R532
// scalar_constant_subobject replaced by designator
// scalar_constant replaced by literal_constant as designator can be T_IDENT
// then literal_constant inlined (except for signed portion)
// structure_constructure covers null_init if 'NULL()' so null_init deleted
// The lookahead in the alternative for signed_real_literal_constant is 
// necessary because ANTLR won't look far enough ahead by itself and when it
// sees a T_DIGIT_STRING, it tries the signed_int_literal_constant.  this isn't
// correct since the new version of the real_literal_constants can start with
// a T_DIGIT_STRING.  
data_stmt_constant
options {backtrack=true; k=3;}
@after {
    action.data_stmt_constant();
}
	:	designator
	|	signed_int_literal_constant
    |   signed_real_literal_constant
	|	complex_literal_constant
	|	logical_literal_constant
	|	char_literal_constant
	|	boz_literal_constant
	|	structure_constructor // is null_init if 'NULL()'
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

// R533 int_constant_subobject was constant_subobject inlined as designator 
// in R531

// R534 constant_subobject inlined as designator in R533
// C566 (R534) constant-subobject shall be a subobject of a constant.

// R535, R543-F2008
// array_name replaced by T_IDENT
dimension_stmt
@init {Token lbl=null; int count=1;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_DIMENSION ( T_COLON_COLON )? 
        dimension_decl ( T_COMMA dimension_decl {count++;})* end_of_stmt
			{ action.dimension_stmt(lbl, $T_DIMENSION, $end_of_stmt.tk, count); }
    ;

// R535-subrule
dimension_decl
   :   T_IDENT T_LPAREN array_spec T_RPAREN
           {action.dimension_decl($T_IDENT);}
   ;

// R536
// generic_name_list substituted for dummy_arg_name_list
intent_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_INTENT T_LPAREN intent_spec T_RPAREN 
            ( T_COLON_COLON )? generic_name_list end_of_stmt
			{action.intent_stmt(lbl,$T_INTENT,$end_of_stmt.tk);}
	;

// R537
// generic_name_list substituted for dummy_arg_name_list
optional_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:   (label {lbl=$label.tk;})? T_OPTIONAL ( T_COLON_COLON )? 
            generic_name_list end_of_stmt
			{ action.optional_stmt(lbl, $T_OPTIONAL, $end_of_stmt.tk); }
		
	;

// R538
parameter_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_PARAMETER T_LPAREN 
            named_constant_def_list T_RPAREN end_of_stmt
			{action.parameter_stmt(lbl,$T_PARAMETER,$end_of_stmt.tk);}
	;

named_constant_def_list
@init{ int count=0;}
    :  		{action.named_constant_def_list__begin();}
		named_constant_def {count++;} 
            ( T_COMMA named_constant_def {count++;} )*
      		{action.named_constant_def_list(count);}
    ;

// R539
// ERR_CHK 539 initialization_expr replaced by expr
// ERR_CHK 539 named_constant replaced by T_IDENT
named_constant_def
	:	T_IDENT T_EQUALS expr
			{action.named_constant_def($T_IDENT);}
	;

/*
 * R550-F08
 *    is POINTER [ :: ] pointer-decl-list
 */

////////////
// R550-F08, R540-F03
//
// Cray pointer extension added 11/17/2010
//
pointer_stmt
@init {Token lbl=null; boolean isCrayPointer=false;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})? T_POINTER
       (
              cray_pointer_assoc_list  {isCrayPointer = true;}
          |
              ( ( T_COLON_COLON )? pointer_decl_list )
       ) end_of_stmt
              {
                 if (isCrayPointer) {
                    action.cray_pointer_stmt(lbl,$T_POINTER,$end_of_stmt.tk);
                 } else {
                    action.pointer_stmt(lbl,$T_POINTER,$end_of_stmt.tk);
                 }
              }
   ;

pointer_decl_list
@init{int count=0;}
   :      {action.pointer_decl_list__begin();}
       pointer_decl {count++;} ( T_COMMA pointer_decl {count++;} )*
          {action.pointer_decl_list(count);}
   ;

/*
 * R551-F08
 *    is object-name [ ( deferred-shape-spec-list ) ]
 *    or proc-entity-name    
 */

////////////
// R551-F08, R541-F03
//
// T_IDENT inlined as object_name and proc_entity_name (removing second alt)
pointer_decl
@init{boolean hasSpecList=false;}
    :    T_IDENT ( T_LPAREN deferred_shape_spec_list T_RPAREN 
            {hasSpecList=true;})?
			{action.pointer_decl($T_IDENT,hasSpecList);}
    ;

cray_pointer_assoc_list
@init{int count=0;}
   :      {action.cray_pointer_assoc_list__begin();}
       cray_pointer_assoc {count++;} ( T_COMMA cray_pointer_assoc {count++;} )*
          {action.cray_pointer_assoc_list(count);}
   ;

cray_pointer_assoc
   :   T_LPAREN pointer=T_IDENT T_COMMA pointee=T_IDENT T_RPAREN
          {action.cray_pointer_assoc(pointer, pointee);}
   ;

// R542
// generic_name_list substituted for entity_name_list
protected_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_PROTECTED ( T_COLON_COLON )? 
            generic_name_list end_of_stmt
			{action.protected_stmt(lbl,$T_PROTECTED,$end_of_stmt.tk);}
	;

// R543
save_stmt
@init {Token lbl = null; boolean hasSavedEntityList=false;}
@after{checkForInclude();}
    : (label {lbl=$label.tk;})? T_SAVE ( ( T_COLON_COLON )? 
            saved_entity_list {hasSavedEntityList=true;})? end_of_stmt
		    {action.save_stmt(lbl,$T_SAVE,$end_of_stmt.tk,hasSavedEntityList);}
    ;

// R544
// T_IDENT inlined for object_name, proc_pointer_name (removing second alt), 
// and common_block_name
saved_entity
	:	id=T_IDENT
			{action.saved_entity(id, false);}
	|	T_SLASH id=T_IDENT T_SLASH
			{action.saved_entity(id, true);}	// is common block name
	;

saved_entity_list
@init{ int count=0;}
    :  		{action.saved_entity_list__begin();}
		saved_entity {count++;} ( T_COMMA saved_entity {count++;} )*
      		{action.saved_entity_list(count);}
    ;


// R545 proc_pointer_name was name inlined as T_IDENT

// R546, R555-F08
// T_IDENT inlined for object_name
target_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_TARGET ( T_COLON_COLON )? target_decl_list end_of_stmt
			{action.target_stmt(lbl,$T_TARGET,$end_of_stmt.tk);}
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

// R557-F08
target_decl_list
@init{ int count=0;}
   :       {action.target_decl_list__begin();}
       target_decl {count++;} ( T_COMMA target_decl {count++;} )*
           {action.target_decl_list(count);}
   ;

// R547
// generic_name_list substituted for dummy_arg_name_list
value_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_VALUE ( T_COLON_COLON )? 
            generic_name_list end_of_stmt
		    {action.value_stmt(lbl,$T_VALUE,$end_of_stmt.tk);}
	;

// R548
// generic_name_list substituted for object_name_list
volatile_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_VOLATILE ( T_COLON_COLON )? 
            generic_name_list end_of_stmt
		    {action.volatile_stmt(lbl,$T_VOLATILE,$end_of_stmt.tk);}
	;

// R549
implicit_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_IMPLICIT implicit_spec_list end_of_stmt
			{action.implicit_stmt(lbl, $T_IMPLICIT, null, $end_of_stmt.tk, 
                true);} // hasImplicitSpecList=true
	|	(label {lbl=$label.tk;})? T_IMPLICIT T_NONE end_of_stmt
			{action.implicit_stmt(lbl, $T_IMPLICIT, $T_NONE, $end_of_stmt.tk, 
                false);} // hasImplicitSpecList=false
	;

// R550
implicit_spec
	:	declaration_type_spec T_LPAREN letter_spec_list T_RPAREN
        { action.implicit_spec(); }
	;

implicit_spec_list
@init{ int count=0;}
    :  		{action.implicit_spec_list__begin();}
		implicit_spec {count++;} ( T_COMMA implicit_spec {count++;} )*
      		{action.implicit_spec_list(count);}
    ;


// R551
// TODO: here, we'll accept a T_IDENT, and then we'll have to do error 
// checking on it.  
letter_spec 
    : id1=T_IDENT ( T_MINUS id2=T_IDENT )? 
        { action.letter_spec(id1, id2); }
    ;

letter_spec_list
@init{ int count=0;}
    :  		{action.letter_spec_list__begin();}
		letter_spec {count++;} ( T_COMMA letter_spec {count++;} )*
      		{action.letter_spec_list(count);}
    ;

// R552
// T_IDENT inlined for namelist_group_name
namelist_stmt
@init {Token lbl = null;int count =1;}
@after{checkForInclude();}
    :	(label {lbl=$label.tk;})? T_NAMELIST T_SLASH nlName=T_IDENT T_SLASH
			{action.namelist_group_name(nlName);}
    	namelist_group_object_list
		( ( T_COMMA )?  T_SLASH nlName=T_IDENT T_SLASH
			{action.namelist_group_name(nlName);}
		namelist_group_object_list {count++;})* end_of_stmt
			{action.namelist_stmt(lbl,$T_NAMELIST,$end_of_stmt.tk,count);}
    ;

// R553 namelist_group_object was variable_name inlined as T_IDENT

// T_IDENT inlined for namelist_group_object
namelist_group_object_list
@init{ int count=0;}
    :  		{action.namelist_group_object_list__begin();}
		goName=T_IDENT {action.namelist_group_object(goName); count++;}
		    ( T_COMMA goName=T_IDENT 
            {action.namelist_group_object(goName); count++;} )*
      		{action.namelist_group_object_list(count);}
    ;

// R554
equivalence_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_EQUIVALENCE equivalence_set_list 
            end_of_stmt
			{action.equivalence_stmt(lbl, $T_EQUIVALENCE, $end_of_stmt.tk);}
	;

// R555
equivalence_set
	:	T_LPAREN equivalence_object T_COMMA equivalence_object_list T_RPAREN
        { action.equivalence_set(); }
	;


equivalence_set_list
@init{ int count=0;}
    :  		{action.equivalence_set_list__begin();}
		equivalence_set {count++;} ( T_COMMA equivalence_set {count++;} )*
      		{action.equivalence_set_list(count);}
    ;

// R556
// T_IDENT inlined for variable_name
// data_ref inlined for array_element
// data_ref isa T_IDENT so T_IDENT deleted (removing first alt)
// substring isa data_ref so data_ref deleted (removing second alt)
equivalence_object
	:	substring { action.equivalence_object(); }
	;

equivalence_object_list
@init{ int count=0;}
    :  		{action.equivalence_object_list__begin();}
		equivalence_object {count++;} 
            ( T_COMMA equivalence_object {count++;} )*
      		{action.equivalence_object_list(count);}
    ;

// R557
// action.common_block_name must be called here because it needs
//     to be called even if optional '/common_block_name/' is not present
common_stmt
@init {Token lbl=null; int numBlocks=1;} 
@after{checkForInclude();}
    : (label {lbl=$label.tk;})? 
		T_COMMON ( cb_name=common_block_name )?
			{ action.common_block_name(cb_name); }
		common_block_object_list
		( ( T_COMMA )? cb_name=common_block_name
			{ action.common_block_name(cb_name); }
		common_block_object_list {numBlocks++;} )* end_of_stmt
			{action.common_stmt(lbl, $T_COMMON, $end_of_stmt.tk, numBlocks);}
    ;

// T_SLASH_SLASH must be a option in case there are no spaces slashes, '//'
common_block_name returns [Token id]
	: T_SLASH_SLASH {id=null;}
	| T_SLASH (T_IDENT)? T_SLASH {id=$T_IDENT;}
	;

// R558
// T_IDENT inlined for variable_name and proc_pointer_name
// T_IDENT covered by first alt so second deleted
common_block_object
@init{boolean hasShapeSpecList=false;}
    : T_IDENT ( T_LPAREN explicit_shape_spec_list T_RPAREN 
            {hasShapeSpecList=true;})?
			{action.common_block_object($T_IDENT,hasShapeSpecList);}
    ;

common_block_object_list
@init{ int count=0;}
    :  		{action.common_block_object_list__begin();}
		common_block_object {count++;} 
            ( T_COMMA common_block_object {count++;} )*
      		{action.common_block_object_list(count);}
    ;


/**
 * Section/Clause 6: Use of data objects
 */               


// R601
variable
   :   designator {action.variable();}
   ;

// R602 variable_name was name inlined as T_IDENT

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

//
// a function_reference is ambiguous with designator, ie, foo(b) could be an 
// array element
//	function_reference : procedure_designator T_LPAREN 
// ( actual_arg_spec_list )? T_RPAREN
//                       procedure_designator isa data_ref
// C1220 (R1217) The procedure-designator shall designate a function.
// data_ref may (or not) match T_LPAREN ( actual_arg_spec_list )? T_RPAREN, 
// so is optional
designator_or_func_ref
@init {
    boolean hasSubstringRangeOrArgList = false;
    boolean hasSubstringRange = false;
}
@after {
    action.designator_or_func_ref();
}
	:	data_ref (T_LPAREN substring_range_or_arg_list
					{
						hasSubstringRangeOrArgList = true;
						hasSubstringRange=
                            $substring_range_or_arg_list.isSubstringRange;
					}
				  T_RPAREN)?
			{
				if (hasSubstringRangeOrArgList) {
					if (hasSubstringRange) {
						action.designator(hasSubstringRange);
					} else {
                        // hasActualArgSpecList=true
						action.function_reference(true);
					}
				}
			}
	|	char_literal_constant T_LPAREN substring_range T_RPAREN
			{ hasSubstringRange=true; action.substring(hasSubstringRange); }
	;

substring_range_or_arg_list returns [boolean isSubstringRange]
@init {
    boolean hasUpperBound = false;
    Token keyword = null;
    int count = 0;
}
@after {
    action.substring_range_or_arg_list();
}
	:	T_COLON (expr {hasUpperBound = true;})? // substring_range
			{
                // hasLowerBound=false
                action.substring_range(false, hasUpperBound);	
                isSubstringRange=true;
			}
	|		{ 
                /* mimic actual-arg-spec-list */
                action.actual_arg_spec_list__begin();  
			}
		expr substr_range_or_arg_list_suffix
			{
                isSubstringRange = 
                    $substr_range_or_arg_list_suffix.isSubstringRange;
			}
	|		{
                /* mimic actual-arg-spec-list */
                action.actual_arg_spec_list__begin(); 
			}
		T_IDENT T_EQUALS expr
			{
                count++;
                action.actual_arg(true, null);
                action.actual_arg_spec($T_IDENT);
			}
		( T_COMMA actual_arg_spec {count++;} )*
			{
                action.actual_arg_spec_list(count);
                isSubstringRange = false;
			}
	|		{
                /* mimic actual-arg-spec-list */
                action.actual_arg_spec_list__begin(); 
			}
		( T_IDENT T_EQUALS {keyword=$T_IDENT;} )? T_ASTERISK label
			{
                count++;
                action.actual_arg(false, $label.tk);
                action.actual_arg_spec(keyword);
			}
		( T_COMMA actual_arg_spec {count++;} )*
			{
                action.actual_arg_spec_list(count);
                isSubstringRange = false;
			}
	;

substr_range_or_arg_list_suffix returns [boolean isSubstringRange]
@init {boolean hasUpperBound = false; int count = 0;}
@after{action.substr_range_or_arg_list_suffix();}
	:		{
                // guessed wrong on list creation, inform of error
                action.actual_arg_spec_list(-1);  
			}
		T_COLON (expr {hasUpperBound=true;})? // substring_range
			{
                // hasLowerBound=true
                action.substring_range(true, hasUpperBound);
                isSubstringRange = true;
			}
	|
			{
                count++;
                action.actual_arg(true, null);	// hasExpr=true, label=null
                action.actual_arg_spec(null);		// keywork=null
			}
		( T_COMMA actual_arg_spec {count++;} )*
			{
                action.actual_arg_spec_list(count);
                isSubstringRange=false;
			}	// actual_arg_spec_list
	;

// R604
logical_variable
	:	variable
            { action.logical_variable(); }
	;

// R605
default_logical_variable
	:	variable
            { action.default_logical_variable(); }
	;

scalar_default_logical_variable
	:	variable
            { action.scalar_default_logical_variable(); }
	;

// R606
char_variable
	:	variable
            { action.char_variable(); }
	;

// R607
default_char_variable
	:	variable
            { action.default_char_variable(); }
	;

scalar_default_char_variable
	:	variable
            { action.scalar_default_char_variable(); }
	;

// R608
int_variable
	:	variable
            { action.int_variable(); }
	;

// R609
// C608 (R610) parent_string shall be of type character
// fix for ambiguity in data_ref allows it to match T_LPAREN substring_range 
// T_RPAREN, so required T_LPAREN substring_range T_RPAREN made optional
// ERR_CHK 609 ensure final () is (substring-range)
substring
@init{boolean hasSubstringRange = false;}
	:	data_ref (T_LPAREN substring_range {hasSubstringRange=true;} T_RPAREN)?
			{ action.substring(hasSubstringRange); }
	|	char_literal_constant T_LPAREN substring_range T_RPAREN
			{ action.substring(true); }
	;

// R610 parent_string inlined in R609 as (data_ref | char_literal_constant)
// T_IDENT inlined for scalar_variable_name
// data_ref inlined for scalar_structure_component and array_element
// data_ref isa T_IDENT so T_IDENT deleted
// scalar_constant replaced by char_literal_constant as data_ref isa T_IDENT 
// and must be character

// R611
// ERR_CHK 611 scalar_int_expr replaced by expr
substring_range
@init{
    boolean hasLowerBound = false;
    boolean hasUpperBound = false;
}
	:	(expr {hasLowerBound = true;})? T_COLON	(expr {hasUpperBound = true;})?
			{ action.substring_range(hasLowerBound, hasUpperBound); }
	;

// R612
data_ref
@init{int numPartRefs = 0;}
	:	part_ref {numPartRefs += 1;} ( T_PERCENT part_ref {numPartRefs += 1;})*
			{action.data_ref(numPartRefs);}
	;

/**
 * R612-F08 part-ref
 *    is part-name [ ( section-subscript-list ) ] [ image-selector]
 */

////////////
// R612-F08, R613-F03
//
// This rule is implemented in the FortranParserExtras grammar
//
part_ref
   :   T_IDENT
           {System.err.println("ERROR: part_ref implemented in FortranParserExtras.java");}
   ;


// R614 structure_component inlined as data_ref

// R615 type_param_inquiry inlined in R701 then deleted as can be designator
// T_IDENT inlined for type_param_name

// R616 array_element inlined as data_ref

// R617 array_section inlined in R603

// R618 subscript inlined as expr
// ERR_CHK 618 scalar_int_expr replaced by expr


/**
 * R620-F08 section-subscript
 *    is subscript
 *    or subscript-triplet
 *    or vector-subscript
 */

////////////
// R620-F08, R619-F03
//
// This rule is implemented in FortranParserExtras grammar


// R620 subscript_triplet inlined in R619
// inlined expr as subscript and stride in subscript_triplet

// R621 stride inlined as expr
// ERR_CHK 621 scalar_int_expr replaced by expr

// R622
// ERR_CHK 622 int_expr replaced by expr
vector_subscript
	:	expr
            { action.vector_subscript(); }
	;

// R622 inlined vector_subscript as expr in R619
// ERR_CHK 622 int_expr replaced by expr

// R623
// modified to remove backtracking by looking for the token inserted during
// the lexical prepass if a :: was found (which required alt1 below).
allocate_stmt
@init {Token lbl = null;
       boolean hasTypeSpec = false;
       boolean hasAllocOptList = false;}
@after{checkForInclude();}
    :	(label {lbl=$label.tk;})? T_ALLOCATE_STMT_1 T_ALLOCATE T_LPAREN
		type_spec T_COLON_COLON
		allocation_list 
		( T_COMMA alloc_opt_list {hasAllocOptList=true;} )? T_RPAREN 
            end_of_stmt
    		{
    			hasTypeSpec = true;
    			action.allocate_stmt(lbl, $T_ALLOCATE, $end_of_stmt.tk, 
                                     hasTypeSpec, hasAllocOptList);
    		}
    |	(label {lbl=$label.tk;})? T_ALLOCATE T_LPAREN
    	allocation_list
    	( T_COMMA alloc_opt_list {hasAllocOptList=true;} )? T_RPAREN 
            end_of_stmt
    		{
    			action.allocate_stmt(lbl, $T_ALLOCATE, $end_of_stmt.tk, 
                                     hasTypeSpec, hasAllocOptList);
    		}
    ;

// R624
// ERR_CHK 624 source_expr replaced by expr
// stat_variable and errmsg_variable replaced by designator
alloc_opt
	:	T_IDENT T_EQUALS expr
            /* {'STAT','ERRMSG'} are variables {SOURCE'} is expr */
			{ action.alloc_opt($T_IDENT); }
	;

alloc_opt_list
@init{ int count=0;}
    :  		{action.alloc_opt_list__begin();}
		alloc_opt {count++;} ( T_COMMA alloc_opt {count++;} )*
      		{action.alloc_opt_list(count);}
    ;

// R625 stat_variable was scalar_int_variable inlined in R624 and R636
// R626 errmsg_variable was scalar_default_char_variable inlined in R624 
// and R636
// R627 inlined source_expr was expr

////////////
// R631-F08, R628-F03
//
// This rule is implemented in the FortranParserExtras grammar
//
allocation
   :   T_IDENT
           {System.err.println("ERROR: allocation implemented in FortranParserExtras.java");}
   ;

allocation_list
@init{ int count=0;}
   :       {action.allocation_list__begin();}
       allocation {count++;} ( T_COMMA allocation {count++;} )*
           {action.allocation_list(count);}
   ;

/**
 * R632-F08 allocate-object
 *    is variable-name
 *    structure-component
 */

////////////
// R636-F08, R629-F03
//
// This rule is implemented in the FortranParserExtras grammar
//
allocate_object
   :   T_IDENT
           {System.err.println("ERROR: allocate_object implemented in FortranParserExtras.java");}
   ;

allocate_object_list
@init{ int count=0;}
    :  		{action.allocate_object_list__begin();}
		allocate_object {count++;} ( T_COMMA allocate_object {count++;} )*
      		{action.allocate_object_list(count);}
    ;

// R630
// ERR_CHK 630a lower_bound_expr replaced by expr
// ERR_CHK 630b upper_bound_expr replaced by expr

// SAD NOTE 1: In ROSE, there is no IR for allocations. That is, there is no place in the AST to hold the
// 'allocate_shape_spec_list' and 'rice_allocate_coarray_spec' if any. The only way to preserve them is
// to encode them in the 'allocate_object' itself, i.e. as part of an expression.

// SAD NOTE 2: In this rule, the 'allocate_shape_spec_list' is never recognized. Its corresponding action
// 'action.allocate_shape_spec' is a no-op in ROSE. Shape specs are parsed by the 'allocate_object' rule
// as a section subscript list within a part ref. Sigh! On the other hand, this is just as well because
// there is no other way to represent the shape specs (see Sad Note 1).

allocate_shape_spec
@init{boolean hasLowerBound = false; boolean hasUpperBound = true;}
	:	expr (T_COLON expr)?
    		{	// note, allocate-shape-spec always has upper bound
    			// grammar was refactored to remove left recursion, 
                // looks deceptive
    			action.allocate_shape_spec(hasLowerBound, hasUpperBound);
    		}
    ;

allocate_shape_spec_list
@init{ int count=0;}
    :  		{action.allocate_shape_spec_list__begin();}
		allocate_shape_spec {count++;} 
            ( T_COMMA allocate_shape_spec {count++;} )*
      		{action.allocate_shape_spec_list(count);}
    ;

// R631 inlined lower_bound_expr was scalar_int_expr

// R632 inlined upper_bound_expr was scalar_int_expr


/*
 * R636-F08 allocate-coarray-spec
 *    is   [ allocate-coshape-spec-list , ] [ lower-bound-expr : ] *
 */

////////////
// R636-F08
//
// This rule is implemented in FortranParserExtras grammar


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


// R633
nullify_stmt
@init {Token lbl = null;} // @init{INIT_TOKEN_NULL(lbl);}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})?
		T_NULLIFY T_LPAREN pointer_object_list T_RPAREN end_of_stmt
			{ action.nullify_stmt(lbl, $T_NULLIFY, $end_of_stmt.tk); }
	;

// R634
// T_IDENT inlined for variable_name and proc_pointer_name
// data_ref inlined for structure_component
// data_ref can be a T_IDENT so T_IDENT deleted
pointer_object
	:	data_ref
            { action.pointer_object(); }
	;

pointer_object_list
@init{ int count=0;}
    :  		{action.pointer_object_list__begin();}
		pointer_object {count++;} ( T_COMMA pointer_object {count++;} )*
      		{action.pointer_object_list(count);}
    ;

// R635
deallocate_stmt
@init {Token lbl = null; boolean hasDeallocOptList=false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_DEALLOCATE T_LPAREN allocate_object_list 
            ( T_COMMA dealloc_opt_list {hasDeallocOptList=true;})? 
            T_RPAREN end_of_stmt
			{action.deallocate_stmt(lbl, $T_DEALLOCATE, $end_of_stmt.tk, 
                hasDeallocOptList);}
    ;

// R636
// stat_variable and errmsg_variable replaced by designator
dealloc_opt
	:	T_IDENT /* {'STAT','ERRMSG'} */ T_EQUALS designator
            { action.dealloc_opt($T_IDENT); }
	;

dealloc_opt_list
@init{ int count=0;}
    :  		{action.dealloc_opt_list__begin();}
		dealloc_opt {count++;} ( T_COMMA dealloc_opt {count++;} )*
      		{action.dealloc_opt_list(count);}
    ;

/**
 * Section/Clause 7: Expressions and assignment
 */

// R701
// constant replaced by literal_constant as T_IDENT can be designator
// T_IDENT inlined for type_param_name
// data_ref in designator can be a T_IDENT so T_IDENT deleted
// type_param_inquiry is designator T_PERCENT T_IDENT can be designator so 
// deleted 
// function_reference integrated with designator (was ambiguous) and 
// deleted (to reduce backtracking)
primary
options {backtrack=true;}       // alt 1,4 ambiguous
@after {action.primary();}
	:	designator_or_func_ref
	|	literal_constant
	|	array_constructor
	|	structure_constructor
	|	T_LPAREN expr T_RPAREN {action.parenthesized_expr();}
	;

// R702
level_1_expr
@init{Token tk = null;} //@init{INIT_TOKEN_NULL(tk);}
    : (defined_unary_op {tk = $defined_unary_op.tk;})? primary
    		{action.level_1_expr(tk);}
    ;

// R703
defined_unary_op returns [Token tk]
	:	T_DEFINED_OP {tk = $T_DEFINED_OP;}
            { action.defined_unary_op($T_DEFINED_OP); }
	;

// inserted as R704 functionality
power_operand
@init{boolean hasPowerOperand = false;}
	: level_1_expr (power_op power_operand {hasPowerOperand = true;})?
			{action.power_operand(hasPowerOperand);}
	;	

// R704
// see power_operand
mult_operand
@init{int numMultOps = 0;}
//    : level_1_expr ( power_op mult_operand )?
//    : power_operand
    : power_operand (mult_op power_operand
            { action.mult_operand__mult_op($mult_op.tk); numMultOps += 1; })*
    		{ action.mult_operand(numMultOps); }
    ;

// R705-addition
// This rule has been added so the unary plus/minus has the correct
// precedence when actions are fired.
signed_operand
@init{int numAddOps = 0;}
   :   (tk=add_op)? mult_operand 
          {action.signed_operand(tk);}
   ;

// R705
// moved leading optionals to mult_operand
add_operand
@init{int numAddOps = 0;}
@after{action.add_operand(numAddOps);}
//    : ( add_operand mult_op )? mult_operand
//    : ( mult_operand mult_op )* mult_operand
   :   signed_operand
       ( tk=add_op mult_operand 
            {action.add_operand__add_op(tk); numAddOps += 1;}
       )*
   ;

// R706
// moved leading optionals to add_operand
level_2_expr
@init{int numConcatOps = 0;}
//    : ( ( level_2_expr )? add_op )? add_operand
// check notes on how to remove this left recursion  
// (WARNING something like the following)
//    : (add_op)? ( add_operand add_op )* add_operand
    : add_operand ( concat_op add_operand {numConcatOps += 1;})*
    		{action.level_2_expr(numConcatOps);}
    ;

// R707
power_op returns [Token tk]
	:	T_POWER	{tk = $T_POWER;}
            { action.power_op($T_POWER); }
	;

// R708
mult_op returns [Token tk]
	:	T_ASTERISK	{ tk = $T_ASTERISK; action.mult_op(tk); }
	|	T_SLASH		{ tk = $T_SLASH; action.mult_op(tk); }
	;

// R709
add_op returns [Token tk]
	:	T_PLUS  { tk = $T_PLUS; action.add_op(tk); }
	|	T_MINUS { tk = $T_MINUS; action.add_op(tk); }
	;

// R710
// moved leading optional to level_2_expr
level_3_expr
@init{Token relOp = null;} //@init{INIT_TOKEN_NULL(relOp);}
//    : ( level_3_expr concat_op )? level_2_expr
//    : ( level_2_expr concat_op )* level_2_expr
    : level_2_expr (rel_op level_2_expr {relOp = $rel_op.tk;})?
    		{action.level_3_expr(relOp);}
    ;

// R711
concat_op returns [Token tk]
	:	T_SLASH_SLASH	{ tk = $T_SLASH_SLASH; action.concat_op(tk); }
	;

// R712
// moved leading optional to level_3_expr
// inlined level_3_expr for level_4_expr in R714
//level_4_expr
//    : ( level_3_expr rel_op )? level_3_expr
//    : level_3_expr
//    ;

// R713
rel_op returns [Token tk]
@after {
    action.rel_op(tk);
}
	:	T_EQ				{tk=$T_EQ;}
	|	T_NE				{tk=$T_NE;}
	|	T_LT				{tk=$T_LT;}
	|	T_LE				{tk=$T_LE;}
	|	T_GT				{tk=$T_GT;}
	|	T_GE				{tk=$T_GE;}
	|	T_EQ_EQ				{tk=$T_EQ_EQ;}
	|	T_SLASH_EQ			{tk=$T_SLASH_EQ;}
	|	T_LESSTHAN			{tk=$T_LESSTHAN;}
	|	T_LESSTHAN_EQ		{tk=$T_LESSTHAN_EQ;}
	|	T_GREATERTHAN		{tk=$T_GREATERTHAN;}
	|	T_GREATERTHAN_EQ	{tk=$T_GREATERTHAN_EQ;}
	;

// R714
// level_4_expr inlined as level_3_expr
and_operand
@init {
    boolean hasNotOp0 = false; // @init{INIT_BOOL_FALSE(hasNotOp0);
    boolean hasNotOp1 = false; // @init{INIT_BOOL_FALSE(hasNotOp1);
    int numAndOps = 0;
}
//    :    ( not_op )? level_3_expr
	:	(not_op {hasNotOp0=true;})?
    	level_3_expr
		(and_op {hasNotOp1=false;} (not_op {hasNotOp1=true;})? level_3_expr
				{action.and_operand__not_op(hasNotOp1); numAndOps += 1;}
		)*
				{action.and_operand(hasNotOp0, numAndOps);}
    ;

// R715
// moved leading optional to or_operand
or_operand
@init{int numOrOps = 0;}
//    : ( or_operand and_op )? and_operand
//    : ( and_operand and_op )* and_operand
    : and_operand (or_op and_operand {numOrOps += 1;})*
    		{ action.or_operand(numOrOps); }
    ;

// R716
// moved leading optional to or_operand
// TODO - action for equiv_op token
equiv_operand
@init{int numEquivOps = 0;}
//    : ( equiv_operand or_op )? or_operand
//    : ( or_operand or_op )* or_operand
    : or_operand 
        (equiv_op or_operand
            {action.equiv_operand__equiv_op($equiv_op.tk); numEquivOps += 1;}
        )*
			{action.equiv_operand(numEquivOps);}
    ;

// R717
// moved leading optional to equiv_operand
level_5_expr
@init{int numDefinedBinaryOps = 0;}
//    : ( level_5_expr equiv_op )? equiv_operand
//    : ( equiv_operand equiv_op )* equiv_operand
    : equiv_operand (defined_binary_op equiv_operand
            {action.level_5_expr__defined_binary_op($defined_binary_op.tk); 
                numDefinedBinaryOps += 1;} )*
    		{action.level_5_expr(numDefinedBinaryOps);}
    ;

// R718
not_op returns [Token tk]
	:	T_NOT { tk = $T_NOT; action.not_op(tk); } 
	;

// R719
and_op returns [Token tk]
	:	T_AND { tk = $T_AND; action.and_op(tk); }
	;

// R720
or_op returns [Token tk]
	:	T_OR { tk = $T_OR; action.or_op(tk); }
	;

// R721
equiv_op returns [Token tk]
	:	T_EQV { tk = $T_EQV; action.equiv_op(tk); }
	|	T_NEQV { tk = $T_NEQV; action.equiv_op(tk); }
	;

// R722
// moved leading optional to level_5_expr
expr
//    : ( expr defined_binary_op )? level_5_expr
//    : ( level_5_expr defined_binary_op )* level_5_expr
    : level_5_expr
    	{action.expr();}
    ;

// R723
defined_binary_op returns [Token tk]
	:	T_DEFINED_OP { tk = $T_DEFINED_OP; action.defined_binary_op(tk); }
	;

// R724 inlined logical_expr was expr

// R725 inlined char_expr was expr

// R726 inlined default_char_expr

// R727 inlined int_expr

// R728 inlined numeric_expr was expr

// inlined scalar_numeric_expr was expr

// R729 inlined specification_expr was scalar_int_expr

// R730 inlined initialization_expr

// R731 inlined char_initialization_expr was char_expr

// inlined scalar_char_initialization_expr was char_expr

// R732 inlined int_initialization_expr was int_expr

// inlined scalar_int_initialization_expr was int_initialization_expr

// R733 inlined logical_initialization_expr was logical_expr

// inlined scalar_logical_initialization_expr was logical_expr

// R734
assignment_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ASSIGNMENT_STMT variable
		T_EQUALS expr end_of_stmt
			{action.assignment_stmt(lbl, $end_of_stmt.tk);}
	;

// R735
// ERR_TEST 735 ensure that part_ref in data_ref doesn't capture the T_LPAREN
// data_pointer_object and proc_pointer_object replaced by designator
// data_target and proc_target replaced by expr
// third alt covered by first alt so proc_pointer_object assignment deleted
// designator (R603), minus the substring part is data_ref, so designator 
// replaced by data_ref,
// see NOTE 6.10 for why array-section does not have pointer attribute
// TODO: alt1 and alt3 require the backtracking.  if find a way to disambiguate
// them, should be able to remove backtracking.
pointer_assignment_stmt
options {backtrack=true;}
@init {Token lbl = null;}
@after{checkForInclude();}
    : (label {lbl=$label.tk;})? T_PTR_ASSIGNMENT_STMT data_ref T_EQ_GT 
            expr end_of_stmt
			{action.pointer_assignment_stmt(lbl, $end_of_stmt.tk,false,false);}
    | (label {lbl=$label.tk;})? T_PTR_ASSIGNMENT_STMT data_ref T_LPAREN 
            bounds_spec_list T_RPAREN T_EQ_GT expr end_of_stmt
			{action.pointer_assignment_stmt(lbl, $end_of_stmt.tk, true,false);}
    | (label {lbl=$label.tk;})? T_PTR_ASSIGNMENT_STMT data_ref T_LPAREN 
            bounds_remapping_list T_RPAREN T_EQ_GT expr end_of_stmt
			{action.pointer_assignment_stmt(lbl, $end_of_stmt.tk, false,true);}
    ;

// R736
// ERR_CHK 736 ensure ( T_IDENT | designator ending in T_PERCENT T_IDENT)
// T_IDENT inlined for variable_name and data_pointer_component_name
// variable replaced by designator
data_pointer_object
	:	designator
            { action.data_pointer_object(); }
	;

// R737
// ERR_CHK 737 lower_bound_expr replaced by expr
bounds_spec
	:	expr T_COLON
            { action.bounds_spec(); }
	;

bounds_spec_list
@init{ int count=0;}
    :  		{action.bounds_spec_list__begin();}
		bounds_spec {count++;} ( T_COMMA bounds_spec {count++;} )*
      		{action.bounds_spec_list(count);}
    ;

// R738
// ERR_CHK 738a lower_bound_expr replaced by expr
// ERR_CHK 738b upper_bound_expr replaced by expr
bounds_remapping
	:	expr T_COLON expr
            { action.bounds_remapping(); }
	;

bounds_remapping_list
@init{ int count=0;}
    :  		{action.bounds_remapping_list__begin();}
		bounds_remapping {count++;} ( T_COMMA bounds_remapping {count++;} )*
      		{action.bounds_remapping_list(count);}
    ;

// R739 data_target inlined as expr in R459 and R735
// expr can be designator (via primary) so variable deleted

// R740
// ERR_CHK 740 ensure ( T_IDENT | ends in T_PERCENT T_IDENT )
// T_IDENT inlined for proc_pointer_name
// proc_component_ref replaced by designator T_PERCENT T_IDENT replaced 
// by designator
proc_pointer_object
	:	designator
            { action.proc_pointer_object(); }
	;

// R741 proc_component_ref inlined as designator T_PERCENT T_IDENT in R740, 
// R742, R1219, and R1221
// T_IDENT inlined for procedure_component_name
// designator inlined for variable

// R742 proc_target inlined as expr in R459 and R735
// ERR_CHK 736 ensure ( expr | designator ending in T_PERCENT T_IDENT)
// T_IDENT inlined for procedure_name
// T_IDENT isa expr so T_IDENT deleted
// proc_component_ref is variable T_PERCENT T_IDENT can be designator 
// so deleted

// R743
// ERR_CHK 743 mask_expr replaced by expr
// assignment_stmt inlined for where_assignment_stmt
where_stmt
@init {
    Token lbl = null;
    action.where_stmt__begin();
}
@after{checkForInclude();}
	:
		(label {lbl=$label.tk;})? T_WHERE_STMT T_WHERE
		T_LPAREN expr T_RPAREN assignment_stmt
			{action.where_stmt(lbl, $T_WHERE);}
	;

// R744
where_construct
@init {
    int numConstructs = 0;
    int numMaskedConstructs = 0;     
    boolean hasMaskedElsewhere = false;
    int numElsewhereConstructs = 0;  
    boolean hasElsewhere = false;
}
    :    where_construct_stmt ( where_body_construct {numConstructs += 1;} )*
          ( masked_elsewhere_stmt ( where_body_construct 
                {numMaskedConstructs += 1;} )*
                {hasMaskedElsewhere = true; 
                action.masked_elsewhere_stmt__end(numMaskedConstructs);}
          )*
          ( elsewhere_stmt ( where_body_construct 
                {numElsewhereConstructs += 1;} )*
                {hasElsewhere = true; 
                action.elsewhere_stmt__end(numElsewhereConstructs);}
          )?
         end_where_stmt
                {action.where_construct(numConstructs, hasMaskedElsewhere, 
                    hasElsewhere);}
    ;

// R745
// ERR_CHK 745 mask_expr replaced by expr
where_construct_stmt
@init {Token id=null;}
@after{checkForInclude();}
	:	( T_IDENT T_COLON {id=$T_IDENT;})? T_WHERE_CONSTRUCT_STMT T_WHERE 
            T_LPAREN expr T_RPAREN end_of_stmt
				{action.where_construct_stmt(id, $T_WHERE, $end_of_stmt.tk);}
    ;

// R746
// assignment_stmt inlined for where_assignment_stmt
where_body_construct
@after {
    action.where_body_construct();
}
	:	assignment_stmt
	|	where_stmt
	|	where_construct
	;

// R747 where_assignment_stmt inlined as assignment_stmt in R743 and R746

// R748 inlined mask_expr was logical_expr

// inlined scalar_mask_expr was scalar_logical_expr

// inlined scalar_logical_expr was logical_expr

// R749
// ERR_CHK 749 mask_expr replaced by expr
masked_elsewhere_stmt
@init {Token lbl = null;Token id=null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ELSE T_WHERE T_LPAREN expr T_RPAREN 
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt 
			{action.masked_elsewhere_stmt(lbl, $T_ELSE, $T_WHERE, id, 
                $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? T_ELSEWHERE T_LPAREN expr T_RPAREN 
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt 
			{action.masked_elsewhere_stmt(lbl, $T_ELSEWHERE, null,id,
                $end_of_stmt.tk);}
	;

// R750
elsewhere_stmt
@init { Token lbl = null; Token id=null;} 
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ELSE T_WHERE 
            (T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.elsewhere_stmt(lbl, $T_ELSE, $T_WHERE, id, 
                $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? T_ELSEWHERE (T_IDENT {id=$T_IDENT;})? 
            end_of_stmt 
			{action.elsewhere_stmt(lbl, $T_ELSEWHERE, null, id, 
                $end_of_stmt.tk);}
	;

// R751
end_where_stmt
@init {Token lbl = null; Token id=null;} // @init{INIT_TOKEN_NULL(lbl);}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_WHERE ( T_IDENT {id=$T_IDENT;} )? 
        end_of_stmt
		{action.end_where_stmt(lbl, $T_END, $T_WHERE, id, $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDWHERE ( T_IDENT {id=$T_IDENT;} )? 
        end_of_stmt
		{action.end_where_stmt(lbl, $T_ENDWHERE, null, id, $end_of_stmt.tk);}
	;

// R752
forall_construct
@after {
    action.forall_construct(); 
}
	:	forall_construct_stmt
		( forall_body_construct )*
		end_forall_stmt
	;

// R753
forall_construct_stmt
@init {Token lbl = null; Token id = null;} 
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? ( T_IDENT T_COLON {id=$T_IDENT;})? 
            T_FORALL_CONSTRUCT_STMT T_FORALL 
            forall_header end_of_stmt
				{action.forall_construct_stmt(lbl, id, $T_FORALL, 
                    $end_of_stmt.tk);}
    ;

// R754
// ERR_CHK 754 scalar_mask_expr replaced by expr
forall_header
@after {
    action.forall_header();
}
    : T_LPAREN forall_triplet_spec_list ( T_COMMA expr )? T_RPAREN
    ;

// R755
// T_IDENT inlined for index_name
// expr inlined for subscript and stride
forall_triplet_spec
@init{boolean hasStride=false;}
    : T_IDENT T_EQUALS expr T_COLON expr ( T_COLON expr {hasStride=true;})?
			{action.forall_triplet_spec($T_IDENT,hasStride);}
    ;


forall_triplet_spec_list
@init{ int count=0;}
    :  		{action.forall_triplet_spec_list__begin();}
		forall_triplet_spec {count++;} 
            ( T_COMMA forall_triplet_spec {count++;} )*
      		{action.forall_triplet_spec_list(count);}
    ;

// R756
forall_body_construct
@after {
    action.forall_body_construct();
}
	:	forall_assignment_stmt
	|	where_stmt
	|	where_construct
	|	forall_construct
	|	forall_stmt
	;

// R757
forall_assignment_stmt
@after{checkForInclude();}
	:	assignment_stmt
			{action.forall_assignment_stmt(false);}
	|	pointer_assignment_stmt
			{action.forall_assignment_stmt(true);}
	;

// R758
end_forall_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_FORALL ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_forall_stmt(lbl, $T_END, $T_FORALL, id, $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDFORALL ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_forall_stmt(lbl, $T_ENDFORALL, null, id, $end_of_stmt.tk);}
	;

// R759
// T_FORALL_STMT token is inserted by scanner to remove need for backtracking
forall_stmt
@init {
    Token lbl = null;
    action.forall_stmt__begin();
}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_FORALL_STMT T_FORALL
		forall_header
		forall_assignment_stmt
			{action.forall_stmt(lbl, $T_FORALL);}
	;


/**
 * Section/Clause 8: Execution control
 */


// R801
block
@after {
    action.block();
}
	:	( execution_part_construct )*
	;

// R802
if_construct
@after {
    action.if_construct();
}
    :   if_then_stmt block ( else_if_stmt block )* ( else_stmt block )? 
            end_if_stmt
    ;

// R803
// ERR_CHK 803 scalar_logical_expr replaced by expr
if_then_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
    : (label {lbl=$label.tk;})? ( T_IDENT T_COLON {id=$T_IDENT;} )? T_IF 
            T_LPAREN expr T_RPAREN T_THEN end_of_stmt
			{action.if_then_stmt(lbl, id, $T_IF, $T_THEN, $end_of_stmt.tk);}
    ;

// R804
// ERR_CHK 804 scalar_logical_expr replaced by expr
else_if_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_ELSE T_IF
        T_LPAREN expr T_RPAREN T_THEN ( T_IDENT {id=$T_IDENT;} )? end_of_stmt
			{action.else_if_stmt(lbl, $T_ELSE, $T_IF, $T_THEN, id, 
                $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ELSEIF
        T_LPAREN expr T_RPAREN T_THEN ( T_IDENT {id=$T_IDENT;} )? end_of_stmt
			{action.else_if_stmt(lbl, $T_ELSEIF, null, $T_THEN, id, 
                $end_of_stmt.tk);}
	;

// R805
else_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_ELSE ( T_IDENT {id=$T_IDENT;} )? 
            end_of_stmt
			{action.else_stmt(lbl, $T_ELSE, id, $end_of_stmt.tk);}
	;

// R806
end_if_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_IF ( T_IDENT {id=$T_IDENT;} )? 
        end_of_stmt
			{action.end_if_stmt(lbl, $T_END, $T_IF, id, $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDIF    ( T_IDENT {id=$T_IDENT;} )? 
            end_of_stmt
			{action.end_if_stmt(lbl, $T_ENDIF, null, id, $end_of_stmt.tk);}
	;

// R807
// ERR_CHK 807 scalar_logical_expr replaced by expr
// T_IF_STMT inserted by scanner to remove need for backtracking
if_stmt
@init {
    Token lbl = null;
    action.if_stmt__begin();
}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_IF_STMT T_IF T_LPAREN expr T_RPAREN 
			action_stmt
				{action.if_stmt(lbl, $T_IF);}
	;

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

// R808
case_construct
@after {
    action.case_construct();
}
    :    select_case_stmt ( case_stmt block )* end_select_stmt
    ;

// R809
// ERR_CHK 809 case_expr replaced by expr
select_case_stmt
@init {Token lbl = null; Token id=null; Token tk1 = null; Token tk2 = null;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? ( T_IDENT T_COLON {id=$T_IDENT;})?
        (T_SELECT T_CASE {tk1=$T_SELECT; tk2=$T_CASE;} 
            | T_SELECTCASE {tk1=$T_SELECTCASE; tk2=null;} )
            T_LPAREN expr T_RPAREN end_of_stmt
			{action.select_case_stmt(lbl, id, tk1, tk2, $end_of_stmt.tk);}
    ;

// R810
case_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_CASE case_selector
		    ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{ action.case_stmt(lbl, $T_CASE, id, $end_of_stmt.tk);}
	;

// R811
end_select_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_SELECT (T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
			{action.end_select_stmt(lbl, $T_END, $T_SELECT, id, 
                $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDSELECT    (T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
			{action.end_select_stmt(lbl, $T_ENDSELECT, null, id, 
                $end_of_stmt.tk);}
	;

// R812 inlined case_expr with expr was either scalar_int_expr 
// scalar_char_expr scalar_logical_expr

// inlined scalar_char_expr with expr was char_expr

// R813
case_selector
	:	T_LPAREN
		case_value_range_list
		T_RPAREN
            { action.case_selector(null); }
	|	T_DEFAULT
            { action.case_selector($T_DEFAULT); }
	;

// R814
case_value_range
	:	T_COLON case_value
           {
              action.case_value_range(/*hasColon*/true);
           }
	|   case_value case_value_range_suffix
           {
              action.case_value_range(/*hasColon*/false);
           }
	;

case_value_range_suffix
	:   T_COLON            { action.case_value_range_suffix(/*hasSuffixExpr*/false); }
	|   T_COLON case_value { action.case_value_range_suffix(/*hasSuffixExpr*/true);  }
	|                      { /* empty */ }
	;

case_value_range_list
@init{ int count=0;}
    :  		{action.case_value_range_list__begin();}
		case_value_range {count++;} ( T_COMMA case_value_range {count++;} )*
      		{action.case_value_range_list(count);}
    ;

// R815
// ERR_CHK 815 expr either scalar_int_initialization_expr 
// scalar_char_initialization_expr scalar_logical_initialization_expr
case_value
	:	expr
            { action.case_value(); }
	;

// R816
associate_construct
	:	associate_stmt
		block
		end_associate_stmt
            { action.associate_construct(); }
	;

// R817
associate_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
    :   (label {lbl=$label.tk;})? ( T_IDENT T_COLON {id=$T_IDENT;})? 
            T_ASSOCIATE T_LPAREN association_list T_RPAREN end_of_stmt
			{action.associate_stmt(lbl, id, $T_ASSOCIATE, $end_of_stmt.tk);}
    ;

association_list
@init{ int count=0;}
    :  		{action.association_list__begin();}
		association {count++;} ( T_COMMA association {count++;} )*
      		{action.association_list(count);}
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
// ERR_CHK 818 scalar_int_expr replaced by expr
// ERR_CHK 818 scalar_logical_expr replaced by expr
loop_control
@init {boolean hasOptExpr = false;}
   :   ( T_COMMA )? do_variable T_EQUALS expr T_COMMA expr
       ( T_COMMA expr {hasOptExpr=true;})?
           {action.loop_control(null, IActionEnums.DoConstruct_variable, hasOptExpr);}
   |   ( T_COMMA )? T_WHILE T_LPAREN expr T_RPAREN 
           {action.loop_control($T_WHILE, IActionEnums.DoConstruct_while, hasOptExpr);}
   |   ( T_COMMA )? T_CONCURRENT forall_header
           {action.loop_control($T_CONCURRENT,
                                IActionEnums.DoConstruct_concurrent, hasOptExpr);}
   ;

// R818
// T_IDENT inlined for associate_name
association
	:	T_IDENT T_EQ_GT selector
            { action.association($T_IDENT); }
	;

// R819
// expr can be designator (via primary) so variable deleted
selector
	:	expr
            { action.selector(); }
	;

// R820
end_associate_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	:   (label {lbl=$label.tk;})? T_END T_ASSOCIATE 
            (T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_associate_stmt(lbl, $T_END, $T_ASSOCIATE, id, 
                $end_of_stmt.tk);}
	|   (label {lbl=$label.tk;})? T_ENDASSOCIATE  
            (T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_associate_stmt(lbl, $T_ENDASSOCIATE, null, id, 
                                       $end_of_stmt.tk);}
	;

// R821
select_type_construct
    :   select_type_stmt ( type_guard_stmt block )* end_select_type_stmt
            { action.select_type_construct(); }
    ;

// R822
// T_IDENT inlined for select_construct_name and associate_name
select_type_stmt
@init {Token lbl = null; Token selectConstructName=null; 
	   Token associateName=null;}
@after{checkForInclude();}
    : (label {lbl=$label.tk;})?
		( idTmp=T_IDENT T_COLON {selectConstructName=idTmp;})? select_type
        T_LPAREN ( idTmpx=T_IDENT T_EQ_GT {associateName=idTmpx;} )?
		selector T_RPAREN end_of_stmt
			{action.select_type_stmt(lbl, selectConstructName, associateName, 
                                     $end_of_stmt.tk);}
    ;

select_type
    : T_SELECT T_TYPE { action.select_type($T_SELECT, $T_TYPE); }
    | T_SELECTTYPE { action.select_type($T_SELECTTYPE, null); }
    ;

// R823
// T_IDENT inlined for select_construct_name
// TODO - FIXME - have to remove T_TYPE_IS and T_CLASS_IS because the 
// lexer never matches the sequences.  lexer now matches a T_IDENT for 
// the 'IS'.  this rule should be fixed (see test_select_stmts.f03)
// TODO - The temporary token seems convoluted, but I couldn't figure out 
// how to prevent ambiguous use of T_IDENT otherwise. -BMR
type_guard_stmt
@init {Token lbl = null; Token selectConstructName=null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_TYPE id1=T_IDENT 
            T_LPAREN type_spec T_RPAREN
		    ( idTmp=T_IDENT {selectConstructName=idTmp;})? end_of_stmt
			{action.type_guard_stmt(lbl, $T_TYPE, id1, selectConstructName, 
                                    $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? T_CLASS id1=T_IDENT 
            T_LPAREN type_spec T_RPAREN
		    ( idTmp=T_IDENT {selectConstructName=idTmp;})? end_of_stmt
			{action.type_guard_stmt(lbl, $T_CLASS, id1, selectConstructName, 
                                    $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? T_CLASS	T_DEFAULT
		( idTmp=T_IDENT {selectConstructName=idTmp;})? end_of_stmt
			{action.type_guard_stmt(lbl, $T_CLASS, $T_DEFAULT, 
                                    selectConstructName, $end_of_stmt.tk);}
	;

// R824
// T_IDENT inlined for select_construct_name
end_select_type_stmt
@init {Token lbl = null; Token id = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_END T_SELECT 
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_select_type_stmt(lbl, $T_END, $T_SELECT, id, 
                $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? T_ENDSELECT    
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_select_type_stmt(lbl, $T_ENDSELECT, null, id, 
                $end_of_stmt.tk);}
	;

// R825
// deleted second alternative, nonblock_do_construct, to reduce backtracking, see comments for R835 on how
// termination of nested loops must be handled.
do_construct
	:	block_do_construct
            { action.do_construct(); }
	;

// R826
// do_block replaced by block
block_do_construct
	:	do_stmt
		block
		end_do
            { action.block_do_construct(); }
	;

// R827
// label_do_stmt and nonlabel_do_stmt inlined
do_stmt
@init {Token lbl=null; 
       Token id=null;
       Token digitString=null;
       boolean hasLoopControl=false;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? ( T_IDENT T_COLON {id=$T_IDENT;})? T_DO 
			( T_DIGIT_STRING {digitString=$T_DIGIT_STRING;})? 
			( loop_control {hasLoopControl=true;})? end_of_stmt
				{action.do_stmt(lbl, id, $T_DO, digitString, $end_of_stmt.tk, 
                                hasLoopControl);}
	;

// R828
// T_IDENT inlined for do_construct_name
// T_DIGIT_STRING inlined for label
label_do_stmt
@init {Token lbl = null; Token id=null; boolean hasLoopControl=false;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? ( T_IDENT T_COLON {id=$T_IDENT;} )? 
			T_DO T_DIGIT_STRING ( loop_control {hasLoopControl=true;})? 
            end_of_stmt
			{action.label_do_stmt(lbl, id, $T_DO, $T_DIGIT_STRING, 
                                  $end_of_stmt.tk, hasLoopControl);}
	;

// R829 inlined in R827
// T_IDENT inlined for do_construct_name

// R831
// do_variable is scalar-int-variable-name
do_variable
	:	T_IDENT
            { action.do_variable($T_IDENT); }
	;

// R832 do_block was block inlined in R826

// R833
// TODO continue-stmt is ambiguous with same in action statement, check 
// there for label and if
// label matches do-stmt label, then match end-do
// do_term_action_stmt added to allow block_do_construct to cover 
// nonblock_do_construct as well
end_do
@after {
    action.end_do();
}
	:	end_do_stmt
	|	do_term_action_stmt
	;

// R834
// T_IDENT inlined for do_construct_name
end_do_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_DO ( T_IDENT {id=$T_IDENT;})? 
            end_of_stmt
			{action.end_do_stmt(lbl, $T_END, $T_DO, id, $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDDO    ( T_IDENT {id=$T_IDENT;})? 
            end_of_stmt
			{action.end_do_stmt(lbl, $T_ENDDO, null, id, $end_of_stmt.tk);}
	;

// R835 nonblock_do_construct deleted as it was combined with 
// block_do_construct to reduce backtracking
// Second alternative, outer_shared_do_construct (nested loops sharing a 
// termination label) is ambiguous
// with do_construct in do_body, so deleted.  Loop termination is coordinated with
// the scanner to unwind nested loops sharing a common termination statement 
// (see do_term_action_stmt).

// R836 action_term_do_construct deleted because nonblock_do_construct 
// combined with block_do_construct to reduce backtracking

// R837 do_body deleted because nonblock_do_construct combined with 
// block_do_construct to reduce backtracking

// R838
// C826 (R842) A do-term-shared-stmt shall not be a goto-stmt, a return-stmt, 
// a stop-stmt, an exit-stmt, a cyle-stmt, an end-function-stmt, an 
// end-subroutine-stmt, an end-program-stmt, or an arithmetic-if-stmt.
do_term_action_stmt
@init {Token endToken = null; Token doToken = null; Token id=null;}
@after{checkForInclude();}
    // for a labeled statement which closes a DO, we insert a T_LABEL_DO_TERMINAL during the Sale's prepass.
    :   label T_LABEL_DO_TERMINAL 
        (action_stmt
         | ( (T_END T_DO {endToken=$T_END; doToken=$T_DO;} | T_ENDDO {endToken=$T_ENDDO; doToken=null;}) 
                (T_IDENT {id=$T_IDENT;})?)
                end_of_stmt
        )
            {action.do_term_action_stmt($label.tk, endToken, doToken, id, $end_of_stmt.tk, false);}
                                        
    // for an outer shared DO closed implicitly, we insert a T_LABEL_DO_TERMINAL_INSERTED during the Sale's prepass.
    // the inserted token's text is the closing statement's label.
    | T_LABEL_DO_TERMINAL_INSERTED
            {action.do_term_action_stmt($T_LABEL_DO_TERMINAL_INSERTED, null, null, null, null, true);}
	;

// R839 outer_shared_do_construct removed because it caused ambiguity in 
// R835 (see comment in R835)

// R840 shared_term_do_construct deleted (see comments for R839 and R835)

// R841 inner_shared_do_construct deleted (see comments for R839 and R835)

// R842 do_term_shared_stmt deleted (see comments for R839 and R835)

// R843
// T_IDENT inlined for do_construct_name
cycle_stmt
@init {Token lbl = null; Token id = null;} 
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_CYCLE (T_IDENT {id=$T_IDENT;})? end_of_stmt
			{ action.cycle_stmt(lbl, $T_CYCLE, id, $end_of_stmt.tk); }
	;

// R844
// T_IDENT inlined for do_construct_name
exit_stmt
@init {Token lbl = null; Token id = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_EXIT (T_IDENT {id=$T_IDENT;})? end_of_stmt
			{ action.exit_stmt(lbl, $T_EXIT, id, $end_of_stmt.tk); }
	;

// R845
goto_stmt
@init {Token lbl=null;
       Token goto_target=null;
       Token goKeyword=null;
       Token toKeyword=null;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       (   T_GO T_TO { goKeyword=$T_GO; toKeyword=$T_TO;} 
        |  T_GOTO    { goKeyword=$T_GOTO; toKeyword=null;}
       )
       T_DIGIT_STRING {goto_target=$T_DIGIT_STRING;} end_of_stmt
          { action.goto_stmt(lbl, goKeyword, toKeyword, goto_target, $end_of_stmt.tk); }
   ;

// R846
// ERR_CHK 846 scalar_int_expr replaced by expr
computed_goto_stmt
@init {Token lbl = null; Token goKeyword=null; Token toKeyword=null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})?
		(T_GO T_TO {goKeyword=$T_GO; toKeyword=$T_TO;} 
         | T_GOTO {goKeyword=$T_GOTO; toKeyword=null;}) 
            T_LPAREN label_list T_RPAREN ( T_COMMA )? expr end_of_stmt
			{ action.computed_goto_stmt(lbl, goKeyword, toKeyword, 
                $end_of_stmt.tk); }
	;

// The ASSIGN statement is a deleted feature.
assign_stmt 
@after{checkForInclude();}
    :   (lbl1=label)? T_ASSIGN lbl2=label T_TO name end_of_stmt 
            { action.assign_stmt(lbl1, $T_ASSIGN, lbl2, $T_TO, $name.tk, 
                                 $end_of_stmt.tk); }
    ;

// The assigned GOTO statement is a deleted feature.
assigned_goto_stmt
@init {Token goKeyword=null; Token toKeyword=null;}
@after{checkForInclude();}
    :   (label)? ( T_GOTO {goKeyword=$T_GOTO; toKeyword=null;}
                   | T_GO T_TO {goKeyword=$T_GO; toKeyword=$T_TO;} ) 
            name (T_COMMA stmt_label_list)? end_of_stmt
            { action.assigned_goto_stmt($label.tk, goKeyword, toKeyword, 
                                        $name.tk, $end_of_stmt.tk); }
    ;

// Used with assigned_goto_stmt (deleted feature)
stmt_label_list
    :   T_LPAREN label ( T_COMMA label )* T_RPAREN 
            { action.stmt_label_list(); }
    ;

// The PAUSE statement is a deleted feature.
pause_stmt
@init {Token tmpToken=null;}
@after{checkForInclude();}
   :   (lbl1=label)? T_PAUSE (lbl2=label {tmpToken=lbl2;} 
                 | char_literal_constant {tmpToken=null;})? end_of_stmt 
            { action.pause_stmt(lbl1, $T_PAUSE, tmpToken, $end_of_stmt.tk); }
   ;

// R847
// ERR_CHK 847 scalar_numeric_expr replaced by expr
arithmetic_if_stmt
@after{checkForInclude();}
	:	(lbl=label)? T_ARITHMETIC_IF_STMT T_IF
		T_LPAREN expr T_RPAREN label1=label
		T_COMMA label2=label
		T_COMMA label3=label end_of_stmt
			{ action.arithmetic_if_stmt(lbl, $T_IF, label1, label2, label3, 
                                        $end_of_stmt.tk); }
	;

// R848 continue_stmt
continue_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
    :	(label {lbl=$label.tk;})? T_CONTINUE end_of_stmt
			{ action.continue_stmt(lbl, $T_CONTINUE, $end_of_stmt.tk); } 
    ;

// R849
stop_stmt
@init {Token lbl = null; boolean hasStopCode = false;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_STOP (stop_code {hasStopCode=true;})? 
            end_of_stmt
			{ action.stop_stmt(lbl, $T_STOP, $end_of_stmt.tk, hasStopCode); }
	;

// R850
// ERR_CHK 850 T_DIGIT_STRING must be 5 digits or less
stop_code
    : scalar_char_constant
        { action.stop_code(null); }
//     | Digit ( Digit ( Digit ( Digit ( Digit )? )? )? )?
    | T_DIGIT_STRING
    	{ action.stop_code($T_DIGIT_STRING); } 
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
// ERR_CHK 863 lock_variable replaced by variable
lock_stmt
@init {Token lbl = null; boolean hasLockStatList = false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_LOCK T_LPAREN variable
             (T_COMMA lock_stat_list {hasLockStatList=true;})? T_RPAREN
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
// ERR_CHK 865 lock_variable replaced by expr
unlock_stmt
@init {Token lbl = null; boolean hasSyncStatList = false;}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_UNLOCK T_LPAREN variable (T_COMMA sync_stat_list {hasSyncStatList=true;})?
                T_RPAREN end_of_stmt
           {action.unlock_stmt(lbl, $T_UNLOCK, $end_of_stmt.tk, hasSyncStatList);}
   ;

scalar_char_constant
    :    char_constant
                { action.scalar_char_constant(); }
    ;

/**
 * Section/Clause 9: Input/output statements
 */

// R901
// file_unit_number replaced by expr
// internal_file_variable isa expr so internal_file_variable deleted
io_unit
@after {
    action.io_unit();
}
	:	expr
	|	T_ASTERISK
	;

// R902
// ERR_CHK 902 scalar_int_expr replaced by expr
file_unit_number
@after {
    action.file_unit_number();
}
	:	expr
	;

// R903 internal_file_variable was char_variable inlined (and then deleted) 
// in R901

// R904
open_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_OPEN T_LPAREN connect_spec_list 
            T_RPAREN end_of_stmt
			{action.open_stmt(lbl, $T_OPEN, $end_of_stmt.tk);}
	;

// R905
// ERR_CHK 905 check expr type with identifier
connect_spec
    : expr
            { action.connect_spec(null); }
    | T_IDENT
        /* {'UNIT','ACCESS','ACTION','ASYNCHRONOUS','BLANK','DECIMAL', */
        /* 'DELIM','ENCODING'} are expr */
        /* {'ERR'} is T_DIGIT_STRING */
        /* {'FILE','FORM'} are expr */
        /* {'IOMSG','IOSTAT'} are variables */
        /* {'PAD','POSITION','RECL','ROUND','SIGN','STATUS'} are expr */
      T_EQUALS expr
            { action.connect_spec($T_IDENT); }
    ;

connect_spec_list
@init{ int count=0;}
    :  		{action.connect_spec_list__begin();}
		connect_spec {count++;} ( T_COMMA connect_spec {count++;} )*
      		{action.connect_spec_list(count);}
    ;

// inlined scalar_default_char_expr

// R906 inlined file_name_expr with expr was scalar_default_char_expr

// R907 iomsg_variable inlined as scalar_default_char_variable in 
// R905,R909,R913,R922,R926,R928

// R908
close_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_CLOSE T_LPAREN close_spec_list 
            T_RPAREN end_of_stmt
			{action.close_stmt(lbl, $T_CLOSE, $end_of_stmt.tk);}
	;

// R909
// file_unit_number, scalar_int_variable, iomsg_variable, label replaced 
// by expr
close_spec
	:	expr
            { action.close_spec(null); }
	|	T_IDENT /* {'UNIT','IOSTAT','IOMSG','ERR','STATUS'} */ T_EQUALS expr
            { action.close_spec($T_IDENT); }
	;

close_spec_list
@init{ int count=0;}
    :  		{action.close_spec_list__begin();}
		close_spec {count++;} ( T_COMMA close_spec {count++;} )*
      		{action.close_spec_list(count);}
    ;

// R910
read_stmt
options {k=3;}
@init {Token lbl = null; boolean hasInputItemList=false;}
@after{checkForInclude();}
    :    ((label)? T_READ T_LPAREN) => 
            (label {lbl=$label.tk;})? T_READ T_LPAREN io_control_spec_list 
            T_RPAREN ( input_item_list {hasInputItemList=true;})? end_of_stmt
			{action.read_stmt(lbl, $T_READ, $end_of_stmt.tk, 
                hasInputItemList);}
    |    ((label)? T_READ) => 
            (label {lbl=$label.tk;})? T_READ format 
            ( T_COMMA input_item_list {hasInputItemList=true;})? end_of_stmt
			{action.read_stmt(lbl, $T_READ, $end_of_stmt.tk, 
                hasInputItemList);}
    ;

// R911
write_stmt
@init {Token lbl = null; boolean hasOutputItemList=false;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_WRITE T_LPAREN io_control_spec_list 
            T_RPAREN ( output_item_list {hasOutputItemList=true;})? end_of_stmt
			{ action.write_stmt(lbl, $T_WRITE, $end_of_stmt.tk, 
                hasOutputItemList); }
	;

// R912
print_stmt
@init {Token lbl = null; boolean hasOutputItemList=false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_PRINT format 
            ( T_COMMA output_item_list {hasOutputItemList=true;})? end_of_stmt
			{ action.print_stmt(lbl, $T_PRINT, $end_of_stmt.tk, 
                hasOutputItemList); }
    ;

// R913
// ERR_CHK 913 check expr type with identifier
// io_unit and format are both (expr|'*') so combined
io_control_spec
        :	expr
                // hasExpression=true
        		{ action.io_control_spec(true, null, false); }	
        |	T_ASTERISK
                // hasAsterisk=true
        		{ action.io_control_spec(false, null, true); }	
        |	T_IDENT /* {'UNIT','FMT'} */ T_EQUALS T_ASTERISK
                // hasAsterisk=true
        		{ action.io_control_spec(false, $T_IDENT, true); }	
        |	T_IDENT
		    /* {'UNIT','FMT'} are expr 'NML' is T_IDENT} */
		    /* {'ADVANCE','ASYNCHRONOUS','BLANK','DECIMAL','DELIM'} are expr */
		    /* {'END','EOR','ERR'} are labels */
		    /* {'ID','IOMSG',IOSTAT','SIZE'} are variables */
		    /* {'PAD','POS','REC','ROUND','SIGN'} are expr */
		T_EQUALS expr
                // hasExpression=true
        		{ action.io_control_spec(true, $T_IDENT, false); }	
    ;


io_control_spec_list
@init{ int count=0;}
    :  		{action.io_control_spec_list__begin();}
		io_control_spec {count++;} ( T_COMMA io_control_spec {count++;} )*
      		{action.io_control_spec_list(count);}
    ;

// R914
// ERR_CHK 914 default_char_expr replaced by expr
// label replaced by T_DIGIT_STRING is expr so deleted
format
@after {
    action.format();
}
	:	expr
	|	T_ASTERISK
	;

// R915
input_item
@after {
    action.input_item();
}
	:	variable
	|	io_implied_do
	;

input_item_list
@init{ int count=0;}
    :  		{action.input_item_list__begin();}
		input_item {count++;} ( T_COMMA input_item {count++;} )*
      		{action.input_item_list(count);}
    ;

// R916
output_item
options {backtrack=true;}
@after {
    action.output_item();
}
	:	expr
	|	io_implied_do
	;


output_item_list
@init{ int count=0;}
    :  		{action.output_item_list__begin();}
		output_item {count++;} ( T_COMMA output_item {count++;} )*
      		{action.output_item_list(count);}
    ;

// R917
io_implied_do
	:	T_LPAREN io_implied_do_object io_implied_do_suffix T_RPAREN
            { action.io_implied_do(); }
	;

// R918
// expr in output_item can be variable in input_item so input_item deleted
io_implied_do_object
	:	output_item
            { action.io_implied_do_object(); }
	;

io_implied_do_suffix
options {backtrack=true;}
	:	T_COMMA io_implied_do_object io_implied_do_suffix
	|	T_COMMA io_implied_do_control
	;

// R919
// ERR_CHK 919 scalar_int_expr replaced by expr
io_implied_do_control
@init{boolean hasStride=false;}
    : do_variable T_EQUALS expr T_COMMA expr ( T_COMMA expr {hasStride=true;})?
            { action.io_implied_do_control(hasStride); }
    ;

// R920
// TODO: remove this?  it is never called.
dtv_type_spec
	:	T_TYPE
		T_LPAREN
		derived_type_spec
		T_RPAREN
            { action.dtv_type_spec($T_TYPE); }
	|	T_CLASS
		T_LPAREN
		derived_type_spec
		T_RPAREN
            { action.dtv_type_spec($T_CLASS); }
	;

// R921
wait_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_WAIT T_LPAREN wait_spec_list T_RPAREN 
            end_of_stmt
			{action.wait_stmt(lbl, $T_WAIT, $end_of_stmt.tk);}
	;

// R922
// file_unit_number, scalar_int_variable, iomsg_variable, label replaced 
// by expr
wait_spec
	:	expr
            { action.wait_spec(null); }
	|	T_IDENT /* {'UNIT','END','EOR','ERR','ID','IOMSG','IOSTAT'} */ 
            T_EQUALS expr
            { action.wait_spec($T_IDENT); }
	;


wait_spec_list
@init{ int count=0;}
    :  		{action.wait_spec_list__begin();}
		wait_spec {count++;} ( T_COMMA wait_spec {count++;} )*
      		{action.wait_spec_list(count);}
    ;

// R923
backspace_stmt
options {k=3;}
@init {Token lbl = null;}
@after{checkForInclude();}
	:	((label)? T_BACKSPACE T_LPAREN) => 
            (label {lbl=$label.tk;})? T_BACKSPACE T_LPAREN position_spec_list 
            T_RPAREN end_of_stmt
			{action.backspace_stmt(lbl, $T_BACKSPACE, $end_of_stmt.tk, true);}
	|	((label)? T_BACKSPACE) => 
            (label {lbl=$label.tk;})? T_BACKSPACE file_unit_number end_of_stmt
			{action.backspace_stmt(lbl, $T_BACKSPACE, $end_of_stmt.tk, false);}
	;

// R924
endfile_stmt
options {k=3;}
@init {Token lbl = null;}
@after{checkForInclude();}
	:	((label)? T_END T_FILE T_LPAREN) => 
            (label {lbl=$label.tk;})? T_END T_FILE T_LPAREN position_spec_list 
            T_RPAREN end_of_stmt
			{action.endfile_stmt(lbl, $T_END, $T_FILE, $end_of_stmt.tk, true);}
	|	((label)? T_ENDFILE T_LPAREN) => 
            (label {lbl=$label.tk;})? T_ENDFILE T_LPAREN position_spec_list 
            T_RPAREN end_of_stmt
			{action.endfile_stmt(lbl, $T_ENDFILE, null, $end_of_stmt.tk, 
                true);}
	|	((label)? T_END T_FILE) => 
            (label {lbl=$label.tk;})? T_END T_FILE file_unit_number end_of_stmt
			{action.endfile_stmt(lbl, $T_END, $T_FILE, $end_of_stmt.tk, 
                false);}
	|	((label)? T_ENDFILE) => 
            (label {lbl=$label.tk;})? T_ENDFILE file_unit_number end_of_stmt
			{action.endfile_stmt(lbl, $T_ENDFILE, null, $end_of_stmt.tk, 
                false);}
	;

// R925
rewind_stmt
options {k=3;}
@init {Token lbl = null;}
@after{checkForInclude();}
	:	((label)? T_REWIND T_LPAREN) => 
            (label {lbl=$label.tk;})? T_REWIND T_LPAREN position_spec_list 
            T_RPAREN end_of_stmt
			{action.rewind_stmt(lbl, $T_REWIND, $end_of_stmt.tk, true);}
	|	((label)? T_REWIND) => 
            (label {lbl=$label.tk;})? T_REWIND file_unit_number end_of_stmt
			{action.rewind_stmt(lbl, $T_REWIND, $end_of_stmt.tk, false);}
	;

// R926
// file_unit_number, scalar_int_variable, iomsg_variable, label replaced 
// by expr
position_spec
	:	expr
            { action.position_spec(null); }
	|	T_IDENT /* {'UNIT','IOSTAT','IOMSG','ERR'} */ T_EQUALS expr
            { action.position_spec($T_IDENT); }
    ;

position_spec_list
@init{ int count=0;}
    :  		{action.position_spec_list__begin();}
		position_spec {count++;} ( T_COMMA position_spec {count++;} )*
      		{action.position_spec_list(count);}
    ;

// R927
flush_stmt
options {k=3;}
@init {Token lbl = null;} 
@after{checkForInclude();}
	:	((label)? T_FLUSH T_LPAREN) => 
            (label {lbl=$label.tk;})? T_FLUSH T_LPAREN flush_spec_list 
            T_RPAREN end_of_stmt
			{action.flush_stmt(lbl, $T_FLUSH, $end_of_stmt.tk, true);}
	|	((label)? T_FLUSH) => 
            (label {lbl=$label.tk;})? T_FLUSH file_unit_number end_of_stmt
			{action.flush_stmt(lbl, $T_FLUSH, $end_of_stmt.tk, false);}
	;

// R928
// file_unit_number, scalar_int_variable, iomsg_variable, label replaced 
// by expr
flush_spec
	:	expr
            { action.flush_spec(null); }
	|	T_IDENT /* {'UNIT','IOSTAT','IOMSG','ERR'} */ T_EQUALS expr
            { action.flush_spec($T_IDENT); }
    ;

flush_spec_list
@init{ int count=0;}
    :  		{action.flush_spec_list__begin();}
		flush_spec {count++;} ( T_COMMA flush_spec {count++;} )*
      		{action.flush_spec_list(count);}
    ;

// R929
inquire_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_INQUIRE T_LPAREN inquire_spec_list 
            T_RPAREN end_of_stmt
            {action.inquire_stmt(lbl, $T_INQUIRE, null, $end_of_stmt.tk, 
                false);}
	|	(label {lbl=$label.tk;})? T_INQUIRE_STMT_2 
            T_INQUIRE T_LPAREN T_IDENT /* 'IOLENGTH' */ T_EQUALS 
            scalar_int_variable T_RPAREN output_item_list end_of_stmt
				{action.inquire_stmt(lbl, $T_INQUIRE, $T_IDENT, 
                    $end_of_stmt.tk, true);}
	;


// R930
// ERR_CHK 930 file_name_expr replaced by expr
// file_unit_number replaced by expr
// scalar_default_char_variable replaced by designator
inquire_spec
	:	expr
            { action.inquire_spec(null); }
	|	T_IDENT 
        /* {'UNIT','FILE'} '=' expr portion, '=' designator portion below 
           {'ACCESS','ACTION','ASYNCHRONOUS','BLANK','DECIMAL',DELIM','DIRECT'}
           {'ENCODING','ERR','EXIST','FORM','FORMATTED','ID','IOMSG','IOSTAT'}
           {'NAME','NAMED','NEXTREC','NUMBER',OPENED','PAD','PENDING','POS'} 
           {'POSITION','READ','READWRITE','RECL','ROUND','SEQUENTIAL','SIGN'} 
           {'SIZE','STREAM','UNFORMATTED','WRITE'}  */
		T_EQUALS expr
             { action.inquire_spec($T_IDENT); }
	;

inquire_spec_list
@init{ int count=0;}
    :  		{action.inquire_spec_list__begin();}
		inquire_spec {count++;} ( T_COMMA inquire_spec {count++;} )*
      		{action.inquire_spec_list(count);}
    ;

/**
 * Section/Clause 10: Input/output editing
 */

// R1001
// TODO: error checking: label is required.  accept as optional so we can
// report the error to the user.
format_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_FORMAT format_specification end_of_stmt
			{action.format_stmt(lbl, $T_FORMAT, $end_of_stmt.tk);}
	;

// R1002
format_specification
@init{ boolean hasFormatItemList=false; }
	:	T_LPAREN ( format_item_list {hasFormatItemList=true;})? T_RPAREN
			{action.format_specification(hasFormatItemList);}
	;

// R1003
// r replaced by int_literal_constant replaced by char_literal_constant 
// replaced by T_CHAR_CONSTANT
// char_string_edit_desc replaced by T_CHAR_CONSTANT
format_item
@init{ Token descOrDigit=null; boolean hasFormatItemList=false; }
    :   T_DATA_EDIT_DESC 
		    {action.format_item($T_DATA_EDIT_DESC,hasFormatItemList);}
    |   T_CONTROL_EDIT_DESC
		    {action.format_item($T_CONTROL_EDIT_DESC,hasFormatItemList);}
    |   T_CHAR_STRING_EDIT_DESC
		    {action.format_item($T_CHAR_STRING_EDIT_DESC,hasFormatItemList);}
    |   (T_DIGIT_STRING {descOrDigit=$T_DIGIT_STRING;} )? T_LPAREN 
            format_item_list T_RPAREN
		    {action.format_item(descOrDigit,hasFormatItemList);}
    ;

// the comma is not always required.  see J3/04-007, pg. 221, lines
// 17-22
// ERR_CHK
format_item_list
@init{ int count=1;}
    :  		{action.format_item_list__begin();}
		format_item ( (T_COMMA)? format_item {count++;} )*
      		{action.format_item_list(count);}
    ;


// the following rules, from here to the v_list, are the originals.  modifying 
// to try and simplify and make match up with the standard.
// original rules. 02.01.07
// // R1003
// // r replaced by int_literal_constant replaced by char_literal_constant replaced by T_CHAR_CONSTANT
// // char_string_edit_desc replaced by T_CHAR_CONSTANT
// format_item
// 	:	T_DIGIT_STRING data_edit_desc
// 	|	data_plus_control_edit_desc
// 	|	T_CHAR_CONSTANT
// 	|	(T_DIGIT_STRING)? T_LPAREN format_item_list T_RPAREN
// 	;

// format_item_list
//     :    format_item ( T_COMMA format_item )*
//     ;

// // R1004 r inlined in R1003 and R1011 as int_literal_constant (then as DIGIT_STRING)
// // C1004 (R1004) r shall not have a kind parameter associated with it

// // R1005
// // w,m,d,e replaced by int_literal_constant replaced by T_DIGIT_STRING
// // char_literal_constant replaced by T_CHAR_CONSTANT
// // ERR_CHK 1005 matching T_ID_OR_OTHER with alternatives will have to be done here
// data_edit_desc
//     : T_ID_OR_OTHER /* {'I','B','O','Z','F','E','EN','ES','G','L','A','D'} */ 
//       T_DIGIT_STRING ( T_PERIOD T_DIGIT_STRING )?
//       ( T_ID_OR_OTHER /* is 'E' */ T_DIGIT_STRING )?
//     | T_ID_OR_OTHER /* is 'DT' */ T_CHAR_CONSTANT ( T_LPAREN v_list T_RPAREN )?
//     | T_ID_OR_OTHER /* {'A','DT'},{'X','P' from control_edit_desc} */
//     ;

// data_plus_control_edit_desc
// 	:	T_ID_OR_OTHER /* {'I','B','O','Z','F','E','EN','ES','G','L','A','D'},{T','TL','TR'} */ 
// 		    T_DIGIT_STRING ( T_PERIOD T_DIGIT_STRING )?
// 		    ( T_ID_OR_OTHER /* is 'E' */ T_DIGIT_STRING )?
// 	|	T_ID_OR_OTHER /* is 'DT' */ T_CHAR_CONSTANT ( T_LPAREN v_list T_RPAREN )?
// 	|	T_ID_OR_OTHER /* {'A','DT'},{'BN','BZ','RU','RD','RZ','RN','RC','RP','DC','DP'} */
// // following only from control_edit_desc
// 	|	( T_DIGIT_STRING )? T_SLASH
// 	|	T_COLON
// 	|	(T_PLUS|T_MINUS) T_DIGIT_STRING T_ID_OR_OTHER /* is 'P' */
// 	;

// R1006 w inlined in R1005 as int_literal_constant replaced by T_DIGIT_STRING

// R1007 m inlined in R1005 as int_literal_constant replaced by T_DIGIT_STRING

// R1008 d inlined in R1005 as int_literal_constant replaced by T_DIGIT_STRING

// R1009 e inlined in R1005 as int_literal_constant replaced by T_DIGIT_STRING

// R1010 v inlined as signed_int_literal_constant in v_list replaced by (T_PLUS or T_MINUS) T_DIGIT_STRING

v_list
@init{int count=0;}
    :  		{action.v_list__begin();}
		(pm=T_PLUS|T_MINUS)? ds=T_DIGIT_STRING
			{
				count++;
				action.v_list_part(pm, ds);
			}
		( T_COMMA (pm=T_PLUS|T_MINUS)? ds=T_DIGIT_STRING
			{
				count++;
				action.v_list_part(pm, ds);
			}
		)*
      		{action.v_list(count);}
    ;

// R1011 control_edit_desc inlined/combined in R1005 and data_plus_control_edit_desc
// r replaced by int_literal_constant replaced by T_DIGIT_STRING
// k replaced by signed_int_literal_constant replaced by (T_PLUS|T_MINUS)? T_DIGIT_STRING
// position_edit_desc inlined
// sign_edit_desc replaced by T_ID_OR_OTHER was {'SS','SP','S'}
// blank_interp_edit_desc replaced by T_ID_OR_OTHER was {'BN','BZ'}
// round_edit_desc replaced by T_ID_OR_OTHER was {'RU','RD','RZ','RN','RC','RP'}
// decimal_edit_desc replaced by T_ID_OR_OTHER was {'DC','DP'}
// leading T_ID_OR_OTHER alternates combined with data_edit_desc in data_plus_control_edit_desc

// R1012 k inlined in R1011 as signed_int_literal_constant
// C1009 (R1012) k shall not have a kind parameter specified for it

// R1013 position_edit_desc inlined in R1011
// n in R1013 was replaced by int_literal_constant replaced by T_DIGIT_STRING

// R1014 n inlined in R1013 as int_literal_constant (is T_DIGIT_STRING, see C1010)
// C1010 (R1014) n shall not have a kind parameter specified for it

// R1015 sign_edit_desc inlined in R1011 as T_ID_OR_OTHER was {'SS','SP','S'}

// R1016 blank_interp_edit_desc inlined in R1011 as T_ID_OR_OTHER was {'BN','BZ'}

// R1017 round_edit_desc inlined in R1011 as T_ID_OR_OTHER was {'RU','RD','RZ','RN','RC','RP'}

// R1018 decimal_edit_desc inlined in R1011 as T_ID_OR_OTHER was {'DC','DP'}

// R1019 char_string_edit_desc was char_literal_constant inlined in R1003 as T_CHAR_CONSTANT


/**
 * Section/Clause 11: Program units
 */


// R1102
// T_IDENT inlined for program_name
program_stmt
@init {Token lbl = null;} // @init{INIT_TOKEN_NULL(lbl);}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_PROGRAM T_IDENT end_of_stmt
		{ action.program_stmt(lbl, $T_PROGRAM, $T_IDENT, $end_of_stmt.tk); }
	;

// R1103
// T_IDENT inlined for program_name
end_program_stmt
@init  {Token lbl = null; Token id = null;}
@after {checkForInclude();}
	:	(label {lbl=$label.tk;})? T_END T_PROGRAM (T_IDENT {id=$T_IDENT;})? 
            end_of_stmt
			{ action.end_program_stmt(lbl, $T_END, $T_PROGRAM, id, 
                                      $end_of_stmt.tk); }
	|	(label {lbl=$label.tk;})? T_ENDPROGRAM (T_IDENT {id=$T_IDENT;})? 
            end_of_stmt
			{ action.end_program_stmt(lbl, $T_ENDPROGRAM, null, id,
                                      $end_of_stmt.tk); }
	|	(label {lbl=$label.tk;})? T_END end_of_stmt
			{ action.end_program_stmt(lbl, $T_END, null, null, 
                                      $end_of_stmt.tk); }
	;

	
// R1104
// C1104 (R1104) A module specification-part shall not contain a 
// stmt-function-stmt, an entry-stmt or a format-stmt
// specification_part made non-optional to remove END ambiguity (as can 
// be empty)
module
@after {
    action.module();
}
	:	module_stmt
		specification_part
		( module_subprogram_part )?
		end_module_stmt
	;

// R1105
module_stmt
@init {
   action.module_stmt__begin();
}
@after {
   checkForInclude();
}
    :    lbl=label?
         T_MODULE      id=T_IDENT
       ( T_IDENT      mid=T_IDENT )?
         end_of_stmt
            {
               if (mid != null) {
                  System.out.println("module_stmt: meta_module is " + mid);
               }
               action.module_stmt(lbl, $T_MODULE, id, $end_of_stmt.tk);
            }
    ;

// R1106
end_module_stmt
@init {Token lbl = null; Token id = null;}
@after{checkForInclude();}
    :  (label {lbl=$label.tk;})? T_END T_MODULE (T_IDENT {id=$T_IDENT;})? 
            end_of_stmt
            {action.end_module_stmt(lbl, $T_END, $T_MODULE, id, 
                                    $end_of_stmt.tk);}
    |  (label {lbl=$label.tk;})? T_ENDMODULE (T_IDENT {id=$T_IDENT;})? 
            end_of_stmt
        {action.end_module_stmt(lbl, $T_ENDMODULE, null, id, 
                                $end_of_stmt.tk);}
    |  (label {lbl=$label.tk;})? T_END end_of_stmt
            {action.end_module_stmt(lbl, $T_END, null, id, $end_of_stmt.tk);}
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
// R1108-F08
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


// R1109
use_stmt
@init {
    Token lbl=null; 
    boolean hasModuleNature=false; 
    boolean hasRenameList=false;
}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_USE 
            ( (T_COMMA module_nature {hasModuleNature=true;})? 
            T_COLON_COLON )? T_IDENT ( T_COMMA 
            rename_list {hasRenameList=true;})? end_of_stmt
			{action.use_stmt(lbl, $T_USE, $T_IDENT, null, $end_of_stmt.tk, 
                             hasModuleNature, hasRenameList, false);}
    |    (label {lbl=$label.tk;})? T_USE 
            ( ( T_COMMA module_nature {hasModuleNature=true;})? 
            T_COLON_COLON )? T_IDENT T_COMMA T_ONLY T_COLON ( only_list )? 
            end_of_stmt
			{action.use_stmt(lbl, $T_USE, $T_IDENT, $T_ONLY, $end_of_stmt.tk, 
                             hasModuleNature,hasRenameList,true);}
    ;

// R1110
module_nature
	:	T_INTRINSIC
            { action.module_nature($T_INTRINSIC); }
	|	T_NON_INTRINSIC
            { action.module_nature($T_NON_INTRINSIC); }
	;

// R1111
// T_DEFINED_OP inlined for local_defined_operator and use_defined_operator
// T_IDENT inlined for local_name and use_name
rename
	:	id1=T_IDENT T_EQ_GT id2=T_IDENT
            { action.rename(id1, id2, null, null, null, null); }
	|	op1=T_OPERATOR T_LPAREN defOp1=T_DEFINED_OP T_RPAREN T_EQ_GT
		op2=T_OPERATOR T_LPAREN defOp2=T_DEFINED_OP T_RPAREN
            { action.rename(null, null, op1, defOp1, op2, defOp2); } 
	;

rename_list
@init{ int count=0;}
    :  		{action.rename_list__begin();}
		rename {count++;} ( T_COMMA rename {count++;} )*
      		{action.rename_list(count);}
    ;

// R1112
// T_IDENT inlined for only_use_name
// generic_spec can be T_IDENT so T_IDENT deleted
only
@init{ boolean hasGenericSpec=false;
       boolean hasRename=false;
       boolean hasOnlyUseName=false;}
@after {
    action.only(hasGenericSpec, hasRename, hasOnlyUseName);
}
	:	generic_spec {hasGenericSpec=true;}
	|	rename       {hasRename=true;}
	;

only_list
@init{ int count=0;}
    :  		{action.only_list__begin();}
		only {count++;} ( T_COMMA only {count++;} )*
      		{action.only_list(count);}
    ;

// R1113 only_use_name was use_name inlined as T_IDENT

// R1114 inlined local_defined_operator in R1111 as T_DEFINED_OP

// R1115 inlined use_defined_operator in R1111 as T_DEFINED_OP

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

// R1116
// specification_part made non-optional to remove END ambiguity (as can 
// be empty).
block_data
@after {
    action.block_data();
}
	:	block_data_stmt
		specification_part
		end_block_data_stmt
	;

// R1117
block_data_stmt
@init
	{
		Token lbl = null; Token id = null;
		action.block_data_stmt__begin();
	}
@after{checkForInclude();}
   :   (label {lbl=$label.tk;})?
       T_BLOCK T_DATA (T_IDENT {id=$T_IDENT;})? end_of_stmt
           {action.block_data_stmt(lbl, $T_BLOCK, $T_DATA, id, $end_of_stmt.tk);}
   |   (label {lbl=$label.tk;})?
       T_BLOCKDATA  (T_IDENT {id=$T_IDENT;})? end_of_stmt
           {action.block_data_stmt(lbl, $T_BLOCKDATA, null, id, $end_of_stmt.tk);}
   ;

// R1118
end_block_data_stmt
@init {Token lbl = null; Token id = null;}
@after{checkForInclude();}
	:   (label {lbl=$label.tk;})? T_END T_BLOCK T_DATA 
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_block_data_stmt(lbl, $T_END, $T_BLOCK, $T_DATA, id, 
                                        $end_of_stmt.tk);}
	|   (label {lbl=$label.tk;})? T_ENDBLOCK T_DATA    
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_block_data_stmt(lbl, $T_ENDBLOCK, null, $T_DATA, id, 
                                        $end_of_stmt.tk);}
	|   (label {lbl=$label.tk;})? T_END T_BLOCKDATA    
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_block_data_stmt(lbl, $T_END, $T_BLOCKDATA, null, id, 
                                        $end_of_stmt.tk);}
	|   (label {lbl=$label.tk;})? T_ENDBLOCKDATA       
            ( T_IDENT {id=$T_IDENT;})? end_of_stmt
			{action.end_block_data_stmt(lbl, $T_ENDBLOCKDATA, null, null, id, 
                                        $end_of_stmt.tk);}
	|	(label {lbl=$label.tk;})? T_END end_of_stmt
			{action.end_block_data_stmt(lbl, $T_END, null, null, id, 
                                        $end_of_stmt.tk);}
	;

/**
 * Section/Clause 12: Procedures
 */

// R1201
interface_block
@after {
    action.interface_block();
}
	:	interface_stmt
		( interface_specification )*
		end_interface_stmt
	;

// R1202
interface_specification
@after {
    action.interface_specification();
}
	:	interface_body
	|	procedure_stmt
	;

// R1203 Note that the last argument to the action specifies whether this
// is an abstract interface or not.
interface_stmt
@init {Token lbl = null; boolean hasGenericSpec=false;}
@after{checkForInclude();}
	:		{action.interface_stmt__begin();}
		(label {lbl=$label.tk;})? T_INTERFACE ( generic_spec 
            {hasGenericSpec=true;})? end_of_stmt
			{action.interface_stmt(lbl, null, $T_INTERFACE, $end_of_stmt.tk, 
                                   hasGenericSpec);}
	|	(label {lbl=$label.tk;})? T_ABSTRACT T_INTERFACE end_of_stmt
			{action.interface_stmt(lbl, $T_ABSTRACT, $T_INTERFACE, 
                                   $end_of_stmt.tk, hasGenericSpec);}
	;

// R1204
end_interface_stmt
@init {Token lbl = null; boolean hasGenericSpec=false;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_INTERFACE ( generic_spec 
            {hasGenericSpec=true;})? end_of_stmt
		    {action.end_interface_stmt(lbl, $T_END, $T_INTERFACE, 
                $end_of_stmt.tk, hasGenericSpec);}
	| (label {lbl=$label.tk;})? T_ENDINTERFACE    ( generic_spec 
            {hasGenericSpec=true;})? end_of_stmt
		    {action.end_interface_stmt(lbl, $T_ENDINTERFACE, null, 
                $end_of_stmt.tk, hasGenericSpec);}
	;

// R1205
// specification_part made non-optional to remove END ambiguity (as can 
// be empty)
interface_body
	:	(prefix)? function_stmt specification_part end_function_stmt
            { action.interface_body(true); /* true for hasPrefix */ }
	|	subroutine_stmt specification_part end_subroutine_stmt
            { action.interface_body(false); /* false for hasPrefix */ }
	;

// R1206
// generic_name_list substituted for procedure_name_list
procedure_stmt
@init {Token lbl = null; Token module=null;} 
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? ( T_MODULE {module=$T_MODULE;})? 
            T_PROCEDURE generic_name_list end_of_stmt
			{action.procedure_stmt(lbl, module, $T_PROCEDURE, 
                $end_of_stmt.tk);}
	;

// R1207
// T_IDENT inlined for generic_name
generic_spec
	:	T_IDENT
			{action.generic_spec(null, $T_IDENT, 
                                 IActionEnums.GenericSpec_generic_name);}
	|	T_OPERATOR T_LPAREN defined_operator T_RPAREN
			{action.generic_spec($T_OPERATOR, null, 
                                 IActionEnums.GenericSpec_OPERATOR);}
	|	T_ASSIGNMENT T_LPAREN T_EQUALS T_RPAREN
			{action.generic_spec($T_ASSIGNMENT, null, 
                                 IActionEnums.GenericSpec_ASSIGNMENT);}
	|	defined_io_generic_spec
            { action.generic_spec(null, null, 
                IActionEnums.GenericSpec_dtio_generic_spec); }
	;

// R1208
// TODO - the name has been changed from dtio_generic_spec to defined_io_generic_spec
// change the actions and enums as well
defined_io_generic_spec
	:	T_READ T_LPAREN T_FORMATTED T_RPAREN
		{action.dtio_generic_spec($T_READ, $T_FORMATTED, 
                                  IActionEnums.
                                  DTIOGenericSpec_READ_FORMATTED);}
	|	T_READ T_LPAREN T_UNFORMATTED T_RPAREN
		{action.dtio_generic_spec($T_READ, $T_UNFORMATTED, 
                                  IActionEnums.
                                  DTIOGenericSpec_READ_UNFORMATTED);}
	|	T_WRITE T_LPAREN T_FORMATTED T_RPAREN
		{action.dtio_generic_spec($T_WRITE, $T_FORMATTED, 
                                  IActionEnums.
                                  DTIOGenericSpec_WRITE_FORMATTED);}
	|	T_WRITE T_LPAREN T_UNFORMATTED T_RPAREN
		{action.dtio_generic_spec($T_WRITE, $T_UNFORMATTED, 
                                  IActionEnums.
                                  DTIOGenericSpec_WRITE_UNFORMATTED);}
	;

// R1209
// generic_name_list substituted for import_name_list
import_stmt
@init {Token lbl = null; boolean hasGenericNameList=false;}
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_IMPORT ( ( T_COLON_COLON )? 
            generic_name_list {hasGenericNameList=true;})? end_of_stmt
			{action.import_stmt(lbl, $T_IMPORT, $end_of_stmt.tk, 
                hasGenericNameList);}
    ;

// R1210
// generic_name_list substituted for external_name_list
external_stmt
@init {Token lbl = null;} // @init{INIT_TOKEN_NULL(lbl);}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_EXTERNAL ( T_COLON_COLON )? 
            generic_name_list end_of_stmt
			{action.external_stmt(lbl, $T_EXTERNAL, $end_of_stmt.tk);}
	;

// R1211
procedure_declaration_stmt
@init {Token lbl = null; boolean hasProcInterface=false; int count=0;}
@after{checkForInclude();}
    : (label {lbl=$label.tk;})? T_PROCEDURE T_LPAREN
		( proc_interface {hasProcInterface=true;})? T_RPAREN
       	( ( T_COMMA proc_attr_spec {count++;})* T_COLON_COLON )?
		proc_decl_list end_of_stmt
			{action.procedure_declaration_stmt(lbl, $T_PROCEDURE, 
                $end_of_stmt.tk, hasProcInterface, count);}
    ;

// R1212
// T_IDENT inlined for interface_name
proc_interface
	:	T_IDENT					{ action.proc_interface($T_IDENT); }
	|	declaration_type_spec	{ action.proc_interface(null); }
	;

// R1213
proc_attr_spec
	:	access_spec
            { action.proc_attr_spec(null, null, IActionEnums.AttrSpec_none); }
	|	proc_language_binding_spec
            { action.proc_attr_spec(null, null, IActionEnums.AttrSpec_none); }
	|	T_INTENT T_LPAREN intent_spec T_RPAREN
            { action.proc_attr_spec($T_INTENT, null, 
                IActionEnums.AttrSpec_INTENT); }
	|	T_OPTIONAL	
            { action.proc_attr_spec($T_OPTIONAL, null, 
                IActionEnums.AttrSpec_OPTIONAL); }
	|	T_POINTER	
            { action.proc_attr_spec($T_POINTER, null, 
                IActionEnums.AttrSpec_POINTER); }
	|	T_SAVE		
            { action.proc_attr_spec($T_SAVE, null, 
                IActionEnums.AttrSpec_SAVE); }
// TODO: are T_PASS, T_NOPASS, and T_DEFERRED correct?
// From R453 binding-attr
	|   T_PASS ( T_LPAREN T_IDENT T_RPAREN)?
            { action.proc_attr_spec($T_PASS, $T_IDENT, 
                IActionEnums.AttrSpec_PASS); }
    |   T_NOPASS
            { action.proc_attr_spec($T_NOPASS, null, 
                IActionEnums.AttrSpec_NOPASS); }
    |   T_DEFERRED
            { action.proc_attr_spec($T_DEFERRED, null, 
                IActionEnums.AttrSpec_DEFERRED); }
    |   proc_attr_spec_extension
	;
  
// language extension point
proc_attr_spec_extension : T_NO_LANGUAGE_EXTENSION ;

// R1214
// T_IDENT inlined for procedure_entity_name
proc_decl
@init{boolean hasNullInit = false;}
    :	T_IDENT ( T_EQ_GT null_init {hasNullInit=true;} )?
    		{ action.proc_decl($T_IDENT, hasNullInit); }
    ;

proc_decl_list
@init{ int count=0;}
    :  		{action.proc_decl_list__begin();}
		proc_decl {count++;} ( T_COMMA proc_decl {count++;} )*
      		{action.proc_decl_list(count);}
    ;

// R1215 interface_name was name inlined as T_IDENT

// R1216
// generic_name_list substituted for intrinsic_procedure_name_list
intrinsic_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_INTRINSIC
		( T_COLON_COLON )?
		generic_name_list end_of_stmt
			{action.intrinsic_stmt(lbl, $T_INTRINSIC, $end_of_stmt.tk);}
	;

// R1217 function_reference replaced by designator_or_func_ref to reduce 
// backtracking

// R1218
// C1222 (R1218) The procedure-designator shall designate a subroutine.
call_stmt
@init {Token lbl = null; boolean hasActualArgSpecList = false;} 
@after{checkForInclude();}
    :    (label {lbl=$label.tk;})? T_CALL procedure_designator
            ( T_LPAREN (actual_arg_spec_list {hasActualArgSpecList=true;})? 
            T_RPAREN )? end_of_stmt
         	{ action.call_stmt(lbl, $T_CALL, $end_of_stmt.tk, 
                hasActualArgSpecList); }
    ;

// R1219
// ERR_CHK 1219 must be (T_IDENT | designator T_PERCENT T_IDENT)
// T_IDENT inlined for procedure_name and binding_name
// proc_component_ref is variable T_PERCENT T_IDENT (variable is designator)
// data_ref subset of designator so data_ref T_PERCENT T_IDENT deleted
// designator (R603), minus the substring part is data_ref, so designator 
// replaced by data_ref
//R1219 procedure-designator            is procedure-name
//                                      or proc-component-ref
//                                      or data-ref % binding-name
procedure_designator
	:	data_ref
            { action.procedure_designator(); }
	;

// R1220
actual_arg_spec
@init{Token keyword = null;}
    :	(T_IDENT T_EQUALS {keyword=$T_IDENT;})? actual_arg
    		{ action.actual_arg_spec(keyword); }
    ;

// TODO - delete greedy?
actual_arg_spec_list
options{greedy=false;}
@init{int count = 0;}
    :		{ action.actual_arg_spec_list__begin(); }
    	actual_arg_spec {count++;} ( T_COMMA actual_arg_spec {count++;} )*
    		{ action.actual_arg_spec_list(count); }
    ;

// R1221
// ERR_CHK 1221 ensure ( expr | designator ending in T_PERCENT T_IDENT)
// T_IDENT inlined for procedure_name
// expr isa designator (via primary) so variable deleted
// designator isa T_IDENT so T_IDENT deleted
// proc_component_ref is variable T_PERCENT T_IDENT can be designator so 
// deleted
actual_arg
@init{boolean hasExpr = false;}
	:	expr				
            { hasExpr=true; action.actual_arg(hasExpr, null); }
	|	T_ASTERISK label	
            { action.actual_arg(hasExpr, $label.tk); }
	;

// R1222 alt_return_spec inlined as T_ASTERISK label in R1221

// R1223
// 1. left factored optional prefix in function_stmt from function_subprogram
// 2. specification_part made non-optional to remove END ambiguity (as can 
// be empty)
function_subprogram
@init {
    boolean hasExePart = false;
    boolean hasIntSubProg = false;
}
	:	function_stmt
		specification_part
		( execution_part { hasExePart=true; })?
		( internal_subprogram_part { hasIntSubProg=true; })?
		end_function_stmt
            { action.function_subprogram(hasExePart, hasIntSubProg); }
	;

// R1224
// left factored optional prefix from function_stmt
// generic_name_list substituted for dummy_arg_name_list
function_stmt
@init {
    Token lbl = null; 
	boolean hasGenericNameList=false;
	boolean hasSuffix=false;
}
@after{checkForInclude();}
    :  		{action.function_stmt__begin();} 
		(label {lbl=$label.tk;})? T_FUNCTION T_IDENT
		    T_LPAREN ( generic_name_list {hasGenericNameList=true;})? T_RPAREN 
            ( suffix {hasSuffix=true;})? end_of_stmt
			{action.function_stmt(lbl, $T_FUNCTION, $T_IDENT, $end_of_stmt.tk, 
                                  hasGenericNameList,hasSuffix);}
	;

// R1225
proc_language_binding_spec
	:	language_binding_spec
            { action.proc_language_binding_spec(); }
	;

// R1226 dummy_arg_name was name inlined as T_IDENT

// R1227
// C1240 (R1227) A prefix shall contain at most one of each prefix-spec
// C1241 (R1227) A prefix shall not specify both ELEMENTAL AND RECURSIVE
prefix
@init{int specCount=1;}
   :  prefix_spec ( prefix_spec {specCount++;} )*
          {action.prefix(specCount);}
   ;

t_prefix
@init{int specCount=1;}
   :  t_prefix_spec ( t_prefix_spec {specCount++;} )*
           {action.t_prefix(specCount);}
   ;

// R1226-F08
prefix_spec
   :  declaration_type_spec
          {action.prefix_spec(true);}
   |  t_prefix_spec
          {action.prefix_spec(false);}
   ;

t_prefix_spec
   :  T_ELEMENTAL  {action.t_prefix_spec($T_ELEMENTAL);}
   |  T_IMPURE     {action.t_prefix_spec($T_IMPURE);}
   |  T_MODULE     {action.t_prefix_spec($T_MODULE);}
   |  T_PURE       {action.t_prefix_spec($T_PURE);}
   |  T_RECURSIVE  {action.t_prefix_spec($T_RECURSIVE);}
// CUDA extensions
   |  T_HOST       {action.t_prefix_spec($T_HOST);}
   |  T_GLOBAL     {action.t_prefix_spec($T_GLOBAL);}
   |  T_DEVICE     {action.t_prefix_spec($T_DEVICE);}
   |  T_GRID_GLOBAL{action.t_prefix_spec($T_GRID_GLOBAL);}
   |  prefix_spec_extension
   ;

// language extension point
prefix_spec_extension : T_NO_LANGUAGE_EXTENSION ;

// R1229
suffix
@init {
    Token result = null;
    boolean hasProcLangBindSpec = false;
}
	:	proc_language_binding_spec ( T_RESULT T_LPAREN result_name 
            T_RPAREN { result=$T_RESULT; })?
            { action.suffix(result, true); }
	|	T_RESULT T_LPAREN result_name T_RPAREN 
            ( proc_language_binding_spec { hasProcLangBindSpec = true; })?
            { action.suffix($T_RESULT, hasProcLangBindSpec); }
    ;

result_name
    :    name
            { action.result_name(); }
    ;

// R1230
end_function_stmt
@init {Token lbl = null; Token id = null;}
@after{checkForInclude();}
	: (label {lbl=$label.tk;})? T_END T_FUNCTION ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_function_stmt(lbl, $T_END, $T_FUNCTION, id, 
                                  $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_ENDFUNCTION    ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_function_stmt(lbl, $T_ENDFUNCTION, null, id, 
                                  $end_of_stmt.tk);}
	| (label {lbl=$label.tk;})? T_END end_of_stmt
		{action.end_function_stmt(lbl, $T_END, null, id, $end_of_stmt.tk);}
	;

// R1231
// specification_part made non-optional to remove END ambiguity (as can 
// be empty)
subroutine_subprogram
@init {
    boolean hasExePart = false;
    boolean hasIntSubProg = false;
}
   :   subroutine_stmt
       specification_part
       ( execution_part { hasExePart=true; } )?
       ( internal_subprogram_part { hasIntSubProg=true; } )?
       end_subroutine_stmt
            { action.subroutine_subprogram(hasExePart, hasIntSubProg); }
   ;

// R1232
subroutine_stmt
@init {Token lbl = null; boolean hasPrefix=false;
	   boolean hasDummyArgList=false;
	   boolean hasBindingSpec=false;
	   boolean hasArgSpecifier=false;}
@after{checkForInclude();}
    :		{action.subroutine_stmt__begin();}
		(label {lbl=$label.tk;})? (t_prefix {hasPrefix=true;})? T_SUBROUTINE 
            T_IDENT ( T_LPAREN ( dummy_arg_list {hasDummyArgList=true;})? 
            T_RPAREN ( proc_language_binding_spec {hasBindingSpec=true;})? 
            {hasArgSpecifier=true;})? end_of_stmt
      		{action.subroutine_stmt(lbl, $T_SUBROUTINE, $T_IDENT, 
                                    $end_of_stmt.tk, 
                                    hasPrefix, hasDummyArgList, 
                                    hasBindingSpec, hasArgSpecifier);}
    ;

// R1233
// T_IDENT inlined for dummy_arg_name
dummy_arg
options{greedy=false; memoize=false;}
	:	T_IDENT		{ action.dummy_arg($T_IDENT); }
	|	T_ASTERISK	{ action.dummy_arg($T_ASTERISK); }
	;

dummy_arg_list
@init{ int count=0;}
    :  		{action.dummy_arg_list__begin();}
		dummy_arg {count++;} ( T_COMMA dummy_arg {count++;} )*
      		{action.dummy_arg_list(count);}
    ;

// R1234
end_subroutine_stmt
@init {Token lbl = null; Token id=null;}
@after{checkForInclude();}
    : (label {lbl=$label.tk;})? T_END T_SUBROUTINE ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_subroutine_stmt(lbl, $T_END, $T_SUBROUTINE, id, 
                                    $end_of_stmt.tk);}
    | (label {lbl=$label.tk;})? T_ENDSUBROUTINE    ( T_IDENT {id=$T_IDENT;})? 
        end_of_stmt
		{action.end_subroutine_stmt(lbl, $T_ENDSUBROUTINE, null, id, 
                                    $end_of_stmt.tk);}
    | (label {lbl=$label.tk;})? T_END end_of_stmt
		{action.end_subroutine_stmt(lbl, $T_END, null, id, $end_of_stmt.tk);}
    ;

// R1235
// T_INDENT inlined for entry_name
entry_stmt
@init {
    Token lbl = null; 
    boolean hasDummyArgList=false; 
    boolean hasSuffix=false;
}
@after{checkForInclude();}
    :   (label {lbl=$label.tk;})? T_ENTRY T_IDENT
            ( T_LPAREN ( dummy_arg_list {hasDummyArgList=true;} )? T_RPAREN 
            ( suffix {hasSuffix=true;})? )? end_of_stmt
            {action.entry_stmt(lbl, $T_ENTRY, $T_IDENT, $end_of_stmt.tk, 
                               hasDummyArgList, hasSuffix);}
    ;

// R1236
// ERR_CHK 1236 scalar_int_expr replaced by expr
return_stmt
@init {Token lbl = null; boolean hasScalarIntExpr=false;} 
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_RETURN ( expr {hasScalarIntExpr=true;})? 
            end_of_stmt
			{action.return_stmt(lbl, $T_RETURN, $end_of_stmt.tk, 
                hasScalarIntExpr);}	
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


// R1237
contains_stmt
@init {Token lbl = null;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_CONTAINS end_of_stmt
			{action.contains_stmt(lbl, $T_CONTAINS, $end_of_stmt.tk);}	
	;


// R1238
// ERR_CHK 1239 scalar_expr replaced by expr
// generic_name_list substituted for dummy_arg_name_list
// TODO Hopefully scanner and parser can help work together here to work 
// around ambiguity.
// why can't this be accepted as an assignment statement and then the parser
// look up the symbol for the T_IDENT to see if it is a function??
//      Need scanner to send special token if it sees what?
// TODO - won't do a(b==3,c) = 2
stmt_function_stmt
@init {Token lbl = null; boolean hasGenericNameList=false;}
@after{checkForInclude();}
	:	(label {lbl=$label.tk;})? T_STMT_FUNCTION T_IDENT T_LPAREN 
            ( generic_name_list {hasGenericNameList=true;})? T_RPAREN 
            T_EQUALS expr end_of_stmt
			{action.stmt_function_stmt(lbl, $T_IDENT, $end_of_stmt.tk, 
                                       hasGenericNameList);}
	;

// added this to have a way to match the T_EOS and EOF combinations
end_of_stmt returns [Token tk]
    : T_EOS			
        {
            FortranToken eos = (FortranToken)$T_EOS;
            tk = $T_EOS; 
            action.end_of_stmt($T_EOS);
        }
        // the (EOF) => EOF is done with lookahead because if it's not there, 
        // then antlr will crash with an internal error while trying to 
        // generate the java code.  (as of 12.11.06)
    | (EOF) => EOF	
        {
            tk = $EOF; action.end_of_stmt($EOF); 
            // don't call action.end_of_file() here or the action will be
            // called before end_of_program action called
            // action.end_of_file(eofToken.getText());
        }
    ;
