/**
 * Copyright (c) 2005, 2006 Los Alamos National Security, LLC.  This
 * material was produced under U.S. Government contract DE-
 * AC52-06NA25396 for Los Alamos National Laboratory (LANL), which is
 * operated by the Los Alamos National Security, LLC (LANS) for the
 * U.S. Department of Energy. The U.S. Government has rights to use,
 * reproduce, and distribute this software. NEITHER THE GOVERNMENT NOR
 * LANS MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY
 * LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified to
 * produce derivative works, such modified software should be clearly
 * marked, so as not to confuse it with the version available from
 * LANL.
 *  
 * Additionally, this program and the accompanying materials are made
 * available under the terms of the Eclipse Public License v1.0 which
 * accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

#include "OFPFrontEnd.h"
#include "OFPTokenSource.h"
#include "CFortranParser.h"
#include "support.h"

#define PRINT_TOKENS 0
#define PRINT_TREE   0

/** Token parser implementation is in ftoken-parser.c to avoid clashes in antlr headers.
 */
pANTLR3_VECTOR  get_tokens      (const char * token_file);

static  pANTLR3_BASE_TREE  ofpFrontEnd_program_unit  (pOFPFrontEnd parser);
static  void               ofpFrontEnd_free          (pOFPFrontEnd parser);
static  int                ofpGetProgramUnitType     (pANTLR3_INT_STREAM istream);


#ifdef JAVA_TEXT

package fortran.ofp;

import java.io.*;

// the concrete parser classes
import fortran.ofp.parser.java.FortranParserExtras;
import fortran.ofp.parser.java.FortranParserRiceCAF;
import fortran.ofp.parser.java.FortranParserLOPe;

import fortran.ofp.parser.java.FortranLexer;
import fortran.ofp.parser.java.FortranLexicalPrepass;
import fortran.ofp.parser.java.FortranParserActionPrint;
import fortran.ofp.parser.java.FortranStream;
import fortran.ofp.parser.java.FortranTokenStream;
import fortran.ofp.parser.java.IFortranParser;

import org.antlr.runtime.*;

import java.util.ArrayList;
import java.util.concurrent.Callable;

public class FrontEnd implements Callable<Boolean> {

   private FortranStream inputStream;
   private FortranTokenStream tokens;
   private FortranLexer lexer;
   private IFortranParser parser;
   private FortranLexicalPrepass prepass;
   private String filename;
   private int sourceForm;
   private boolean verbose = false;
   private static boolean hasErrorOccurred = false;
   private static ArrayList<String> includeDirs;

   public FrontEnd(String[] args, String filename, String type)
   throws IOException {
      boolean riceCAF = false;
      boolean lanlExtensions = false;
      
      File file = new File(filename);
      String path = file.getAbsolutePath();

      this.inputStream = new FortranStream(filename);
      this.lexer = new FortranLexer(inputStream);

      // Changes associated with antlr version 3.3 require that includeDirs
      // be set here as the tokens are loaded by the constructor.
      this.lexer.setIncludeDirs(includeDirs);
      this.tokens = new FortranTokenStream(lexer);
      
      // check to see if using RiceCAF parser extensions
      //
      for (int i = 0; i < args.length; i++) {
         if (args[i].startsWith("--RiceCAF")) {
            riceCAF = true;
         }
      }

      // check to see if using LOPe parser extensions
      //
      for (int i = 0; i < args.length; i++) {
         if (args[i].startsWith("--LOPExt")) {
            lanlExtensions = true;
         }
      }

      if (riceCAF == true) {
         // laksono 08.06.2010: only output if we have --verbose option set
   	 if (verbose) {
            System.out.println("FortranLexer: using Rice University's CAF extensions");
         }
         this.parser = new FortranParserRiceCAF(tokens);
      }
      else if (lanlExtensions == true) {
   	 if (verbose) {
            System.out.println("FortranLexer: using OFP's LOPe research extensions");
         }
         this.parser = new FortranParserLOPe(tokens);
      }
      else {
         this.parser = new FortranParserExtras(tokens);
      }

      this.parser.initialize(args, type, filename, path);

      this.prepass = new FortranLexicalPrepass(lexer, tokens, parser);
      this.filename = filename;
      this.sourceForm = inputStream.getSourceForm();
   }

   private static boolean parseMainProgram(FortranTokenStream tokens,
         IFortranParser parser, int start) throws Exception {
      // try parsing the main program
      parser.main_program();

      return parser.hasErrorOccurred();
   } // end parseMainProgram()

   private static boolean parseModule(FortranTokenStream tokens,
         IFortranParser parser, int start) throws Exception {
      parser.module();
      return parser.hasErrorOccurred();
   } // end parseModule()

   private static boolean parseSubmodule(FortranTokenStream tokens,
         IFortranParser parser, int start) throws Exception {
      parser.submodule();
      return parser.hasErrorOccurred();
   } // end parseSubmodule()

   private static boolean parseBlockData(FortranTokenStream tokens,
         IFortranParser parser, int start) throws Exception {
      parser.block_data();

      return parser.hasErrorOccurred();
   } // end parseBlockData()

   private static boolean parseSubroutine(FortranTokenStream tokens,
         IFortranParser parser, int start) throws Exception {
      parser.subroutine_subprogram();

      return parser.hasErrorOccurred();
   } // end parserSubroutine()

   private static boolean parseFunction(FortranTokenStream tokens,
         IFortranParser parser, int start) throws Exception {
      parser.ext_function_subprogram();
      return parser.hasErrorOccurred();
   } // end parseFunction()

   private static boolean parseProgramUnit(FortranLexer lexer,
         FortranTokenStream tokens, IFortranParser parser) throws Exception {
      int firstToken;
      int lookAhead = 1;
      int start;
      boolean error = false;

      // check for opening with an include file
      parser.checkForInclude();

      // first token on the *line*. will check to see if it's
      // equal to module, block, etc. to determine what rule of
      // the grammar to start with.
      try {
         lookAhead = 1;
         do {
            firstToken = tokens.LA(lookAhead);
            lookAhead++;
         } while (firstToken == FortranLexer.LINE_COMMENT
               || firstToken == FortranLexer.T_EOS);


         // mark the location of the first token we're looking at
         start = tokens.mark();

         // attempt to match the program unit
         // each of the parse routines called will first try and match
         // the unit they represent (function, block, etc.). if that
         // fails, they may or may not try and match it as a main
         // program; it depends on how it fails.
         //
         // due to Sale's algorithm, we know that if the token matches
         // then the parser should be able to successfully match.
         //
         if (firstToken != FortranLexer.EOF) {
            // CER (2011.10.18): Module is now (F2008) a prefix-spec so
            // must look for subroutine and functions before module stmts.
            // Part of fix for bug 3425005.
            if (tokens.lookForToken(FortranLexer.T_SUBROUTINE) == true) {
               // try matching a subroutine
               error = parseSubroutine(tokens, parser, start);
            }
            else if (tokens.lookForToken(FortranLexer.T_FUNCTION) == true) {
               // try matching a function
               error = parseFunction(tokens, parser, start);
            }
            else if (firstToken == FortranLexer.T_MODULE
                     && tokens.LA(lookAhead) != FortranLexer.T_PROCEDURE) {
               // try matching a module
               error = parseModule(tokens, parser, start);
            }
            else if (firstToken == FortranLexer.T_SUBMODULE) {
               // try matching a submodule
               error = parseSubmodule(tokens, parser, start);
            }
            else if ( firstToken == FortranLexer.T_BLOCKDATA
                  || (firstToken == FortranLexer.T_BLOCK
                  && tokens.LA(lookAhead) == FortranLexer.T_DATA)) {
               // try matching block data
               error = parseBlockData(tokens, parser, start);
            }
            else {
               // what's left should be a main program
               error = parseMainProgram(tokens, parser, start);
            } // end else(unhandled token)
         } // end if(file had nothing but comments empty)
      } catch (RecognitionException e) {
         e.printStackTrace();
         error = true;
      } // end try/catch(parsing program unit)

      return error;
   } // end parseProgramUnit()

#endif


pOFPFrontEnd
ofpFrontEndNew(int nArgs, char* argv[])
{
   ANTLR3_BOOLEAN error      =  ANTLR3_FALSE;
   ANTLR3_BOOLEAN verbose    =  ANTLR3_FALSE;
   ANTLR3_BOOLEAN silent     =  ANTLR3_TRUE;
   ANTLR3_BOOLEAN dumpTokens =  ANTLR3_FALSE;
   //String tokenFile = null;
   //ArrayList<String> newArgs = new ArrayList<String>(0);
   //String type = "fortran.ofp.parser.java.FortranParserActionNull";
   //boolean rice_caf = ANTLR3_FALSE;
   //boolean lanl_extensions = ANTLR3_FALSE;

   if (nArgs < 2) {
      printf("usage: ofpFrontEndNew requires a source file\n");
      exit(1);
   }

   pOFPFrontEnd fe = (pOFPFrontEnd) ANTLR3_MALLOC(sizeof(struct OFPFrontEnd_struct));
   if (fe == NULL)
      {
         printf("ERROR: failed to create OFPFrontEnd\n");
         return  NULL;
      }

   fe->strFactory =  antlr3StringFactoryNew(ANTLR3_ENC_8BIT);
   fe->src_file   =  fe->strFactory->newStr(fe->strFactory, argv[1]);

   /** Install base functionality
    */

   fe->program_unit  =  ofpFrontEnd_program_unit;
   fe->free          =  ofpFrontEnd_free;

   return fe;
}

static pANTLR3_BASE_TREE
ofpFrontEnd_program_unit(pOFPFrontEnd fe)
{
   int                           program_type, i;
   pANTLR3_TOKEN_SOURCE          tsource;
   pANTLR3_COMMON_TOKEN_STREAM   tstream;
   pANTLR3_BASE_TREE             ast_tree;
   pCFortranParser               parser;

   printf("file is %s\n", fe->src_file->chars);

   /* Lexer phase
    *    - Call the token parser to read the tokens from the token file.
    */

   fe->tok_file = fe->strFactory->newStr(fe->strFactory, fe->src_file->chars);
   if (NULL == fe->tok_file)
   {
      return NULL;
   }
   fe->tok_file->append(fe->tok_file, ".tokens");

   printf("tok_file == %s\n", fe->tok_file->chars);

   fe->tlist = get_tokens(fe->tok_file->chars);

   /* print tokens
    */
#if PRINT_TOKENS == 1
   for (i = 0; i < fe->tlist->size(fe->tlist); i++) {
      //print_token_text((pANTLR3_COMMON_TOKEN) fe->tlist->get(fe->tlist, i));
      print_token((pANTLR3_COMMON_TOKEN) tlist->get(fe->tlist, i));
   }
   printf("\n");
#endif

   /* Parser phase
    *    - Call the parser with the token source which uses the token
    *      list obtained from the token file.
    */

   tsource  =  ofpTokenSourceNew                 ( fe->src_file->chars, fe->tlist );
   tstream  =  antlr3CommonTokenStreamSourceNew  ( ANTLR3_SIZE_HINT, tsource );
   parser   =  CFortranParserNew                 ( tstream );

   program_type = ofpGetProgramUnitType(tstream->tstream->istream);

   switch ( program_type ) 
   {
      case T_PROGRAM:            ast_tree = parser->main_program            (parser).tree;      break;
      case T_SUBROUTINE:         ast_tree = parser->subroutine_subprogram   (parser).tree;      break;
      case T_FUNCTION:           ast_tree = parser->ext_function_subprogram (parser).tree;      break;
      case T_MODULE:             ast_tree = parser->module                  (parser).tree;      break;
      case T_SUBMODULE:          ast_tree = parser->submodule               (parser).tree;      break;
      case T_BLOCKDATA:          ast_tree = parser->block_data              (parser).tree;      break;
   }

   if (parser->pParser->rec->state->errorCount > 0)
   {
      fprintf(stderr, "The parser returned %d errors, tree walking aborted.\n", parser->pParser->rec->state->errorCount);
      return NULL;
   }

   return ast_tree;
}

static void
ofpFrontEnd_free(pOFPFrontEnd fe)
{
   free(fe->src_file);
   fe->src_file = NULL;
}

#ifdef JAVA_TEXT

   public static void main(String args[]) throws Exception {
      Boolean error = false;
      Boolean verbose = false;
      Boolean silent = true;
      Boolean dumpTokens = false;
      String tokenFile = null;
      ArrayList<String> newArgs = new ArrayList<String>(0);
      String type = "fortran.ofp.parser.java.FortranParserActionNull";
      int nArgs = 0;
      boolean rice_caf = false;
      boolean lanl_extensions = false;

      includeDirs = new ArrayList<String>();

      // Get the arguments. Use --silent --verbose, and --dump as shorthand
      // so we don't have to specify explicit class names on the command line.
      for (int i = 0; i < args.length; i++) {
         if (args[i].startsWith("--RiceCAF")) {
            newArgs.add(args[i]);
            rice_caf = true;
            nArgs += 1;
            continue;
         } else if (args[i].startsWith("--LOPExt")) {
            newArgs.add(args[i]);
            lanl_extensions = true;
            nArgs += 1;
            continue;
         } else if (args[i].startsWith("--dump")) {
            type = "fortran.ofp.parser.java.FortranParserActionPrint";
            silent = false;
            nArgs += 1;
            continue;
         } else if (args[i].startsWith("--verbose")) {
            type = "fortran.ofp.parser.java.FortranParserActionPrint";
            verbose = true;
            silent = false;
            nArgs += 1;
            continue;
         } else if (args[i].startsWith("--silent")) {
             type = "fortran.ofp.parser.java.FortranParserActionPrint";
             silent = true;
             nArgs += 1;
             continue;
         } else if (args[i].startsWith("--tokenfile")) {
             tokenFile = args[i+1];
             dumpTokens = true;
             nArgs += 1;
             continue;
         } else if (args[i].startsWith("--tokens")) {
             dumpTokens = true;
             nArgs += 1;
             continue;
         } else if (args[i].startsWith("--class")) {
            i += 1;
            type = args[i];
            nArgs += 2;
            continue;
         } else if (args[i].startsWith("-I")) {
            /* Skip the include dir stuff; it's handled by the lexer. */
            nArgs += 1;
            includeDirs.add(args[i].substring(2, args[i].length()));
         } else if (args[i].startsWith("--")) {
            newArgs.add(args[i]);
            newArgs.add(args[i + 1]);
            i += 1;
            nArgs += 2;
            continue;
         }
      }

      if (args.length <= nArgs) {
         System.out.println("Usage: java fortran.ofp.FrontEnd "
               + "[--verbose] [--tokens] [--silent] [--class className] ");
         System.out.println("                                    "
               + "[--user_option user_arg] file1 [file2..fileN]");
      }

      for (int i = 0; i < args.length; i++) {
         // skip args that are not files
         //
         if (args[i].startsWith("--RiceCAF") | args[i].startsWith("--LOPExt") | 
             args[i].startsWith("--dump")    | args[i].startsWith("--silent") |
             args[i].startsWith("--verbose") | args[i].startsWith("--tokens")) {
            continue;
         } else if (args[i].startsWith("-I")) {
            /* Skip the include dir stuff; it's handled by the lexer. */
            continue;
         } else if (args[i].startsWith("--")) {
            i += 1;
            continue;
         }
         if (verbose) {
            System.out
            .println("*******************************************");
            System.out.println("args[" + i + "]: " + args[i]);
         }

         /* Make sure the file exists. */
         File srcFile = new File(args[i]);
         if (srcFile.exists() == false) {
            System.err.println("Error: " + args[i] + " does not exist!");
            error = new Boolean(true);
         } else {
            includeDirs.add(srcFile.getParent());
            FrontEnd ofp = new FrontEnd(newArgs.toArray(new String[newArgs.size()]), args[i], type);
            ofp.setVerbose(verbose, silent);
            if (ofp.getParser().getAction().getClass().getName() == "fortran.ofp.parser.java.FortranParserActionPrint") {
               FortranParserActionPrint action = (FortranParserActionPrint) ofp.getParser().getAction();
               // "verbose" in Print() is either "normal" or "verbose" here..
               action.setVerbose(!silent);
            }

            if (dumpTokens) {
                if (tokenFile != null) {
                	ofp.tokens.outputTokenList(tokenFile);
                } else {
            		ofp.tokens.outputTokenList(ofp.parser.getAction());
                }
            }
            else {
               error |= ofp.call();
            }
         }

         if (verbose) {
            System.out.println("********************************************");
         }

      }

      hasErrorOccurred = error.booleanValue();

      // Reports are that ROSE sometimes doesn't get notification
      // of a failure.  Try calling exit directly with an error condition.
      if (hasErrorOccurred) System.exit(1);
   } // end main()

   public void setVerbose(Boolean vFlag, Boolean sFlag) {
      this.verbose = vFlag;
   }

   public IFortranParser getParser() {
      return this.parser;
   }

   public Boolean call() throws Exception {
      boolean error = false;
      
      int sourceForm = inputStream.getSourceForm();

      if (sourceForm == FortranStream.FIXED_FORM)
         if (verbose)       System.out.println(filename + " is FIXED FORM");
         else if (verbose)  System.out.println(filename + " is FREE FORM");

      // determine whether the file is fixed or free form and
      // set the source form in the prepass so it knows how to handle lines.
      prepass.setSourceForm(sourceForm);

      // apply Sale's algorithm to the tokens to allow keywords
      // as identifiers. also, fixup labeled do's, etc.
      prepass.performPrepass();

      // overwrite the old token stream with the (possibly) modified one
      tokens.finalizeTokenStream();

      // parse each program unit in a given file
      while (tokens.LA(1) != FortranLexer.EOF) {
         // attempt to parse the current program unit
         error = parseProgramUnit(lexer, tokens, parser);

         // see if we successfully parse the program unit or not
         if (verbose && error) {
            System.out.println("Parser failed");
            return new Boolean(error);
         }
      } // end while (not end of file)

      // Call the end_of_file action here so that it comes after the
      // end_program_stmt occurs.
      getParser().eofAction();

      // Call the cleanUp method for the give action class. This is more
      // important in the case of a C action *class* since it could easily
      // have created memory that's outside of the jvm.
      getParser().getAction().cleanUp();

      if (verbose) {
         System.out.println("Parser exiting normally");
      }

      return new Boolean(error);
   } // end call()

   public int getSourceForm() {
      return this.sourceForm;
   }

   public static boolean getError() {
      return hasErrorOccurred;
   }

} // end class FrontEnd

#endif


static int
lookForToken(pANTLR3_INT_STREAM istream, int token, int look_ahead)
{
   // TODO - implement
   return 0;
}


static int
ofpGetProgramUnitType(pANTLR3_INT_STREAM istream)
{
   uint look_ahead, first_token, next_token;

   look_ahead = 1;
   do
   {
      first_token = istream->_LA(istream, look_ahead);
      look_ahead += 1;
   }
   while (first_token == LINE_COMMENT || first_token == T_EOS);

   if (first_token == T_EOS)
   {
      /* we allow empty files as a main-program */
      return T_PROGRAM;
   }


   // TODO - what is this for, won't parser ignore comments and blank lines? (from the Java impl)
   //
   // mark the location of the first token we're looking at
   //start = tokens.mark();


   /* skip a statement label if present (not used to disambiguate)
    */
   if (first_token == T_DIGIT_STRING)
   {
      look_ahead += 1;
      first_token = istream->_LA(istream, look_ahead);
      
   }
   next_token  = istream->_LA(istream, look_ahead + 1);

   /* Do the easy stuff first.  Be careful about what is placed here and the
    * order (see note below regarding bug 3425005).
    */
   switch ( first_token ) 
   {
      case T_PROGRAM:          return T_PROGRAM;
      case T_SUBROUTINE:       return T_SUBROUTINE;
      case T_FUNCTION:         return T_FUNCTION;
      case T_SUBMODULE:        return T_SUBMODULE;
      case T_BLOCKDATA:        return T_BLOCKDATA;
      case T_BLOCK:
         {
            if (next_token == T_DATA)
            {
               return T_BLOCKDATA;
            }
         }
      // T_MODULE handled later
   }

   /* Now look beyond beginning tokens for subroutines and functions.
    *
    * CER (2011.10.18): Module is now (F2008) a prefix-spec so must look for subroutine
    * and functions before module stmts.  Part of fix for bug 3425005.
    */

   if      ( lookForToken(istream, T_SUBROUTINE, look_ahead) )
   {
      return T_SUBROUTINE;
   }
   else if ( lookForToken(istream, T_FUNCTION,   look_ahead) )
   {
      return T_FUNCTION;
   }
   else if (first_token == T_MODULE  &&  next_token != T_PROCEDURE)
   {
      return T_MODULE;
   }

   /* what's left should be a main program
    */
   return T_PROGRAM;
}
