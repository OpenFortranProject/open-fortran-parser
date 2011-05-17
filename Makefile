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

include make.inc

JAVAC=$(OFP_JAVAC) 
JAVA=$(OFP_JAVA) $(OFP_JFLAGS)
JAR=$(OFP_JAR) 
CD=cd
CP=cp
JAVADIR=java

JARFILE=$(OFP_JARFILE)

all: 
	mkdir -pv build/fortran/ofp/parser/c/jni
	$(CD) $(OFP_FRONT_DIR); $(MAKE)
	$(CD) $(OFP_TOOLS_DIR); $(MAKE) ; $(MAKE) RuleStackTrace.java
	$(CD) $(OFP_FRONT_DIR); $(MAKE) jarfile
ifeq ($(OFP_ENABLE_JNI), "yes") 
	$(CD) $(OFP_PARSER_DIR) ; perl java2c.pl ; \
             $(CD) $(OFP_C_DIR) ; $(MAKE) ; \
             $(CD) $(OFP_JNI_DIR) ; \
             $(MAKE) ; $(MAKE) jarfile
endif

install:
	@echo "installing OpenFortranParser in $(OFP_INSTALL_DIR)"
	mkdir -p $(OFP_INSTALL_DIR)/lib
	$(OFP_INSTALL) -d $(OFP_INSTALL_DIR)/lib
	$(OFP_INSTALL) -m 644 $(OFP_BUILD_DIR)/$(OFP_JARFILE) \
            $(OFP_INSTALL_DIR)/lib
ifeq ($(OFP_ENABLE_C_ACTIONS), "yes")
	$(OFP_INSTALL) -m 755 $(OFP_BUILD_DIR)/$(OFP_C_ACTION_SO) \
            $(OFP_INSTALL_DIR)/lib
endif

check:
	$(CD) tests; $(MAKE) check

clean:
	$(CD) $(OFP_FRONT_DIR); $(MAKE) clean
	$(CD) $(OFP_TOOLS_DIR); $(MAKE) clean
	$(CD) $(OFP_C_DIR); $(MAKE) clean
	$(CD) $(OFP_JNI_DIR); $(MAKE) clean
	rm -f ./build/$(OFP_JARFILE)
	rm -rf ./build/fortran

distclean:
	$(CD) $(OFP_FRONT_DIR); $(MAKE) allclean
	$(CD) $(OFP_TOOLS_DIR); $(MAKE) allclean
	$(CD) $(OFP_C_DIR); $(MAKE) allclean
	rm -rf $(OFP_BUILD_DIR)/fortran
	$(CD) $(OFP_JNI_DIR); $(MAKE) allclean
	rm -f ./lib/$(OFP_C_ACTION_SO)

allclean: distclean
	rm -f ./lib/$(OFP_JARFILE)
