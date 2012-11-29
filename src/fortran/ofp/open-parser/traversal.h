#ifndef	OFP_TRAVERSAL_H
#define	OFP_TRAVERSAL_H

#include <aterm2.h>

ATbool ofp_traverse_specification_part            (ATerm term);       // R204-F08
ATbool ofp_traverse_declaration_construct         (ATerm term);       // R207-F08
ATbool ofp_traverse_declaration_construct_list    (ATerm term);
ATbool ofp_traverse_execution_part                (ATerm term);       // R208-F08
ATbool ofp_traverse_execution_part_construct      (ATerm term);       // R209-F08
ATbool ofp_traverse_executable_part_construct_list(ATerm term);
ATbool ofp_traverse_executable_construct          (ATerm term);       // R213-F08
ATbool ofp_traverse_action_stmt                   (ATerm term);       // R214-F08

ATbool ofp_traverse_declaration_type_spec        (ATerm term);        // R403-F08
ATbool ofp_traverse_intrinsic_type_spec          (ATerm term);        // R404-F08
ATbool ofp_traverse_int_literal_constant         (ATerm term);        // R407-F08

ATbool ofp_traverse_type_declaration_stmt        (ATerm term);        // R501-F08
ATbool ofp_traverse_entity_decl                  (ATerm term);        // R503-F08
ATbool ofp_traverse_entity_decl_list             (ATerm term);

ATbool ofp_traverse_designator                   (ATerm term);        // R601-F08
ATbool ofp_traverse_variable                     (ATerm term);        // R602-F08
ATbool ofp_traverse_data_ref                     (ATerm term);        // R611-F08
ATbool ofp_traverse_part_ref                     (ATerm term);        // R612-F08

ATbool ofp_traverse_expr                         (ATerm term);        // R722-F08
ATbool ofp_traverse_assignment_stmt              (ATerm term);        // R732-F08

ATbool ofp_traverse_main_program                 (ATerm term);        // R1101-F08
ATbool ofp_traverse_program_stmt                 (ATerm term);        // R1102-F08
ATbool ofp_traverse_end_program_stmt             (ATerm term);        // R1103-F08

#endif
