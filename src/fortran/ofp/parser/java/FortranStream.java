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
   private String filename;
   private String filepath;

   public static final int UNKNOWN_SOURCE_FORM = -1;
   public static final int FREE_FORM = 1;
   public static final int FIXED_FORM = 2;

   /**
    * Create a new input buffer and use it to fix line continuation.  This
    * buffer will be used to strip out continuation characters, extra '\n'
    * characters, and in fixed form, extra characters in columns 1-6,
    * including TAB.  It also moves comments and preprocesser commands if
    * they are in the middle of continuation lines.
    * 
    * Note that Holleriths in edit descriptors must be recognized, otherwise
    * what looks like a comment will be processed incorrectly, consider the
    * the very evil
    * 
    * 100   format (1h1,58x,1h!,/,60x,/,59x,1h*,/)
    *  
    *  which has "1h!" as a hollerith, not a comment!
    *
    * Also consider
    *
    * 200   format (1h1,58x,2h!)
    *      &)
    */
   public FortranStream(String filename) throws IOException
   {
      super(filename);
      this.filename = filename;

      File file = new File(filename);
      this.filepath = file.getAbsolutePath();
      
      this.sourceForm = determineSourceForm(filename);
      convertInputBuffer();
   }

   public FortranStream(String filename, String path, int sourceForm) throws IOException
   {
      super(path);
      this.filename = filename;
      this.filepath = path;
      this.sourceForm = sourceForm;
      convertInputBuffer();
   }


   public int determineSourceForm(String fileName) {
      if (fileName.endsWith(new String(".f")) == true ||
	      fileName.endsWith(new String(".F")) == true) {
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
      return filename;
   }

   public String getAbsolutePath()
   {
      return filepath;
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
      // Processing is a lot easier if we add a couple of '\n'
      // chars to buffer, as file can terminate on '!', for example.
      //
      // IMPORTANT NOTE: In processing a buffer we assume we can always
      // advance to character beyond a '\n'.
      // TODO - I believe this means we don't have to check for end
      // of buffer (as currently doing in many places) and these
      // checks, for example, 
      //
      //      if (i < super.n && buf[i] == '!') {
      //
      // can be removed.
      //

      // SKW (2011-08-24) noticed and helped fix a problem with CR-LF line
      // termination.  All CRs are replaced with LFs and the extra LF
      // (if it exists) is dropped.

      // CER 2011-08-25: It would be nice not to have to pad the buffer
      // with ' ' characters.  However, we get an index out of bounds
      // exception unless we do.  So for now pad with ' '.

      // count the number of dropped characters
      //      int count = 0;
      //      for (int i = 0; i < super.n; i++) {
      //         if (super.data[i] == '\r') {
      //            if (i+1 < super.n && super.data[i+1] == '\n') {
      //               count += 1;  // drop the '\r' character
      //               System.out.println("convertInputBuffer: count=" + count);
      //               i += 1;
      //            }
      //         }
      //      }
      //      count = super.n + 2 - count;
    
      char[] newData = new char[super.n+2];

      int from = 0, to = 0;
      while( from < super.n )
      {
         if (super.data[from] != '\r') {
            newData[to++] = super.data[from];
         }
         else {
            newData[to++] = '\n';  // replace '\r'
            if (from+1 < super.n && super.data[from+1] == '\n') {
               from += 1;  // effectively skip the '\r' character
            }
         }
         from += 1;
      }

      // append two extra LFs
      newData[to++] = '\n';
      newData[to++] = '\n';

      // fill any extra slots with blanks
      while( to < super.n+2 )
      {
         newData[to++] = ' ';
      }

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
      // an integer "tuple" to hold i, count return values
      int [] index_count;

      // buffer for line comments and preprocessor lines
      StringBuffer comments = new StringBuffer();

      char[] newData = new char[super.n];
      boolean continuation = false;
      int count = 0;
      int col   = 1;    // 1 based 
      int line  = 1;    // 1 based

      for (int i = 0; i < super.n; i++) {
         int ii;
         
         // process column 1 special characters
         if (col == 1) {
            while ((ii = consumePreprocessLine(i, data, comments)) != i) {
               // preprocess line can't be added immediately because
               // could be in the middle of a continued line
               line += 1;
               i = ii;
            }
            
            while ((ii = consumeFreeFormCommentLine(i, data, comments)) != i) {
               // comment line can't be added immediately because
               // could be in the middle of a continued line
               line += 1;
               i = ii;
            }
            
            if (continuation) {
               // '&' may be first nonblank character in a line,               
               // if so, skip over the continuation character
               if ((ii = skipFreeFormContinuationAtBegin(i, data)) != i) {
                  col += ii - i;
                  i = ii;
               }
               // process a string if it exists
               else if (matchFreeFormString(i, data)) {
                  char quoteChar = data[i];
                  index_count = consumeFreeFormString(i, data, count, newData);
                  ii = index_count[0];  count = index_count[1];
                  while (data[ii] == '&') {
                     // string is continued across multiple lines
                     line += 1;
                     col  += ii - i;
                     i = ii;
                     index_count = completeContinuedString(quoteChar, i, data, count, newData);
                     ii = index_count[0];  count = index_count[1];
                  }
                  col += ii - i;
                  i = ii;
               }
               continuation = false;
            }
            else {
               // add any comments and preprocess lines since not in 
               // the middle of a continued line
               if (comments.length() > 0) {
                  count = consumeCommentLines(count, newData, comments);
                  if (i >= super.n) {
                     // this can occur if last line is a comment line
                     continue;
                  }
               }
            }
         }

         // process all columns > 1 
         else {
            // consume comment if it exists but retain '\n'
            if ((ii = consumeComment(i, data, comments)) != i) {
               count = consumeCommentLines(count, newData, comments);
               i = ii;
            }
            // remove continuation if it exists but retain '\n'
            else if (matchFreeFormContinuationAtEnd(i, data)) {
               ii = consumeFreeFormContinuationAtEnd(i, data, comments);
               continuation = true;
               i = ii;
            }
            // process a string if it exists but retain trailing quote char
            else if (matchFreeFormString(i, data)) {
               char quoteChar = data[i];
               index_count = consumeFreeFormString(i, data, count, newData);
               ii = index_count[0]; count = index_count[1];
               while (data[ii] == '&') {
                  // string is continued across multiple lines
                  line += 1;
                  col  += ii - i;
                  i = ii;
                  index_count = completeContinuedString(quoteChar, i, data, count, newData);
                  ii = index_count[0];  count = index_count[1];
               }
               col += ii - i;
               i = ii;
            }
            // Holleriths are matched after strings so Hollerith matching doesn't have
            // to worry about string, i.e, the string, "4HThis is a string".
            else {
               index_count = consumeHollerith(i, data, count, newData);
               ii = index_count[0];  count = index_count[1];
               if (ii != i) {
                  col += ii - i;
                  i = ii;
               }
            }
         }

         // copy current character
         if (!continuation) {
            if (data[i] == '\n') {
               col = 1;
               line += 1;
               // copy comments that were caught up with continuation
               count = consumeCommentLines(count, newData, comments);
            }
            else {
               col += 1;
            }
    	    newData[count++] = data[i];
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
    * All comments in the middle of continuation lines are moved to a location
    * immediately AFTER the continued line.
    */
   private void convertFixedFormInputBuffer()
   {
      // an integer "tuple" to hold i, count return values
      int [] index_count;

      // buffer for line comments and preprocessor lines
      StringBuffer comments = new StringBuffer();

      char[] newData = new char[super.n];
      int count = 0;
      int col   = 1;    // 1 based 
      int line  = 1;    // 1 based

      for (int i = 0; i < super.n; i++) {
         int ii;

         // process column 1 special characters
         if (col == 1) {
            while ((ii = consumePreprocessLine(i, data, comments)) != i) {
               count = consumeCommentLines(count, newData, comments);
               line += 1;
               i = ii;
            }
            
            while ((ii = consumeFixedFormCommentLine(i, data, comments)) != i) {
               count = consumeCommentLines(count, newData, comments);
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
            // consume a comment if it exists but retain '\n' or EOF
            if (matchComment(i, data)) {
               i = consumeComment(i, data, comments);
               // can't add comments yet if the line is continued
               if (!matchFixedFormContinuation(i, data)) {
                  count = consumeCommentLines(count, newData, comments);
               }
            }
         }

         else if (col == 6) {
            // Continuation checked at '\n' so no need to here, just pass the character.
            // If first line is a continuation it is an error so won't need to be
            // caught here.  TODO - what about included files with continuation, legal?

            // but I think 0 in column 6 to start is legal (gfortran and ifort disagree)
            if (data[i] == '0') data[i] = ' ';
         }

         else {
            // consume a comment if it exists but retain '\n' or EOF
            if (matchComment(i, data)) {
               i = consumeComment(i, data, comments);
               // can't add comments yet if the line is continued
               if (!matchFixedFormContinuation(i, data)) {
                  count = consumeCommentLines(count, newData, comments);
               }
            }
            // consume a string if it exists but retain trailing quote char
            else if (matchFixedFormString(i, data)) {
               ii = consumeFixedFormString(i, data, count, newData);
               count += ii - i;
               col   += ii - i;
               i = ii;
            }
            // Holleriths are matched after strings so Hollerith matching doesn't have
            // to worry about strings, i.e, the string, "4HThis is a string".
            else {
               index_count = consumeHollerith(i, data, count, newData);
               ii = index_count[0];  count = index_count[1];
               if (ii != i) {
                  col += ii - i;
                  i = ii;
               }
            }
         }
            
    	 while (data[i] == '\n' && matchFixedFormContinuation(i, data)) {
            i = consumeFixedFormContinuation(i, data, comments);
         }

         // copy current character
         newData[count++] = data[i];

         col += 1;
         if (data[i] == '\n') {
            col = 1;
            line += 1;
            // copy comments that were caught up with continuation
            count = consumeCommentLines(count, newData, comments);
         }
      }

      // switch to new data buffer
      this.data = newData;
      this.n = count;
   }


   /**
    * Copy comment line and preprocessor lines to data buffer
    */
   int consumeCommentLines(int i, char [] newData, StringBuffer comments)
   {
      for(int ii = 0; ii < comments.length(); ii++) {
         newData[i++] = comments.charAt(ii);
      }
      comments.delete(0, comments.length());
      return i;
   }

   /**
    * Return true if this character starts a comment
    */
   private boolean matchComment(int i, char buf[])
   {
      return (buf[i] == '!');
   }

   /**
    * if a comment, copy comment to comments buffer excluding terminating '\n' character 
    */
   private int consumeComment(int i, char buf[], StringBuffer comments)
   {
      if (i < super.n && buf[i] == '!') {
         // found comment character, copy characters up to '\n'
         do {
            comments.append(buf[i++]);
         }
         while (i < super.n && buf[i] != '\n');
      }
      return i;
   }

   /**
    * Return true if a comment line beginning with '!' is found
    */
   private boolean matchFreeFormCommentLine(int i, char buf[])
   {
      // skip over leading blank characters
      // TODO - what about TABS
      int i1 = i;
      while(i1 < super.n && buf[i1] == ' ') i1 += 1;

      if (i1 >= super.n) return false;

      if (buf[i1] == '!' || buf[i1] == '\n') return true;

      return false;
   }

   private int consumeFreeFormCommentLine(int i, char buf[], StringBuffer comments)
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
    * If a comment, beginning with '!', copy the comment to comments buffer excluding
    * the terminating '\n' character.  Because the next line could be a fixed form
    * continuation, we can't immediately consume the comment as all comments must
    * come after all continued lines (comments can be interspersed between continued
    * lines).
    * 
    * Unused for now.  In future could be used to shorten code in made section
    * when processing comments.
    */
   private int consumeFixedFormComments(int i, char buf[], StringBuffer comments)
   {
      if (i < super.n && buf[i] == '!') {
         // found comment character, copy characters up to '\n'
         do {
            comments.append(buf[i++]);
         }
         while (i < super.n && buf[i] != '\n');
      }

      // consume all comment lines before looking for continuation
      //
      while (matchFixedFormCommentLine(i, buf)) {
         // add '\n' so comments are not merged on a single line
         comments.append('\n');
         // TODO - bump line number and set column?
         i = consumeFixedFormCommentLine(i, buf, comments);
      }

      return i;
   }

   /**
    * Return true if a fixed form comment line is found.
    *
    * Check for comment characters, 'C', '*', and '!' at the start of
    * a line.  A blank line is also a comment line.
    */
   private boolean matchFixedFormCommentLine(int i, char buf[])
   {
      if (i >= super.n) return false;

      // first check for free form ('!' comments and blank character lines)
      if (matchFreeFormCommentLine(i, buf)) return true;

      // check for a normal comment line
      if (buf[i] == '*' || buf[i] == 'C' || buf[i] == 'c') return true;
      
      return false;
   }

   /**
    * Check for comment characters, 'C', '*', and '!' at start of
    * a line.  A blank line is also a comment line. If a comment line is
    * found, copy the line comment to the comments buffer (without trailing
    * '\n', and return the position of the character after the '\n' character.
    */
   private int consumeFixedFormCommentLine(int i, char buf[], StringBuffer comments)
   {
      if (i >= super.n) return i;

      // first check for free form ('!' comments and blank character lines)
      int ii = consumeFreeFormCommentLine(i, buf, comments);
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


   private boolean matchPreprocessLine(int i, char buf[])
   {
      return (buf[i] == '#');
   }

   private int consumePreprocessLine(int i, char buf[], StringBuffer comments)
   {
      return processLineForCommentChar('#', i, buf, comments);
   }

   /**
    * Return true if the current character is '&'
    */
   private boolean matchFreeFormContinuationAtEnd(int i, char buf[])
   {
      return (buf[i] == '&');
   }

   /**
    * If the current character is '&', skip the '&' character and
    * copy all remaining characters to the comments buffer, including
    * '\n', to retain possible comments following the continuation character.
    */
   private int consumeFreeFormContinuationAtEnd(int i, char buf[], StringBuffer comments)
   {
      if (i >= super.n || buf[i] != '&') return i;
      
      i += 1;   // skip the continuation character

      while (i < super.n && buf[i] != '\n') {
         comments.append(buf[i++]);
      }
      if (i < super.n) {
         comments.append(buf[i++]);  // copy '\n' also
      }

      return i-1;  // retain the '\n'
   }

   /**
    * Check to see if there is a continuation character as '&'
    * the first non-blank character in a line.  If there is, return
    * the position after the '&' character.
    */
   private int skipFreeFormContinuationAtBegin(int i, char buf[])
   {
      int ii = i;

      while (ii < super.n && buf[ii] == ' ' && buf[ii] != '&') ii += 1;
      if (buf[ii] == '&') i = ii + 1;

      return i;
   }


   /**
    * Called when at a '\n' character.  Look ahead for continuation
    * character at column 6.  There could be comment or preprocess
    * lines in between so have to skip over comment lines and if
    * they exist.
    *
    * The convention for a TAB character in columns 1..5 followed
    * by a digit 1..9 is a continuation line.  If TAB + '0' the
    * '0' is ignored in the input stream.  This follows DEC convention
    * (I believe) but is non standard Fortran.
    *
    * WARNING, don't go beyond length of stream, super.n
    */
   private boolean matchFixedFormContinuation(int i, char buf[])
   {
      int ii;
     
      // skip all preprocessor and comment lines
      //
      i += 1;
      while (matchPreprocessLine(i, buf) || matchFixedFormCommentLine(i, buf)) {
         i = findCharacter('\n', i, buf);
         if (buf[i] != '\n') return false;
         i += 1;
      }

      // search for TAB in columns 1..5, otherwise continued position will be ii
      ii = i;
      for (int j = 0; j < 5; j++) {
         if (buf[ii]   == '\n') return false;
         if (buf[ii++] == '\t') {
            if (buf[ii] >= '1' && buf[ii] <= '9') {
               return true;
            }
            else {
               return false;
            }
         }
      }

      if (buf[ii] != '0' && buf[ii] != ' ') {
         return true;
      }

      return false;
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
   private int consumeFixedFormContinuation(int i, char buf[], StringBuffer comments)
   {
      int i0 = i;      // save initial value of i
      int ii = i + 1;  // look ahead past the '\n'
     
      // consume all preprocessor and comment lines
      //
      i += 1;
      if (matchPreprocessLine(i, buf)) {
         return (consumePreprocessLine(i, buf, comments) - 1);  // retain the '\n'
      }
      if (matchFixedFormCommentLine(i, buf)) {
         return (consumeFixedFormCommentLine(i, buf, comments) - 1);  // retain the '\n'
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
         comments.append('\n');
         return ii+1;  // a continuation found
      }

      // if statement begins after '0', replace '0' with ' ' for parsing
      if (buf[ii] == '0') {
         buf[ii] = ' ';
      }
      
      return i0;  // nothing found (expect possibly replacing '0' in column 6
   }


   /**
    * Check for a Hollerith following the current character position.  First must
    * ensure that it's not an identifier, "var_2Hxx", so look for preceding
    * character, ' ', '(', ',' (and perhaps more).  Then look for digit string, n,
    * followed by 'H'|'h' and then n characters (none of which is \'n').
    * Perhaps we want to change Hollerith to a quoted string.  In any case,
    * copy string representation to newBuf.
    *
    * We would like to be conservative while matching Hollerith's.  Examples showing
    * characters that can precede a Hollerith constant:
    * " 1Hx", "=1Hx", ".eq.1Hx", "(1Hx", "-1Hx", ",1Hx".  Note Hollerith constants
    * have no data type; they assume a numeric type based on the way they are used.
    * They cannot assume a  character data type and cannot be used where a character
    * value is expected (from a DEC manual for F77, I believe).  Not sure this
    * applies to Hollerith edit descriptors.
    *
    * Assume that strings have been matched so a Hollerith-like constant
    * within a string doesn't have to been considered.
    *
    * Return the last character position in the Hollerith constant if found.
    */
   private int[] consumeHollerith(int i, char buf[], int count, char newBuf[])
   {
      int k;

      if (i >= super.n) return new int[] {i, count};

      // Return i if the first character can be used in a name context, e.g.,
      // "v1H" or "_1H" as this could have been the name "v_1H". A name is
      // A name is a letter followed by an alphanumeric character
      // (letter, digit, '_').  

      // it might be conservative and look for only what CAN precede Hollerith

      if (buf[i] >= 'a' && buf[i] <= 'z') return new int[] {i, count};
      if (buf[i] >= 'A' && buf[i] <= 'Z') return new int[] {i, count};
      if (buf[i] == '_') return new int[] {i, count};

      // count digits preceding possible Hollerith

      int ii = i + 1;
      int numDigits = 0;
      while (buf[ii] >= '0' && buf[ii] <= '9') {
         ii += 1;
         numDigits += 1;
      }
      if (numDigits == 0) return new int[] {i, count};
      if (buf[ii] != 'H' && buf[ii] != 'h') return new int[] {i, count};
      
      // found Hollerith
      
      StringBuffer chars = new StringBuffer(numDigits);
      for (k = 0; k < numDigits; k++) {
         chars.append(buf[i+1+k]);
      }      
      int numChars = Integer.parseInt(chars.toString());

      // look for numChars printable characters
      ii += 1;
      for (k = 0; k < numChars; k++) {
         if (buf[ii+k] < ' ' || buf[ii+k] > '-') break;
      }

      if (k != numChars) return new int[] {i, count};
      
      // number of characters to copy (includes preceding character)
      int numTotal = 1 + numDigits + 1 + numChars;

      // found a Hollerith constant, copy all but last character to newBuf
      for (k = 0; k < numTotal-1; k++) {
         newBuf[count++] = buf[i+k];
      }

      return new int[] {i+numTotal-1, count};
   }

   /**
    * Complete the processing of a string that is continued across multiple lines.
    */
   private int[] completeContinuedString(char quoteChar, int i, char buf[], int count, char newBuf[])
   {
      int i0 = i;

      // skip initial '&'
      if (++i >= super.n) return new int[] {i0, count};

      // skip characters after initial '&'
      while (i < super.n && buf[i] != '\n') i += 1;  // TODO - check for comment
      i += 1;  // skip '\n'

      // skip ' ' characters on next line
      // TODO - what about TABS?
      while (i < super.n && buf[i] == ' ') i += 1;

      if (i >= super.n) return new int[] {i-1, count};

      // skip trailing '&'
      //
      // NOTE: gfortran doesn't require the terminating character (warns with -Wall)
      // so we also ignore the standard here if the trailing '&' is missing
      //
      if (buf[i] == '&') i += 1;

      if (i >= super.n) return new int[] {i-1, count};

      do {
         newBuf[count++] = buf[i++];
         // look for two quote chars in a row, if found copy both
         if (i < super.n - 1 && buf[i] == quoteChar && buf[i+1] == quoteChar) {
            newBuf[count++] = buf[i++];
            newBuf[count++] = buf[i++];
         }
      }
      while (i < super.n && buf[i] != quoteChar && buf[i] != '&' && buf[i] != '\n');

      return new int[] {i, count};
   }

   /**
    * Check for the beginning of a string at this character position.
    */
   private boolean matchFreeFormString(int i, char buf[])
   {
      if (i >= super.n) return false;

      char quote_char = buf[i];
      if (quote_char == '"' || quote_char == '\'') return true;
      else                                         return false;
   }

   /**
    * Check for the beginning of a string at this character position.  If
    * found copy the characters of the string into newBuf, except for the
    * terminating quote character.  A string may be continued, if so it
    * continues after the '&' character on the next line; return the position
    * of the trailing '&'.  If a string doesn't terminate it's an error,
    * return '\n' position.  
    */
   private int[] consumeFreeFormString(int i, char buf[], int count, char newBuf[])
   {
      if (i >= super.n) return new int[] {i,count};

      char quote_char = buf[i];
      if (quote_char != '"' && quote_char != '\'') {
         return new int[] {i,count};  // not the start of a string
      }

      do {
         newBuf[count++] = buf[i++];
         // look for two quote chars in a row, if found copy both
         if (i < super.n - 1 && buf[i] == quote_char && buf[i+1] == quote_char) {
            newBuf[count++] = buf[i++];
            newBuf[count++] = buf[i++];
         }
         // look for continuation character as last non-blank character and
         // if found, return the '&' position so caller can process continuation
         if (buf[i] == '&') {
            int ii = i;
            while (buf[++ii] == ' ');
            if (buf[ii] != '\n') {
               // '&' not a continuation, just part of the string, so just copy it
               newBuf[count++] = buf[i++];
	    }
	 }
      }
      while (i < super.n && buf[i] != quote_char && buf[i] != '&' && buf[i] != '\n');

      return new int[] {i,count};
   }

   /**
    * Check for the beginning of a string at this character position.
    */
   private boolean matchFixedFormString(int i, char buf[])
   {
      return matchFreeFormString(i, buf);
   }

   /**
    * Check for the beginning of a string at this character position.  If
    * found copy the characters of the string into newBuf, except for the
    * terminating quote character.  If a string doesn't terminate it's an error,
    * return '\n' position.  
    */
   private int consumeFixedFormString(int i, char buf[], int count, char newBuf[])
   {
      if (i >= super.n) return i;

      char quote_char = buf[i];
      if (quote_char != '"' && quote_char != '\'') return i;  // not the start of a string

      do {
         newBuf[count++] = buf[i++];
         // look for two quote chars in a row, if found copy both
         if (i < super.n - 1 && buf[i] == quote_char && buf[i+1] == quote_char) {
            newBuf[count++] = buf[i++];
            newBuf[count++] = buf[i++];
         }
      }
      while (i < super.n && buf[i] != quote_char && buf[i] != '\n');

      return i;
   }

   private int findCharacter(char ch, int i, char buf[])
   {
      int i0 = i;
      while (i < super.n && buf[i] != ch) i += 1;
      if (buf[i] == ch) return i;
      else              return i0;
   }

} // end class FortranStream
