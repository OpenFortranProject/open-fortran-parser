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
JFLAGS = -d $(BUILDDIR) @sourcefiles $(OFP_JFLAGS)

ACTION_CLASS="null"

JARFILE=$(OFP_JARFILE)

CLASS_FILES = $(CLASSDIR)/FortranToken.class \
              $(CLASSDIR)/FortranLexer.class \
              $(CLASSDIR)/FortranParser.class \
              $(CLASSDIR)/FortranParser08.class \
              $(CLASSDIR)/FortranParserExtras.class \
              $(CLASSDIR)/FortranParserExtras_FortranParser08.class \
              $(CLASSDIR)/FortranStream.class \
              $(CLASSDIR)/FortranTokenStream.class \
              $(CLASSDIR)/FortranLexicalPrepass.class \
              $(CLASSDIR)/IActionEnums.class \
              $(CLASSDIR)/IFortranParser.class \
              $(CLASSDIR)/IFortranParserAction.class \
              $(CLASSDIR)/FortranParserActionNull.class \
              $(CLASSDIR)/FortranParserActionFactory.class \
              $(CLASSDIR)/FortranParserActionPrint.class \
              $(CLASSDIR)/FortranParserRiceCAF.class \
              $(CLASSDIR)/FortranParserRiceCAF_FortranParser08.class
GENERATED_JAVA_FILES = FortranLexer.java \
                       FortranParser08.java \
                       FortranParserExtras.java \
                       FortranParserExtras_FortranParser08.java \
                       FortranParserRiceCAF.java \
                       FortranParserRiceCAF_FortranParser08.java
                       #FortranParserRiceCAF_FortranParserExtras.java \
                       #FortranParserRiceCAF_FortranParserExtras_FortranParser08.java
GENERATED_CLASS_FILES=$(CLASSDIR)/FortranLexer*DFA*.class \
                      $(CLASSDIR)/*$$*.class
GENERATED_TOKEN_FILES = FortranLexer.tokens \
                        FortranParser08.tokens \
                        FortranParserExtras.tokens \
                        FortranParserExtras_FortranParser08.tokens \
                        FortranParserRiceCAF.tokens \
                        FortranParserRiceCAF_FortranParser08.tokens

all: FortranParserActionNull.java $(GENERATED_JAVA_FILES) $(CLASS_FILES) $(BUILDDIR)/$(JARFILE)
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

FortranParser08.java: ../FortranParser08.g FortranLexer.tokens
	$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserExtras.java: ../FortranParserExtras.g FortranLexer.tokens
	@echo Note: error and/or warning messages expected from the next command:
	-$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserRiceCAF.java: ../FortranParserRiceCAF.g FortranLexer.tokens
	@echo Note: error and/or warning messages expected from the next command:
	-$(JAVA) org.antlr.Tool -fo ./ $<

FortranParserActionNull.java: IFortranParserAction.java
	$(PERL) makNull.pl 

$(CLASSDIR)/FortranLexer.class: FortranLexer.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParser.class: FortranParser.java
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParser08.class: FortranParser08.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserExtras.class: FortranParserExtras.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserRiceCAF.class: FortranParserRiceCAF.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserExtras_FortranParser08.class: FortranParserExtras_FortranParser08.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

#$(CLASSDIR)/FortranParserRiceCAF_FortranParser08.class: FortranParserRiceCAF_FortranParser08.java FortranLexer.tokens
#	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserRiceCAF_FortranParserExtras.class: FortranParserRiceCAF_FortranParserExtras.java FortranLexer.tokens
	$(JAVAC) $(JFLAGS) $<

$(CLASSDIR)/FortranParserRiceCAF_FortranParserExtras_FortranParser08.class: FortranParserRiceCAF_FortranParserExtras_FortranParser08.java FortranLexer.tokens
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

############################ clean up ##############################
clean:
	rm -f $(CLASS_FILES) 
	rm -f $(GENERATED_JAVA_FILES) 
	rm -f $(GENERATED_TOKEN_FILES)
	rm -f $(GENERATED_CLASS_FILES)
	rm -f FortranParserActionNull.java

allclean:
	$(MAKE) clean
	cd $(BUILDDIR) ; rm -f $(JARFILE)

