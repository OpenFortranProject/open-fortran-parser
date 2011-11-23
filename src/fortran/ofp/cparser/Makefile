CFLAGS = -g -m32 -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.h CFortranTokenParser.h \
                CFortranTokenLexer.c CFortranTokenParser.c \

all: ftokens

ftokens: CFortranTokenLexer.o CFortranTokenParser.o OFPTokenStream.o
	cc -o $@ -m32 $< CFortranTokenParser.o OFPTokenStream.o $(LIBS)

CFortranTokenLexer.o: CFortranTokenLexer.c
	cc -c $(CFLAGS) $<

CFortranTokenParser.o: CFortranTokenParser.c
	cc -c $(CFLAGS) $<

OFPTokenstream.o: OFPTokenStream.c
	cc -c $(CFLAGS) $<

CFortranTokenLexer.c: CFortranToken.g
	java org.antlr.Tool $<

check: ftokens
	ftokens test.tokens

clean:
	rm -f *.o ftokens CFortranToken.tokens $(GEN_SRC_FILES)
