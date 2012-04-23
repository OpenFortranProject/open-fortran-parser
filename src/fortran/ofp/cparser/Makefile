RULE=R102

# cc with Apple XCode uses clang which has unwelcome warning messages
#
CC = gcc

# -m32 flag used in antlr3 build (for XCode)
#
ARCH = -m32

CFLAGS = -g $(ARCH) -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.c CFortranTokenParser.c        \
                CFortranParser.c     FTreeWalker.c                \
                Unparser.c           Unparser_FTreeWalker.c       \
                ImplicitNone.c       ImplicitNone_FTreeWalker.c

GEN_HDR_FILES = CFortranTokenLexer.h CFortranTokenParser.h        \
                CFortranParser.h     FTreeWalker.h                \
                Unparser.h           Unparser_FTreeWalker.h       \
                ImplicitNone.h       ImplicitNone_FTreeWalker.h

OBJS = OFPFrontEnd.o OFP_Type.o support.o ftoken-parser.o \
       CFortranTokenLexer.o CFortranTokenParser.o \
       CFortranParser.o OFPTokenSource.o \
       FortranParserActionNull.o

GEN_OBJS = Unparser.o                Unparser_FTreeWalker.o       \
           ImplicitNone.o            ImplicitNone_FTreeWalker.o

all: unparse checkers $(OBJS)

OFPFrontEnd.o: OFPFrontEnd.c OFPFrontEnd.h
	$(CC) -c $(CFLAGS) $<

unparse.o: OFPFrontEnd.c OFPFrontEnd.h

unparse: unparse.o ofpbaserecognizer.o $(OBJS) Unparser.o Unparser_FTreeWalker.o
	$(CC) -o $@ $(ARCH) $< ofpbaserecognizer.o $(OBJS) $(LIBS) Unparser.o Unparser_FTreeWalker.o

checkers: checkers.o $(OBJS) ImplicitNone.o ImplicitNone_FTreeWalker.o
	$(CC) -o $@ $(ARCH) $< $(OBJS) $(LIBS) ImplicitNone.o ImplicitNone_FTreeWalker.o

CFortranTokenLexer.c: CFortranToken.g
	java org.antlr.Tool $<

CFortranTokenParser.c: CFortranToken.g
	java org.antlr.Tool $<

FTreeWalker.c: FTreeWalker.g
	java org.antlr.Tool $<

Unparser.c: Unparser.g FTreeWalker.g
	java org.antlr.Tool $<

ImplicitNone.c: ImplicitNone.g
	java org.antlr.Tool $<

CFortranParser.c: CFortranParser.g
	java org.antlr.Tool $<

CFortranTokenLexer.o: CFortranTokenLexer.c
	$(CC) -c $(CFLAGS) $<

CFortranTokenParser.o: CFortranTokenParser.c
	$(CC) -c $(CFLAGS) $<

CFortranParser.o: CFortranParser.c
	$(CC) -c $(CFLAGS) $<

OFPTokenSource.o: OFPTokenSource.c OFPTokenSource.h
	$(CC) -c $(CFLAGS) $<

ftoken-parser.o: ftoken-parser.c CFortranTokenLexer.c CFortranTokenParser.c
	$(CC) -c $(CFLAGS) $<

fparser.o: fparser.c $(GEN_SRC_FILES)
	$(CC) -c $(CFLAGS) $<

unparse.o: unparse.c $(GEN_SRC_FILES)
	$(CC) -c $(CFLAGS) $<

OFP_Type.o: OFP_Type.c OFP_Type.h
	$(CC) -c $(CFLAGS) $<

support.o: support.c support.h

check: unparse
	@java fortran.ofp.FrontEnd test-parser.f90 --tokenfile test-parser.f90.tokens
	@unparse test-parser.f90

rulecheck: unparse
	@echo "Testing rule $(RULE)"
	@java fortran.ofp.FrontEnd $(RULE).f90 --tokenfile $(RULE).tokens
	@unparse $(RULE).tokens $(RULE).f90

clean:
	rm -f *.o fparser CFortranToken.tokens $(GEN_SRC_FILES) $(GEN_HDR_FILES) $(OBJS) fparser.o
