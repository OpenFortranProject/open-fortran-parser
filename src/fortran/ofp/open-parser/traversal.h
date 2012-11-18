#ifndef	OFP_TRAVERSAL_H
#define	OFP_TRAVERSAL_H

#include <aterm1.h>

ATbool ofp_traverse_main_program         (ATerm aterm);
ATbool ofp_traverse_program_stmt         (ATerm term);
ATbool ofp_traverse_end_program_stmt     (ATerm term);

#endif
