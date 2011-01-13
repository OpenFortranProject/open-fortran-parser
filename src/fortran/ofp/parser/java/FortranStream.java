/*******************************************************************************
 * Copyright (c) 2005, 2006 Los Alamos National Security, LLC.
 * This material was produced under U.S. Government contract DE-AC52-06NA25396
 * for Los Alamos National Laboratory (LANL), which is operated by the Los Alamos
 * National Security, LLC (LANS) for the U.S. Department of Energy. The U.S. Government has
 * rights to use, reproduce, and distribute this software. NEITHER THE
 * GOVERNMENT NOR LANS MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR
 * ASSUMES ANY LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified
 * to produce derivative works, such modified software should be clearly marked,
 * so as not to confuse it with the version available from LANL.
 *
 * Additionally, this program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/

package fortran.ofp.parser.java;

import java.io.*;
import org.antlr.runtime.*;

import fortran.ofp.FrontEnd;

public class FortranStream extends ANTLRFileStream {
   private int sourceForm;


   public FortranStream(String fileName) throws IOException {
      super(fileName);
   }


   public FortranStream(String fileName, int sourceForm) throws IOException {
      super(fileName);
      this.sourceForm = sourceForm;
   }


   public int getSourceForm() {
      return this.sourceForm;
   }


   public String getFileName() {
      return getSourceName();
   }


   public int LA(int i) {
      int letter_value = super.LA(i);
      int char_pos = super.getCharPositionInLine();

      // the letter is lower-case
      if (Character.isLowerCase((char)letter_value)) {
         // convert to upper-case
         letter_value = (int) Character.toUpperCase((char)(letter_value));
      }

      if (this.sourceForm == FrontEnd.FIXED_FORM) {
         if (char_pos == 0) {
            if (letter_value == 'C' || letter_value == '*') {
               // return '!' to signify a line comment so the lexer won't try
               // and parse this line.
               letter_value = (int) '!';
            }
         }
         else {
            // Look for continuation character. The convention we use
            // is for TAB + (WS | '0') acts as ';'.  TAB + other char is a
            // continuation line.  This follows DEC (I believe) but is
            // non standard Fortran.
            //
        	 
            // location of continuation character
            int continue_pos = 5; // 6th column
            
            // check for tab formatting, note, this seems to work because LA always
            // called with i==1, so getCharPositionInLine is always as expected
            if (super.LA(-char_pos) == (int) '\t') {
               // first character in line is a tab
               continue_pos = 1;
            }
            
            if (char_pos == continue_pos) {
               // if neither '0' nor whitespace then a continuation character
               if (letter_value >= (int)'1' && letter_value <= (int)'9') {
                  letter_value = (int)'&';
               }
            }
         }
      }

      return letter_value;
   } // end LA()
   
} // end class FortranStream
