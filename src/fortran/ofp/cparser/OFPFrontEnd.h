/**
 * Copyright (c) 2005, 2006 Los Alamos National Security, LLC.  This
 * material was produced under U.S. Government contract DE-
 * AC52-06NA25396 for Los Alamos National Laboratory (LANL), which is
 * operated by the Los Alamos National Security, LLC (LANS) for the
 * U.S. Department of Energy. The U.S. Government has rights to use,
 * reproduce, and distribute this software. NEITHER THE GOVERNMENT NOR
 * LANS MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY
 * LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified to
 * produce derivative works, such modified software should be clearly
 * marked, so as not to confuse it with the version available from
 * LANL.
 *  
 * Additionally, this program and the accompanying materials are made
 * available under the terms of the Eclipse Public License v1.0 which
 * accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

#ifndef OFP_FRONT_END_H
#define OFP_FRONT_END_H

#include <antlr3.h>
#include "OFP_Type.h"

/** Common shared return value
 */
typedef struct CFortranParser_shared_return_struct
{
    /** Generic return elements for ANTLR3 rules that are not in tree parsers or returning trees
     */
    pANTLR3_COMMON_TOKEN    start;
    pANTLR3_COMMON_TOKEN    stop;
    pANTLR3_BASE_TREE       tree;
   
}
    CFortranParser_shared_return;

typedef struct OFPFrontEnd_struct
{
   /** Generic return elements for ANTLR3 rules that are not in tree parsers or returning trees
    */
   pANTLR3_COMMON_TOKEN    start;
   pANTLR3_COMMON_TOKEN    stop;
   pANTLR3_BASE_TREE	      tree;
   pANTLR3_VECTOR          tlist;

   pANTLR3_STRING_FACTORY  strFactory;

   /** Members from java FrontEnd class
    */

   pANTLR3_STRING  src_file;
   pANTLR3_STRING  tok_file;

   /** Pointer to a function parses a program unit.
    */
   pANTLR3_BASE_TREE    (*program)      (struct OFPFrontEnd_struct * fe);

   /** Pointer to a function that knows how to free resources of the OFP parser.                            
    */
   void                 (*free)         (struct OFPFrontEnd_struct * fe);

}
   OFPFrontEnd, *pOFPFrontEnd;


pOFPFrontEnd ofpFrontEndNew          (int nArgs, char* argv[]);
int          ofpGetProgramUnitType   (pANTLR3_INT_STREAM istream);


#endif
