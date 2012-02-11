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

CFORTRANPARSER=../../src/fortran/ofp/cparser/unparse
JAVAC=javac
JAVA=java
JAR=jar
BUILDDIR=../../../build
PARDIR=../


check: runTestsNoCheck

runTestsNoCheck:
	@for file in *.f* ; do \
           echo "Running test $$file"; \
           $(JAVA) fortran.ofp.FrontEnd $$file; \
           if [ $$? != 0 ]; then echo "FAILED while running test $$file"; exit 1; fi \
        done;

runTestsVerbose:
	@for file in *.f* ; do \
           echo "Running test $$file"; \
           $(JAVA) fortran.ofp.FrontEnd --verbose $$file; \
           if [ $$? != 0 ]; then echo "FAILED while running test $$file"; exit 1; fi \
        done;

runTestsCFortranParser:
	@for file in junk.f* ; do \
           echo "Running CFortranParser test $$file"; \
           $(JAVA) fortran.ofp.FrontEnd $$file --tokenfile tempfile.tokens; \
           $(CFORTRANPARSER) tempfile.tokens $$file; \
           if [ $$? != 0 ]; then echo "FAILED while running test $$file"; exit 1; fi \
        done;

clean:
	rm -f tempfile.tokens
