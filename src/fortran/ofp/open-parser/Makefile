RULE=R1101e.f90
PRGM=module.f90

ANTLR_ROOT = /usr/local

# cc with Apple XCode uses clang which has unwelcome warning messages
#
CC = gcc

# -m32 flag used in antlr3 build (for XCode)
#
#ARCH = -m32

CFLAGS = -g $(ARCH) -I. -I$(ANTLR_ROOT)/include
LIBS = -L$(ANTLR_ROOT)/lib -lantlr3c -lATerm

GEN_SRC_FILES = FortranTokenLexer.c  FortranTokenParser.c         \
                FortranParser.c      FTreeWalker.c                \
                ATermGen.c           ATermGen_FTreeWalker.c

GEN_HDR_FILES = FortranTokenLexer.h  FortranTokenParser.h         \
                FortranParser.h      FTreeWalker.h                \
                ATermGen.h           ATermGen_FTreeWalker.h

OBJS = OFPFrontEnd.o OFP_Type.o support.o ftoken-parser.o \
       FortranTokenLexer.o FortranTokenParser.o \
       FortranParser.o OFPTokenSource.o \
       FortranParserActionNull.o \
       traversal.o

GEN_OBJS = ATermGen.o                ATermGen_FTreeWalker.o

all: unparse $(OBJS)

OFPFrontEnd.o: OFPFrontEnd.c OFPFrontEnd.h
	$(CC) -c $(CFLAGS) $<

unparse.o: OFPFrontEnd.c OFPFrontEnd.h

unparse: unparse.o ofpbaserecognizer.o $(OBJS) ATermGen.o ATermGen_FTreeWalker.o
	$(CC) -o $@ $(ARCH) $< ofpbaserecognizer.o $(OBJS) $(LIBS) ATermGen.o ATermGen_FTreeWalker.o

FortranTokenLexer.c: FortranToken.g
	java org.antlr.Tool $<

FortranTokenParser.c: FortranToken.g
	java org.antlr.Tool $<

FTreeWalker.c: FTreeWalker.g
	java org.antlr.Tool $<

ATermGen.c: ATermGen.g FTreeWalker.g
	java org.antlr.Tool $<

FortranParser.c: FortranParser.g
	java org.antlr.Tool $<

FortranTokenLexer.o: FortranTokenLexer.c
	$(CC) -c $(CFLAGS) $<

FortranTokenParser.o: FortranTokenParser.c
	$(CC) -c $(CFLAGS) $<

FortranParser.o: FortranParser.c
	$(CC) -c $(CFLAGS) $<

OFPTokenSource.o: OFPTokenSource.c OFPTokenSource.h
	$(CC) -c $(CFLAGS) $<

ftoken-parser.o: ftoken-parser.c FortranTokenLexer.c FortranTokenParser.c
	$(CC) -c $(CFLAGS) $<

fparser.o: fparser.c $(GEN_SRC_FILES)
	$(CC) -c $(CFLAGS) $<

unparse.o: unparse.c $(GEN_SRC_FILES)
	$(CC) -c $(CFLAGS) $<

OFP_Type.o: OFP_Type.c OFP_Type.h
	$(CC) -c $(CFLAGS) $<

support.o: support.c support.h

traversal.o: traversal.c traversal.h
	$(CC) -c $(CFLAGS) $<

check: unparse
	@java fortran.ofp.FrontEnd $(PRGM) --tokenfile $(PRGM).tokens
	@unparse $(PRGM)

rulecheck: unparse
	@echo "Testing rule $(RULE)"
	@java fortran.ofp.FrontEnd $(RULE) --tokenfile $(RULE).tokens
	@unparse $(RULE)

clean:
	rm -f *.o fparser $(GEN_SRC_FILES) $(GEN_HDR_FILES) $(OBJS) fparser.o
	rm -f FortranParser.tokens FortranToken.tokens FTreeWalker.tokens
	rm -f ATermGen.tokens test-parser.f90.tokens
