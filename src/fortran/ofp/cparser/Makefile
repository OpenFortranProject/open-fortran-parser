CFLAGS = -g -m32 -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.h CFortranTokenParser.h \
                CFortranTokenLexer.c CFortranTokenParser.c \
                CFortranParser.h     CFortranParser.c

OBJS = ftoken-parser.o CFortranTokenLexer.o CFortranTokenParser.o CFortranParser.o OFPTokenSource.o

all: fparser

fparser: fparser.o $(OBJS)
	cc -o $@ -m32 $< $(OBJS) $(LIBS)

CFortranTokenLexer.c: CFortranToken.g
	java org.antlr.Tool $<

CFortranTokenParser.c: CFortranToken.g
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

fparser.o: fparser.c CFortranParser.c
	cc -c $(CFLAGS) $<

check: fparser
	fparser test-parser.tokens

clean:
	rm -f *.o fparser CFortranToken.tokens $(GEN_SRC_FILES) $(OBJS) fparser.o
