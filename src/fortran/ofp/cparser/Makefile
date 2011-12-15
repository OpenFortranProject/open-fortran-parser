CFLAGS = -g -m32 -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.h CFortranTokenParser.h \
                CFortranTokenLexer.c CFortranTokenParser.c \

all: ftokens

ftokens: ftoken-parser.o CFortranTokenLexer.o CFortranTokenParser.o OFPTokenSource.o
	cc -o $@ -m32 $< CFortranTokenLexer.o CFortranTokenParser.o OFPTokenSource.o $(LIBS)

CFortranTokenLexer.o: CFortranTokenLexer.c
	cc -c $(CFLAGS) $<

CFortranTokenParser.o: CFortranTokenParser.c
	cc -c $(CFLAGS) $<

OFPTokenSource.o: OFPTokenSource.c
	cc -c $(CFLAGS) $<

CFortranTokenLexer.c: CFortranToken.g
	java org.antlr.Tool $<

CFortranTokenParser.c: CFortranToken.g
	java org.antlr.Tool $<

ftoken-parser.o: ftoken-parser.c CFortranTokenLexer.c CFortranTokenParser.c
	cc -c $(CFLAGS) $<

check: ftokens
	ftokens test.tokens

clean:
	rm -f *.o ftokens CFortranToken.tokens $(GEN_SRC_FILES)
