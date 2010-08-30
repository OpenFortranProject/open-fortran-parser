// $ANTLR 3.2 Sep 23, 2009 12:02:23 FortranParser.g 2009-10-15 15:39:31

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
 
 /**
 *
 * @author Craig E Rasmussen, Christopher D. Rickett, Bryan Rasmussen
 */
 
package fortran.ofp.parser.java;

import org.antlr.runtime.*;

import java.util.HashMap;

public abstract class FortranParser extends Parser implements IFortranParser {

   /* Provide action objects to implement the AST.  These are singleton objects. */
   protected static IFortranParserAction action = null;
   protected static IFortranParserAction nullAction = new FortranParserActionNull(null, null, null);

   protected FortranParser delegate = null;
   
   protected String filename;

   // TODO - does this state have to be shared?   
   protected boolean has_error_occurred = false;
   
   protected FortranParser(TokenStream input, RecognizerSharedState state) {
      super(input, state);

      // TODO - see if the size has to increase with new F2008 rules
      state.ruleMemo = new HashMap[489+1];
   }
	
   public void initialize(FortranParser delegate, IFortranParserAction action, String filename) {
      this.delegate = delegate;
      this.filename = filename;

      if (this.action != null) this.action = action;
   }
   
   public boolean hasErrorOccurred() { return delegate.has_error_occurred; }

   public void reportError(RecognitionException re) {
      super.reportError(re);

      // Change action class to FortranParserActionNull so that actions are no
      // longer called.  This will allow error handling to be done by ANTLR
      // only.
      //
      this.action = nullAction;

      delegate.has_error_occurred = true;
   }
     
   public IFortranParserAction getAction() {
      return action;
   }
   
   public void main_program() throws RecognitionException {
       delegate.main_program();      
    }
     
   /* TODO - implement, needed by FortranParserAction */
   public Token getRightIToken() {
	   return null;
   }

   /* TODO - implement, may be needed by FortranParserAction */
   public Token getRhsIToken(int i) {
      return null;
   }
 	
   /**
    * Check for include and end of file.  T_INCLUDE is not in the grammar
    * so this method must be called after every statement (and initially
    * at the beginning of program unit file).
    */
   public void checkForInclude() {
	   
      // consume bare T_EOS
      while (input.LA(1) == FortranLexer.T_EOS) {
    	  input.consume();
      }
         
      if (input.LA(1) == FortranLexer.T_INCLUDE) {
         Token tk = input.LT(1);
         input.consume();

         // get include filename from token stream
         tk = input.LT(1);
         input.consume();
         action.start_of_file(tk.getText());

         // check for empty include file (no statements)
         if (input.LA(1) == FortranLexer.T_EOF) {
            tk = input.LT(1);
            input.consume();
            action.end_of_file(tk.getText());
         }

         // include acts like a statement so need to see if another include follows
         checkForInclude();
      }

      else if (input.LA(1) == FortranLexer.T_EOF) {
         Token tk = input.LT(1);
         input.consume();
         action.end_of_file(tk.getText());
         // unwind T_EOFs for include files containing includes
         checkForInclude();
      }

      else if (input.LA(1) == FortranLexer.EOF) {
         input.LT(1);
         input.consume();
         action.end_of_file(filename);
      }
   }	

} // end FortranParser
