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

OFP_HOME=..
include $(OFP_HOME)/make.inc

JAVAC=javac
JAVA=java
JAR=jar
CD=cd
BUILDDIR=../../../build
PARDIR=../

export CLASSPATH=$(OFP_CLASSPATH):$CLASSPATH

TEST_DIRS=bug-reports rule-tests rule-f08-tests f08-tests caf_2.0

define run-tests-recursive
	@for dir in $(TEST_DIRS) ; do \
		echo ; echo Running $@ in $$dir...; \
		$(CD) $$dir; \
		$(MAKE) $@; \
                if [ $$? != 0 ]; then exit 1; fi; \
		$(CD) ..; \
	done
endef


check:
	@echo
	@echo "Checking for files in the OFP jar file..."
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep ActionEnums.h
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep FortranParserAction.h
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep token.c
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep token.h
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep c_actions_jni.c
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep jni_token_funcs.h
	@$(JAR) tf $(OFP_BUILD_DIR)/$(OFP_JARFILE) | grep jni_token_funcs.c
	$(run-tests-recursive)

runRuleTests:
	$(run-tests-recursive)

runRuleTestsNoCheck:
	$(run-tests-recursive)

runRuleTestsVerbose:
	$(run-tests-recursive)

clean:
	@for dir in $(TEST_DIRS) ; do \
		echo Cleaning $$dir... ; \
		$(CD) $$dir; \
		$(MAKE) clean; \
		$(CD) ..; \
	done;
