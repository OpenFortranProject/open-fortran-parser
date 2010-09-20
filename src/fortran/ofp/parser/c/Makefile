# Copyright (c) 2005, 2006 Los Alamos National Security, LLC.  This
# material was produced under U.S. Government contract DE-
# AC52-06NA25396 for Los Alamos National Laboratory (LANL), which is
# operated by the Los Alamos National Security, LLC (LANS) for the
# U.S. Department of Energy. The U.S. Government has rights to use,
# reproduce, and distribute this software. NEITHER THE GOVERNMENT NOR
# LANS MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY
# LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified to
# produce derivative works, such modified software should be clearly
# marked, so as not to confuse it with the version available from
# LANL.

# Additionally, this program and the accompanying materials are made
# available under the terms of the Eclipse Public License v1.0 which
# accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

include ../../../../../make.inc

JAVAC=$(OFP_JAVAC) #javac
JAVA=$(OFP_JAVA) #java
JAR=$(OFP_JAR) #jar

BUILDDIR=$(OFP_BUILD_DIR)
INSTALLDIR = $(BUILDDIR)/fortran/ofp/parser/c

GENERATED_C_HEADER=FortranParserAction.h
GENERATED_C_NULL=FortranParserActionNull.c
GENERATED_C_PRINT=FortranParserActionPrint.c
GENERATED_C_ENUMS=ActionEnums.h

all: $(GENERATED_C_HEADER) $(GENERATED_C_PRINT) $(GENERATED_C_NULL)
	cp ActionEnums.h $(INSTALLDIR)/.
	cp token.h $(INSTALLDIR)/.
	cp token.c $(INSTALLDIR)/.

FortranParserAction.h:
	$(JAVA) $(OFP_JFLAGS) fortran.tools.CFiles header
	cp FortranParserAction.h $(INSTALLDIR)/.
FortranParserActionPrint.c:
	$(JAVA) $(OFP_JFLAGS) fortran.tools.CFiles print
	cp FortranParserActionPrint.c $(INSTALLDIR)/.
FortranParserActionNull.c:
	$(JAVA) $(OFP_JFLAGS) fortran.tools.CFiles null
	cp FortranParserActionNull.c $(INSTALLDIR)/.

clean:
	rm -f $(GENERATED_C_PRINT)
	rm -f $(GENERATED_C_NULL)
	rm -f $(GENERATED_C_HEADER)
	rm -f $(GENERATED_C_ENUMS)

allclean:
	$(MAKE) clean

