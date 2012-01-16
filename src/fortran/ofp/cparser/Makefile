CFLAGS = -g -m32 -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.c CFortranTokenParser.c \
                CFortranParser.c     FTreeWalker.c

GEN_HDR_FILES = CFortranTokenLexer.h CFortranTokenParser.h \
                CFortranParser.h     FTreeWalker.h

OBJS = ftoken-parser.o CFortranTokenLexer.o CFortranTokenParser.o  \
       CFortranParser.o OFPTokenSource.o                           \
       FortranParserActionNull.o                                   \
       FTreeWalker.o

all: fparser unparse

fparser: fparser.o $(OBJS)
	cc -o $@ -m32 $< $(OBJS) $(LIBS)

unparse: unparse.o $(OBJS)
	cc -o $@ -m32 $< $(OBJS) $(LIBS)

CFortranTokenLexer.c: CFortranToken.g
	java org.antlr.Tool $<

CFortranTokenParser.c: CFortranToken.g
	java org.antlr.Tool $<

FTreeWalker.c: FTreeWalker.g
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

check: unparse
	@unparse test-parser.tokens test-parser.f90

clean:
	rm -f *.o fparser CFortranToken.tokens $(GEN_SRC_FILES) $(GEN_HDR_FILES) $(OBJS) fparser.o
