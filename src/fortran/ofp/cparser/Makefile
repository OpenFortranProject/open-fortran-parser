RULE=R102

CFLAGS = -g -m32 -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.c CFortranTokenParser.c        \
                CFortranParser.c     FTreeWalker.c                \
                Unparser.c           Unparser_FTreeWalker.c       \
                ImplicitNone.c       ImplicitNone_FTreeWalker.c

GEN_HDR_FILES = CFortranTokenLexer.h CFortranTokenParser.h        \
                CFortranParser.h     FTreeWalker.h                \
                Unparser.h           Unparser_FTreeWalker.h       \
                ImplicitNone.h       ImplicitNone_FTreeWalker.h

OBJS = OFP_Type.o support.o                                       \
       ftoken-parser.o                                            \
       CFortranTokenLexer.o          CFortranTokenParser.o        \
       CFortranParser.o              OFPTokenSource.o             \
       FortranParserActionNull.o

GEN_OBJS = Unparser.o                Unparser_FTreeWalker.o       \
           ImplicitNone.o            ImplicitNone_FTreeWalker.o

all: unparse checkers $(OBJS)

fparser: fparser.o $(OBJS)
	cc -o $@ -m32 $< $(OBJS) $(LIBS)

unparse: unparse.o ofpbaserecognizer.o $(OBJS) Unparser.o Unparser_FTreeWalker.o
	cc -o $@ -m32 $< ofpbaserecognizer.o $(OBJS) $(LIBS) Unparser.o Unparser_FTreeWalker.o

checkers: checkers.o $(OBJS) ImplicitNone.o ImplicitNone_FTreeWalker.o
	cc -o $@ -m32 $< $(OBJS) $(LIBS) ImplicitNone.o ImplicitNone_FTreeWalker.o

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
	cc -c $(CFLAGS) $<

CFortranTokenParser.o: CFortranTokenParser.c
	cc -c $(CFLAGS) $<

CFortranParser.o: CFortranParser.c
	cc -c $(CFLAGS) $<

OFPTokenSource.o: OFPTokenSource.c OFPTokenSource.h
	cc -c $(CFLAGS) $<

ftoken-parser.o: ftoken-parser.c CFortranTokenLexer.c CFortranTokenParser.c
	cc -c $(CFLAGS) $<

fparser.o: fparser.c $(GEN_SRC_FILES)
	cc -c $(CFLAGS) $<

unparse.o: unparse.c $(GEN_SRC_FILES)
	cc -c $(CFLAGS) $<

OFP_Type.o: OFP_Type.c OFP_Type.h
	cc -c $(CFLAGS) $<

support.o: support.c support.h

check: unparse
	@java fortran.ofp.FrontEnd test-parser.f90 --tokenfile test-parser.tokens
	@unparse test-parser.tokens test-parser.f90

rulecheck: unparse
	@echo "Testing rule $(RULE)"
	@java fortran.ofp.FrontEnd $(RULE).f90 --tokenfile $(RULE).tokens
	@unparse $(RULE).tokens $(RULE).f90

clean:
	rm -f *.o fparser CFortranToken.tokens $(GEN_SRC_FILES) $(GEN_HDR_FILES) $(OBJS) fparser.o
