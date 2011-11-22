CFLAGS = -g -m32 -I.
LIBS = -lantlr3c

GEN_SRC_FILES = CFortranTokenLexer.h CFortranTokenParser.h \
                CFortranTokenLexer.c CFortranTokenParser.c \

all: ftokens

ftokens: CFortranTokenLexer.o CFortranTokenParser.o
	cc -o ftokens -m32 CFortranTokenLexer.o CFortranTokenParser.o $(LIBS)

CFortranTokenLexer.o: CFortranTokenLexer.c
	cc -c $(CFLAGS) CFortranTokenLexer.c

CFortranTokenParser.o: CFortranTokenParser.c
	cc -c $(CFLAGS) CFortranTokenParser.c

CFortranTokenLexer.c: CFortranToken.g
	java org.antlr.Tool CFortranToken.g

check: ftokens
	ftokens test.tokens

clean:
	rm -f *.o ftokens CFortranToken.tokens $(GEN_SRC_FILES)
