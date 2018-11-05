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

PERL=perl #perl command
JAVAC=$(OFP_JAVAC) #javac
JAVA=$(OFP_JAVA) $(OFP_JFLAGS) #java
JAR=$(OFP_JAR) #jar
SRCDIR=$(OFP_SRC_DIR)
BUILDDIR=$(OFP_BUILD_DIR)
PARDIR=$(OFP_PARSER_DIR)

CLASSDIR = $(BUILDDIR)/fortran/ofp/parser/java
INSTALLDIR = $(CLASSDIR)
JFLAGS = -d $(BUILDDIR) @sourcefiles $(OFP_JFLAGS) -Xlint:unchecked

ACTION_CLASS="null"

DATE=$(OFP_DATE)
JARFILE=$(OFP_JARFILE)
ALT_JARFILE=OpenFortranParser-$(DATE).jar

CLASS_FILES = $(CLASSDIR)/FortranToken.class \
              $(CLASSDIR)/FortranLexer.class \
              $(CLASSDIR)/FortranParser.class \
              $(CLASSDIR)/FortranParser2008.class \
              $(CLASSDIR)/FortranParser2008_FortranParserBase.class \
              $(CLASSDIR)/FortranStream.class \
              $(CLASSDIR)/FortranTokenStream.class \
              $(CLASSDIR)/FortranLexicalPrepass.class \
              $(CLASSDIR)/IActionEnums.class \
              $(CLASSDIR)/IFortranParser.class \
              $(CLASSDIR)/IFortranParserAction.class \
              $(CLASSDIR)/FortranParserActionNull.class \
              $(CLASSDIR)/FortranParserActionFactory.class \
              $(CLASSDIR)/FortranParserActionPrint.class

EXTENSION_CLASS_FILES = \
              $(CLASSDIR)/FortranParserLOPe.class \
              $(CLASSDIR)/FortranParserLOPe_FortranParserExtend.class \
              $(CLASSDIR)/FortranParserLOPe_FortranParserExtend_FortranParserBase.class \
              $(CLASSDIR)/FortranParserRiceCAF.class \
              $(CLASSDIR)/FortranParserRiceCAF_FortranParserExtend.class \
              $(CLASSDIR)/FortranParserRiceCAF_FortranParserExtend_FortranParserBase.class \

GENERATED_JAVA_FILES = FortranLexer.java \
                       FortranParser2008.java \
                       FortranParser2008_FortranParserBase.java

EXTENSION_GENERATED_JAVA_FILES = \
                       FortranParserLOPe.java \
                       FortranParserRiceCAF.java \
                       FortranParserRiceCAF_FortranParserExtend.java \
                       FortranParserRiceCAF_FortranParserExtend_FortranParserBase.java \
                       FortranParserLOPe_FortranParserExtend.java \
                       FortranParserLOPe_FortranParserExtend_FortranParserBase.java

GENERATED_CLASS_FILES=$(CLASSDIR)/FortranLexer*DFA*.class \
                      $(CLASSDIR)/*$$*.class

GENERATED_TOKEN_FILES = FortranLexer.tokens \
                        FortranParserBase.tokens \
                        FortranParser2008.tokens

EXTENSION_GENERATED_TOKEN_FILES = \
                        FortranParserExtend.tokens \
                        FortranParserLOPe.tokens \
                        FortranParserRiceCAF.tokens

all: FortranParserActionNull.java $(GENERATED_JAVA_FILES) $(CLASS_FILES) $(BUILDDIR)/$(JARFILE) $(BUILDDIR)/$(ALT_JARFILE)
	cp IFortranParserAction.java $(INSTALLDIR)/.

# The -Xconversiontimeout is to try and override the time you allow antlr 
# for converting NFA's.  I couldn't find documentation on what a good number
# would be for the argument.  This flag and the others don't seem to be
# needed in later versions of ANTLR.  
#	$(JAVA) -Xms256M -Xmx512M org.antlr.Tool -Xconversiontimeout 2000 $<
FortranLexer.java: ../FortranLexer.g FortranLexer.tokens
	$(JAVA) org.antlr.Tool -fo ./ $<

# antlr fails creating FortranLexer.java if tokens file isn't there,
# but just creates one if empty file is there
#
FortranLexer.tokens: ../FortranLexer.g
	@rm -f FortranLexer.tokens
	@touch FortranLexer.tokens

FortranParser2008.java: ../FortranParser2008.g ../FortranParserBase.g FortranLexer.tokens
	$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserExtend.java: ../FortranParserExtend.g ../FortranParserBase.g FortranLexer.tokens
	$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserRiceCAF.java: ../FortranParserRiceCAF.g ../FortranParserExtend.g FortranLexer.tokens
	@echo Note: error and/or warning messages expected from the next command:
	-$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserLOPe.java: ../FortranParserLOPe.g FortranLexer.tokens
	@echo Note: error and/or warning messages expected from the next command:
	-$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserActionNull.java: IFortranParserAction.java
	$(PERL) makNull.pl 

$(CLASSDIR)/FortranLexer.class: FortranLexer.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParser.class: FortranParser.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParser2008.class: FortranParser2008.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserRiceCAF.class: FortranParserRiceCAF.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserLOPe.class: FortranParserLOPe.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranStream.class: FortranStream.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranTokenStream.class: FortranTokenStream.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranLexicalPrepass.class: FortranLexicalPrepass.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/IActionEnums.class: IActionEnums.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/IFortranParserAction.class: IFortranParserAction.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserActionNull.class: FortranParserActionNull.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserActionFactory.class: FortranParserActionFactory.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserActionPrint.class: FortranParserActionPrint.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranToken.class: FortranToken.java
	$(JAVAC) $(JFLAGS) $<

$(BUILDDIR)/$(JARFILE): $(CLASS_FILES)
	cd $(BUILDDIR) ; $(JAR) cf $(JARFILE) fortran/

$(BUILDDIR)/$(ALT_JARFILE): $(CLASS_FILES)
	cd $(BUILDDIR) ; $(JAR) cf $(ALT_JARFILE) fortran/

############################ clean up ##############################
clean:
	rm -f $(CLASS_FILES) 
	rm -f $(GENERATED_JAVA_FILES) 
	rm -f $(GENERATED_TOKEN_FILES)
	rm -f $(GENERATED_CLASS_FILES)
	rm -f FortranParserActionNull.java

allclean:
	$(MAKE) clean
	cd $(BUILDDIR) ; rm -f $(JARFILE) $(ALT_JARFILE)

