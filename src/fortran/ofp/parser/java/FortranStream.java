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

public class FortranStream extends ANTLRFileStream
{
   private int sourceForm;

   public static final int UNKNOWN_SOURCE_FORM = -1;
   public static final int FREE_FORM = 1;
   public static final int FIXED_FORM = 2;

   /**
    * Create a new input buffer and use it to fix line continuation.  This
    * buffer will be used to strip out continuation characters, extra '\n'
    * characters, and in fixed form, extra characters in columns 1-6,
    * including TAB.  It also strips line comments and preprocesser commands.
    * 
    * Note that only line comments (white space followed by '!' comment) are
    * stripped.  Comments occuring in middle of line are passed on to tokenizer.
    * This is done so that FortranStream can handle Holleriths in edit descriptors
    * like the very evil
    * 
    * 100     format (1h1,58x,1h!,/,60x,/,59x,1h*,/)
    *  
    *  which has "1h!" as a hollerith, not a comment!
    */
   public FortranStream(String filename) throws IOException
   {
      super(filename);
      this.sourceForm = determineSourceForm(filename);
      convertInputBuffer();
   }

   public FortranStream(String filename, int sourceForm) throws IOException
   {
      super(filename);
      this.sourceForm = sourceForm;
      convertInputBuffer();
   }


   public int determineSourceForm(String filename) {
      if (filename.endsWith(new String(".f")) == true ||
	      filename.endsWith(new String(".F")) == true) {
         this.sourceForm = FIXED_FORM;
         return FIXED_FORM;
      } else {
         this.sourceForm = FREE_FORM;
         return FREE_FORM;
      }
   } // end determineSourceForm()


   public int getSourceForm()
   {
      return this.sourceForm;
   }


   public String getFileName()
   {
      return getSourceName();
   }


   /**
    * Convert characters to upper case.  This is only for look ahead
    * used in building tokens, in particular key words, the actually
    * character buffer is unchanged so id tokens have original case. 
    */
   public int LA(int i)
   {
      int letter_value = super.LA(i);

      // the letter is lower-case
      if (Character.isLowerCase((char)letter_value)) {
         // convert to upper-case
         letter_value = (int) Character.toUpperCase((char)(letter_value));
      }

      return letter_value;

/****OBSOLETE*****
      int char_pos = super.getCharPositionInLine();

      if (this.sourceForm == FrontEnd.FIXED_FORM) {
         System.out.println("FIXED_FORM: i=" + i + " pos=" + char_pos + " " + letter_value);

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
               if (! (letter_value == (int)'0' || Character.isWhitespace((char)letter_value))) {
                  letter_value = (int)'&';
               }
            }
         }
      }
      return letter_value;
*****OBSOLETE*****/

   } // end LA()
   
   
   private void convertInputBuffer()
   {
      //
      // Processing is a lot easier of we add a couple of '\n'
      // chars to buffer, as file can terminate on '!', for example.
      //
      // IMPORTANT NOTE: In processing a buffer we assume we can always
      // advance to character beyond a '\n'
      //
      char[] newData = new char[super.n+2];
      for (int i = 0; i < super.n; i++) {
         newData[i] = super.data[i];
      }
      newData[super.n]   = '\n';
      newData[super.n+1] = '\n';
      super.data = newData;

      if (this.sourceForm == FIXED_FORM) {
         convertFixedFormInputBuffer();
      }
      else {
         convertFreeFormInputBuffer();
      }
   }


   private void convertFreeFormInputBuffer()
   {
      // buffer for line comments and preprocessor lines
      StringBuffer comments = new StringBuffer();

      char[] newData = new char[super.n];
      boolean continuation = false;
      int count = 0;
      int addCR = 0;
      int col   = 1;    // 1 based 
      int line  = 1;    // 1 based

      for (int i = 0; i < super.n; i++) {
         int ii;
         
         // process column 1 special characters
         if (col == 1) {
            while ((ii = processPreprocessLine(i, data, comments)) != i) {
               // preprocess line can't be added immediately because
               // could be in the middle of a continued line
               line += 1;
               i = ii;
            }
            
            while ((ii = processFreeFormCommentLine(i, data, comments)) != i) {
               // comment line can't be added immediately because
               // could be in the middle of a continued line
               line += 1;
               i = ii;
            }
            
            if (continuation) {
               // '&' may be first nonblank character in a line,               
               // if so, skip over the continuation character
               if ((ii = skipFreeFormContinuation(i, data)) != i) {
                  col += ii - i;
                  i = ii;
               }
               // process a string if it exists
               if ((ii = processString(i, data, count, newData)) != i) {
                  count += ii - i;
                  col   += ii - i;
                  i = ii;
               }
               continuation = false;
            }
            else {
               // add any comments and preprocess lines since not in 
               // the middle of a continued line
               if (comments.length() > 0) {
                  count = copyCommentLines(count, newData, comments);
                  if (i >= super.n) {
                     // this can occur if last line is a comment line
                     continue;
                  }
               }
            }
         }

         // process all columns > 1 
         else {
            // remove comment if it exists but retain '\n'
            if ((ii = processComment(i, data, count, newData)) != i) {
               count += ii - i;
               i = ii;
            }

            // remove continuation if it exists but retain '\n'
            if ((ii = stripFreeFormContinuation(i, data)) != i) {
               continuation = true;
               addCR += 1;
               i = ii;
            }

            // process a string if it exists
            if ((ii = processString(i, data, count, newData)) != i) {
               count += ii - i;
               col   += ii - i;
               i = ii;
            }
         }

         // copy current character
         if (!continuation) {
    	    newData[count++] = data[i];
    	    col += 1;
            if (data[i] == '\n') {
               col = 1;
               line += 1;
               while (addCR > 0) {
                  addCR -= 1;
                  newData[count++] = '\n';
               }
            }
         }

         // this line is to be continued
         else {
            col = 1;
         }
      }

      // switch to new data buffer
      this.data = newData;
      this.n = count;
   }


   /**
    * Comments must be removed from input stream or continuation
    * is much more difficult.
    */
   private void convertFixedFormInputBuffer()
   {
      // buffer for line comments and preprocessor lines
      StringBuffer comments = new StringBuffer();

      char[] newData = new char[super.n];
      int count = 0;
      int addCR = 0;
      int col   = 1;    // 1 based 
      int line  = 1;    // 1 based

      for (int i = 0; i < super.n; i++) {
         int ii;

         // process column 1 special characters
         if (col == 1) {
            while ((ii = processPreprocessLine(i, data, comments)) != i) {
               count = copyCommentLines(count, newData, comments);
               line += 1;
               i = ii;
            }
            
            while ((ii = processFixedFormCommentLine(i, data, comments)) != i) {
               count = copyCommentLines(count, newData, comments);
               line += 1;
               i = ii;
            }

            if (i >= super.n) {
               // this can occur if last line is a comment line
               continue;
            }

            // "expand" TABs by bumping to column 5
            if (data[i] == '\t') {
               col = 5;   // column 5 will pick up TAB character
            }
         }

         else if (col > 1 && col < 6) {
            // remove comment if it exists but retain '\n' or EOF
            if ((ii = processComment(i, data, count, newData)) != i) {
               count += ii - i;
               i = ii;
            }
         }

         else if (col == 6) {
            // Continuation checked at '\n' so not need here, just pass the character.
            // If first line is a continuation it is an error so won't need to be
            // caught here.  TODO - what about included files with continuation, legal?

            // but I think 0 in column 6 to start is legal (gfortran and ifort disagree)
            if (data[i] == '0') data[i] = ' ';
         }

         else {
            // skip over comment if it exists but retain '\n'
            if ((ii = processComment(i, data, count, newData)) != i) {
               count += ii - i;
               i = ii;
            }

            // process a string if it exists
            if ((ii = processString(i, data, count, newData)) != i) {
               count += ii - i;
               col   += ii - i;
               i = ii;
            }
         }
            
         ii = -1;
    	 while (data[i] == '\n' && ii != i) {
            ii = i;
            if ((ii = checkForFixedFormContinuations(i, data, comments)) != i) {
               i = ii;
               addCR += 1;
               if (data[i] == '\n') {
                  ii = -1;
               }
            }
         }

         // copy current character
         newData[count++] = data[i];

         col += 1;
         if (data[i] == '\n') {
            col = 1;
            line += 1;
            while (addCR > 0) {
               addCR -= 1;
               line += 1;
               newData[count++] = '\n';
            }
         }
      }

      // switch to new data buffer
      this.data = newData;
      this.n = count;
   }


   /**
    * Copy comment line and preprocessor lines to data buffer
    */
   int copyCommentLines(int i, char [] newData, StringBuffer comments)
   {
      for(int ii = 0; ii < comments.length(); ii++) {
         newData[i++] = comments.charAt(ii);
      }
      comments.delete(0, comments.length());
      return i;
   }


   /**
    * if a comment, copy comment to newBuf excluding terminating '\n' character 
    */
   private int processComment(int i, char buf[], int count, char newBuf[])
   {
      if (i < super.n && buf[i] == '!') {
         // found comment character, copy characters up to '\n'
         do {
            newBuf[count++] = buf[i++];
         }
         while (i < super.n && buf[i] != '\n');
      }
      return i;
   }


   private int processFreeFormCommentLine(int i, char buf[], StringBuffer comments)
   {
      if (i >= super.n) return i;
      
      // skip over leading blank characters
      int i1 = i;
      while(i1 < super.n && buf[i1] == ' ') i1 += 1;

      // nothing to do if not a comment line
      if (i1 < super.n && buf[i1] != '!' && buf[i1] != '\n') return i;

      // copy leading blank characters
      for (int ii = 0; ii < i1-i; ii++) comments.append(' ');

      if (i1 == super.n) return super.n;

      if (buf[i1] == '\n') {
         // a comment line with only whitespace
         comments.append('\n');
         i = i1+1;
      }
      else {
         i = processLineForCommentChar('!', i1, buf, comments);
      }         

      return i;
   }


   /**
    * Check for comment characters, 'C', '*', and '!' at start of
    * a line.  A blank line is also a comment line. If a comment line is
    * found, copy the line comment to the comments buffer (without trailing
    * '\n', and return the position of the character after the '\n' character.
    */
   private int processFixedFormCommentLine(int i, char buf[], StringBuffer comments)
   {
      if (i >= super.n) return i;

      // first check for free form ('!' comments and blank character lines)
      int ii = processFreeFormCommentLine(i, buf, comments);
      if (ii != i) return ii;

      // check for a normal comment line
      if (buf[i] == '*')      ii = processLineForCommentChar('*', i,  buf, comments);
      else if (buf[i] == 'C') ii = processLineForCommentChar('C', i,  buf, comments);
      else if (buf[i] == 'c') ii = processLineForCommentChar('c', i,  buf, comments);
      
      return ii;
   }


   /**
    * If character at i == c, skip to next line advancing past '\n', while
    * copying intervening characters to comments buffer.
    */
   private int processLineForCommentChar(char c, int i, char buf[], StringBuffer comments)
   {
      if (i >= super.n) return i;

      if (buf[i] == c) {
         if (buf[i] == '*' || buf[i] == 'C' || buf[i] == 'c') {
            // replace by free form comment character
            comments.append('!');
         } else {
            comments.append(buf[i]);
         }
         i += 1;
 
         // found character, copy rest of line
         while (i < super.n && buf[i] != '\n') {
            comments.append(buf[i++]);
         }
         if (i < super.n) {
            comments.append(buf[i++]);  // copy '\n' also
         }
      }

      return i;
   }


   /**
    * If character at i == c, skip to next line advancing past '\n'.
    */
   private int stripLineForChar(char c, int i, char buf[])
   {
      if (i >= super.n) return i;

      if (buf[i] == c) {
         // found character, skip to next line
         i += 1;
         while (i < super.n && buf[i++] != '\n');
      }
      return i;
   }


   private int processPreprocessLine(int i, char buf[], StringBuffer comments)
   {
      return processLineForCommentChar('#', i, buf, comments);
   }


   /**
    * If the current character is '&', strip all remaining
    * characters including '\n'.  If there is a continuation,
    * return the position of the '\n' following the '&'. 
    */
   private int stripFreeFormContinuation(int i, char buf[])
   {
      int ii;
      if ((ii = stripLineForChar('&', i, buf)) != i) {
         // backup to '\n'
         // if '&' EOF this will backup to '&' which will
         // throw a parser error, as it should, as the standard
         // says "there shall" be a later (non comment) line
         i = ii - 1;
      }
      return i;
   }


   /**
    * Check to see if there is a continuation character as '&'
    * the first non-blank character in a line.  If there is, return
    * the position after the '&' character.
    */
   private int skipFreeFormContinuation(int i, char buf[])
   {
      int ii = i;

      while (ii < super.n && buf[ii] == ' ' && buf[ii] != '&') ii += 1;
      if (buf[ii] == '&') i = ii + 1;

      return i;
   }


   /**
    * Called when at a '\n' character.  Look ahead for continuation
    * character at column 6.  There could be comment or preprocess
    * lines in between so have to search for comment lines and remove
    * them if they exist.
    *
    * The convention for a TAB character in columns 1..5 followed
    * by a digit 1..9 is a continuation line.  If TAB + '0' the
    * '0' is ignored in the input stream.  This follows DEC convention
    * (I believe) but is non standard Fortran.
    *
    * WARNING, don't go beyond length of stream, super.n
    */
   private int checkForFixedFormContinuations(int i, char buf[], StringBuffer comments)
   {
      int i0 = i;      // save initial value of i
      int ii = i + 1;  // look ahead past the '\n'
     
      // strip all preprocessor and comment lines
      //
      i += 1;
      if ((ii = processPreprocessLine(i, buf, comments)) != i) {
          return ii-1;
       }
      if ((ii = processFixedFormCommentLine(i, buf, comments)) != i) {
          return ii-1;
       }
      
      // search for TAB in columns 1..5, otherwise continued position will be ii
      for (int j = 0; j < 5; j++) {
         if (buf[ii]   == '\n') return i0;
         if (buf[ii++] == '\t') {
            if (buf[ii] >= '1' && buf[ii] <= '9') {
               return ii+1;
            }
            else {
               if (i == i0 + 1)  return i0;    // nothing found
               else              return i-1;   // '\n' position from comment line
            }
         }
      }

      if (buf[ii] != '0' && buf[ii] != ' ') {
         return ii+1;  // a continuation found
      }

      // if statement begins after '0', replace '0' with ' ' for parsing
      if (buf[ii] == '0') {
         buf[ii] = ' ';
      }
      
      return i0;  // nothing found (expect possibly replacing '0' in column 6
   }


   /**
    * Check for the beginning of a string at this character position.  If
    * found copy the characters of the string into newBuf, except for the
    * terminating quote character.  If a string doesn't terminate it's an error,
    * return '\n' position.  
    */
   private int processString(int i, char buf[], int count, char newBuf[])
   {
      if (i >= super.n) return i;

      char quote_char = 0;

      if (buf[i] == '\'') quote_char = '\'';
      if (buf[i] == '"')  quote_char = '"';

      if (quote_char == 0) return i;  // not the start of a string

      do {
         newBuf[count++] = buf[i++];
         // look for two quote chars in a row, if found copy both
         if (i < super.n - 1 && buf[i] == quote_char && buf[i+1] == quote_char) {
            newBuf[count++] = buf[i++];
            newBuf[count++] = buf[i++];
         }
      }
      while (i < super.n && buf[i] != quote_char && buf[i] != '\n');

      // copy terminating quote char (terminal '\n' is an error)
      if (i < super.n && buf[i] == quote_char) {
         newBuf[count++] = buf[i];
      }

      return i;
   }

} // end class FortranStream
