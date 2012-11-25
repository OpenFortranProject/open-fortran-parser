#ifndef	OFP_TRAVERSAL_H
#define	OFP_TRAVERSAL_H

#include <aterm2.h>

ATbool ofp_traverse_specification_part           (ATerm term);        // R204-F08
ATbool ofp_traverse_declaration_construct        (ATerm term);        // R207-F08
ATbool ofp_traverse_declaration_construct_list   (ATerm term);

ATbool ofp_traverse_declaration_type_spec        (ATerm term);        // R403-F08
ATbool ofp_traverse_intrinsic_type_spec          (ATerm term);        // R404-F08 

ATbool ofp_traverse_type_declaration_stmt        (ATerm term);        // R501-F08
ATbool ofp_traverse_entity_decl                  (ATerm term);        // R503-F08
ATbool ofp_traverse_entity_decl_list             (ATerm term);

ATbool ofp_traverse_main_program         (ATerm aterm);
ATbool ofp_traverse_program_stmt         (ATerm term);
ATbool ofp_traverse_end_program_stmt     (ATerm term);

#endif
