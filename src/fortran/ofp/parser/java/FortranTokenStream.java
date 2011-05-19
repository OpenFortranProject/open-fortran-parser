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

import java.util.*;
import org.antlr.runtime.*;

import fortran.ofp.parser.java.FortranToken;

public class FortranTokenStream extends LegacyCommonTokenStream {
   public FortranLexer lexer;
   public int needIdent;
   public int parserBacktracking;
   public boolean matchFailed;
   private List currLine;
   private int lineLength;
   private Token eofToken = null;
   private ArrayList<Token> packedList;
   private ArrayList<Token> newTokenList;

   public FortranTokenStream(FortranLexer lexer) {
      super(lexer);
      this.lexer = lexer;
      this.needIdent = 0;
      this.parserBacktracking = 0;
      this.matchFailed = false;
      this.currLine = null;
      this.lineLength = 0;
      this.packedList = null;
      this.newTokenList = new ArrayList<Token>();
      
      this.fillBuffer();

      // For some reason antlr v3.3 LA/LT(1) no longer return <EOF> token
      // save it last token from source (EOF) and return it in LT method.
      eofToken = tokenSource.nextToken();
      eofToken.setTokenIndex(size());

      FortranStream fs = ((FortranLexer) lexer).getInput();
      eofToken.setText(fs.getFileName() + ":" + fs.getAbsolutePath());
   } // end constructor
   
   /**
    * For some reason antlr v3.3 LA/LT() no longer returns <EOF> token,
    * so save it last token from source (EOF) and return it in LT method.
    */
   public Token LT(int k) {
      if (index()+k-1 >= this.size()) {
    	  return eofToken;
      }
      return super.LT(k);
   }

/*******OBSOLETE
   public void fixupFixedFormat() {
      ArrayList<Token> tmpArrayList = null;
      boolean hasContinuation = false;
      List tmpList = null;
      int i = 0;
      Token tk;
      
      tmpList = super.getTokens();
      tmpArrayList = new ArrayList<Token>(tmpList.size());
      // TODO:
      // this won't be necessary once ANTLR updates their getTokens method
      // to return an ArrayList, that uses the syntax ArrayList<Token>.  
      // otherwise, the compiler gives a warning about unchecked or unsafe
      // operations.  this loop is overkill for simply avoiding the warning...
      // however, having an ArrayList that contains typed objects (Token) is 
      // useful below because we may have to rewrite the stream when handling
      // comments and continuations.  
      for (i = 0; i < tmpList.size(); i++) {
         try {
            tmpArrayList.add((Token)tmpList.get(i));
         } catch(Exception e) {
            e.printStackTrace();
            System.exit(1);
         }
      }

      // Loop across the tokens and convert anything in column 0 to a 
      // line comment, and anything in col 6 to continuation.  note: this may
      // require the splitting of tokens!
      //
      // We also have to check for tabs in the first character position.  Following
      // DEC's convention, <TAB>digit (other than zero) is a continuation line,
      // otherwise the line starts a new statement.  Codes seem to use <TAB><BLANK> to
      // start a new line so perhaps <TAB> is essentially treated as 5 spaces?
      //
      
      int continue_pos = 5;
      for (i = 0; i < tmpArrayList.size(); i++) {
         tk = tmpArrayList.get(i);

         int tk_pos = tk.getCharPositionInLine();
         char tk_char_0 = tk.getText().charAt(0);
         
         // check for tab formatting
         if (tk_pos == 0) {
        	 if (tk_char_0 == '\t') {
        	    continue_pos = 1; // follows tab
        	 } else {
                continue_pos = 5; // column 6
	         }
         }

         if (tk_pos == continue_pos) {
            int tk_type = tk.getType();
            if (tk_type != FortranLexer.WS && tk_char_0 != '0' &&
               (tk_type != FortranLexer.T_EOS ||
               (tk_type == FortranLexer.T_EOS && tk_char_0 == ';'))) {
               // Any non blank char other than '0' can be a continuation char if it's in 
               // the 6th column (col. 5 because zero based), even '!' or ';'.
               // If an initial tab then continuation char is a digit 1-9.
               // TODO:
               // if the length is greater than 1, then the user is most likely 
               // using a letter or number to signal the continuation.  in this 
               // case, we need to split off the character that's in column 6 and
               // make two tokens -- the continuation token and what's left.  we 
               // should maybe warn the user about this in case they accidentally
               // started in the wrong column?
               if (tk.getText().length() == 1) {
                  hasContinuation = true;
               }
               else if (continue_pos != 1) {
                  System.err.println("TODO: handle this continuation type!");
               }
            }
         }
         if (hasContinuation) {
            int j, k, prevType;
            Token prevToken = null;
            hasContinuation = false;  // reset

            tk.setType(FortranLexer.CONTINUE_CHAR);
            // hide the continuation token
            tk.setChannel(lexer.getIgnoreChannelNumber());
            tmpArrayList.set(i, tk);

            j = i-1;
            do {
               prevToken = tmpArrayList.get(j);
               prevType = prevToken.getType();
               j--;
            } while (j >= 0 && (prevType == FortranLexer.WS ||
                                prevType == FortranLexer.LINE_COMMENT ||
                                prevType == FortranLexer.T_EOS));

            // channel 99 (hide) all tokens from after prevToken (j+1)+1 
            // through the continue token (i)
            for (k = j+2; k < i; k++) {
               tk = tmpArrayList.get(k);
               // only hide the T_EOS tokens. all WS and LINE_COMMENT tokens
               // should already be hidden.
               if (tk.getType() == FortranLexer.T_EOS && tk.getText().charAt(0) != ';') {
                  tk.setChannel(lexer.getIgnoreChannelNumber());
                  tmpArrayList.set(k, tk);
               }
            }
               
               // TODO:
               // how can we handle fixed-format split tokens?  for example:
               //   inte
               //    ger j
               //   this is the variable declaration 'integer j'.  how are we 
               //   suppose to know this?  it compiles with gfortran.
               //
//                // need to find the next non-WS token
//                i++;
//                while(tmpArrayList.get(i).getType() == FortranLexer.WS ||
//                      tmpArrayList.get(i).getType() == 
//                      FortranLexer.LINE_COMMENT) {
//                   i++;
//                }

//                StringBuffer buffer = new StringBuffer();
//                Token token;
//                int tokenCount = 0;

//                buffer = buffer.append(prevToken.getText());
//                buffer = buffer.append(tmpArrayList.get(i).getText());
                  
//                ANTLRStringStream charStream = 
//                   new ANTLRStringStream(buffer.toString().toUpperCase());
//                FortranLexer myLexer = new FortranLexer(charStream);
//                System.out.println("trying to match the string: " + 
//                                   buffer.toString().toUpperCase() + 
//                                   " for fixed-format continuation");
         }
      } // end for (each Token in the ArrayList) 

//       System.out.println("tmpArrayList as one big string: ");
//       StringBuffer buffer = new StringBuffer();
//       for(i = 0; i < tmpArrayList.size(); i++) {
//          tmpToken = tmpArrayList.get(i);
//          if (tmpToken.getType() == FortranLexer.WS ||
//             (tmpToken.getType() == FortranLexer.T_EOS &&
//              tmpToken.getText().charAt(0) != ';') ||
//             tmpToken.getChannel() != lexer.getIgnoreChannelNumber()) {
//             buffer = buffer.append(tmpToken.getText());
//          }
//       }
//       System.out.println(buffer.toString().toUpperCase());

//       {
//          System.out.println("parsing above buffer with FixedLexer");
//          ANTLRStringStream charStream = 
//             new ANTLRStringStream(buffer.toString().toUpperCase());
//          FixedLexer myFixed = new FixedLexer(charStream);
//          Token fixedToken;

//          do {
//             fixedToken = myFixed.nextToken();
//          } while(fixedToken.getType() >= 0);
//          System.out.println("done parsing above buffer with FixedLexer");
//          System.exit(1);
//       }

//       System.out.println("tmpArrayList.toString(): " + 
//                          tmpArrayList.toString());
//       System.out.println("tmpArrayList.size(): " + tmpArrayList.size());
//       System.out.println("super.tokens.size(): " + super.tokens.size());
//       System.out.println("super.p is: " + super.p);

      // save the new ArrayList (possibly modified) to the super classes 
      // token list.
      super.tokens = tmpArrayList;

      return;
   } // end fixupFixedFormat()
END OBSOLETE*******/

   /**
    * Create a subset list of the non-whitespace tokens in the current line.
    */
   private ArrayList<Token> createPackedList() {
      int i = 0;
      Token tk = null;

      ArrayList<Token> pList = new ArrayList<Token>(this.lineLength+1);

      for (i = 0; i < currLine.size(); i++) {
         tk = getTokenFromCurrLine(i);
         try {
            if (tk.getChannel() != lexer.getIgnoreChannelNumber()) {
               pList.add(tk);
            }
         } catch(Exception e) {
            e.printStackTrace();
            System.exit(1);
         }
      } // end for(each item in buffered line)

      // need to make sure the line was terminated with a T_EOS.  this may 
      // not happen if we're working on a file that ended w/o a newline
      if (pList.get(pList.size()-1).getType() != FortranLexer.T_EOS) {
         FortranToken eos = new FortranToken(lexer.getInput(), FortranLexer.T_EOS, 
                                             Token.DEFAULT_CHANNEL, 
                                             lexer.getInput().index(), 
                                             lexer.getInput().index()+1);
         eos.setText("\n");
         packedList.add(eos);
      }

      return pList;
   } // end createPackedList()

/******OBSOLETE
   private boolean possiblySplitToken(ArrayList<Token> packedList, 
                                      int firstContCharOffset, 
                                      int currOffset) {
      int i = 0;

      for(i = firstContCharOffset+1; i < currOffset; i++) {
         if (packedList.get(i).getType() != FortranLexer.WS &&
            packedList.get(i).getType() != FortranLexer.T_EOS) {
            return false;
         }
      }
      return true;
   } // end possiblySplitToken()

   private void fixupContinuedLine(ArrayList<Token> packedList) {
      int firstContCharOffset = -1;
      int i;
      int j;

      // search for a continue char ('&' in free form)
      for(i = 0; i < packedList.size(); i++) {
         if (packedList.get(i).getType() == FortranLexer.CONTINUE_CHAR) {
            if (firstContCharOffset == -1)
               firstContCharOffset = i;
            else {
               // if all tokens between the first '&' and this one are WS, 
               // we have to consider the '&' chars together.  otherwise, 
               // we don't.
               if (possiblySplitToken(packedList, firstContCharOffset, i) 
                  == true) {
                  // we have to consider the token preceding the first '&' and
                  // the one following the second '&' together.
                  // two continue chars.  need to re-tokenize what's 
                  // immediately before the first continue and immediately 
                  // after the second.
                  StringBuffer buffer = new StringBuffer();
                  Token token;
                  int tokenCount = 0;

                  // channel 99 all of the tokens from the from the 
                  // token preceding the first '&' and the token following 
                  // the second '&', inclusive
                  for(j = firstContCharOffset-1; j <= i; j++) {
                     packedList.get(j).setChannel(
                        lexer.getIgnoreChannelNumber());
                  }
            
                  buffer = 
                     buffer.append(
                        packedList.get(firstContCharOffset-1).getText());
                  buffer = 
                     buffer.append(
                        packedList.get(i+1).getText());
                  
                  ANTLRStringStream charStream = 
                     new ANTLRStringStream(buffer.toString().toUpperCase());
                  FortranLexer myLexer = new FortranLexer(charStream);

                  // drop the token following the second '&'.  the token 
                  // the first '&' has already been dropped by the 'else' 
                  // clause below.
                  packedList.get(i+1).setChannel(
                     lexer.getIgnoreChannelNumber());

                  do {
                     tokenCount++;
                     token = myLexer.nextToken();
                     if (tokenCount == 1) {
                        // this is the first of two possible tokens that 
                        // we're adding to the packed list, so look up the 
                        // line/col position from
                        // the original token (at firstContCharOffset-1).
                        token.setLine(
                           packedList.get(firstContCharOffset-1).getLine());
                        token.setCharPositionInLine(
                           packedList.get(firstContCharOffset-1).
                           getCharPositionInLine());
                     } else {
                        // the second of two tokens we're adding
                        token.setLine(
                           packedList.get(i+1).getLine());
                        token.setCharPositionInLine(
                           packedList.get(i+1).
                           getCharPositionInLine());
                     }
                     if (token.getType() >= 0) {
                        token.setText(token.getText().toLowerCase());
                        // insert the token
                        try {
                           packedList.add(i, token);
                        } catch(Exception e) {
                           e.printStackTrace();
                           System.exit(1);
                        }
                        // increment the loop variable to advance past the 
                        // token we just inserted.
                        i++;
                     }
                  } while(token.getType() >= 0);

                  firstContCharOffset = -1;
               } else {
                  // separate tokens, so drop the '&' and update to the current
                  // '&' as being the first cont char.
                  packedList.get(firstContCharOffset).setChannel(
                     lexer.getIgnoreChannelNumber());
                  firstContCharOffset = i;
               }
            }
         } // end if (FortranLexer.T_CONTINUE_CHAR)
      } // end for()

      return;
   } // end fixupContinuedLine() 
END OBSOLETE*******/

   
   public String lineToString(int lineStart, int lineEnd) {
      int i = 0;
      StringBuffer lineText = new StringBuffer();

      for(i = lineStart; i < packedList.size()-1; i++) {
         lineText.append(packedList.get(i).getText());
      }
      
      return lineText.toString();
   } // end lineToString()


   public List getTokens(int start, int stop) {
      return super.getTokens(start, stop);
   } // end getTokens()


   public int getCurrLineLength() {
      return this.packedList.size();
   }

   public int getRawLineLength() {
      return this.currLine.size();
   }

   public int getLineLength(int start) {
      int lineLength;
      Token token;

      lineLength = 0;
      if (start >= super.tokens.size()) return lineLength;

      // this will not give you a lexer.EOF, so may need to 
      // add a T_EOS token when creating the packed list if the file
      // ended w/o a T_EOS (now new line at end of the file).
      do {
         token = super.get(start+lineLength);
         lineLength++;
      } while((start+lineLength) < super.tokens.size() &&
              (token.getChannel() == lexer.getIgnoreChannelNumber() || 
               token.getType() != FortranLexer.T_EOS && 
               token.getType() != FortranLexer.EOF));

      return lineLength;
   } // end getLineLength()


   public int findTokenInPackedList(int start, int desiredToken) {
      Token tk;

      if (start >= this.packedList.size()) {
         return -1;
      }
      
      do {
         tk = (Token)(packedList.get(start));
         start++;
      } while(start < this.packedList.size() &&
              tk.getType() != desiredToken);

      if (tk.getType() == desiredToken)
         // start is one token past the one we want
         return start-1;

      return -1;
   } // end findTokenInPackedList()


   public Token getToken(int pos) {
      if (pos >= this.packedList.size() || pos < 0) {
         System.out.println("pos is out of range!");
         System.out.println("pos: " + pos + 
                            " packedListSize: " + this.packedList.size());
         return null;
      }
      else
         return (Token)(packedList.get(pos));
   } // end getToken()


   public Token getToken(int start, int desiredToken) {
      int index;
      
      index = findToken(start, desiredToken);
      if (index != -1)
         return (Token)(packedList.get(index));
      else 
         return null;
   } //end getToken()


   public int findToken(int start, int desiredToken) {
      Token tk;

      if (start >= this.packedList.size()) {
         System.out.println("start is out of range!");
         System.out.println("start: " + start + 
                            " packedListSize: " + this.packedList.size());
         return -1;
      }
      
      do {
         tk = (Token)(packedList.get(start));
         start++;
      } while (start < this.packedList.size() && tk.getType() != desiredToken);

      if (tk.getType() == desiredToken)
         // start is one token past the one we want
         return start-1;

      return -1;
   } // end findToken()


   /**
    * Search the currLine list for the desired token.
    */
   public int findTokenInCurrLine(int start, int desiredToken) {
      int size;
      Token tk;

      size = currLine.size();
      if (start >= size) 
         return -1;

      do {
         // get the i'th object out of the list
         tk = (Token)(currLine.get(start));
         start++;
      } while(start < size && 
              tk.getType() != desiredToken);
         
      
      if (tk.getType() == desiredToken)
         return start;

      return -1;
   } // end findTokenInCurrLine()

   
   /**
    * @param pos Current location in the currLine list; the search 
    * will begin by looking at the next token (pos+1).
    */
   public Token getNextNonWSToken(int pos) {
      Token tk;
      
      tk = (Token)(packedList.get(pos+1));

      return tk;
   } // end getNextNonWSToken()


   /**
    * @param pos Current location in the currLine list; the search 
    * will begin by looking at the next token (pos+1).
    */
   public int getNextNonWSTokenPos(int pos) {
      Token tk;
      
      // find the next non WS token
      tk = getNextNonWSToken(pos);
      // find it's position now
      pos = findTokenInCurrLine(pos, tk.getType());

      return pos;
   } // end getNextNonWSTokenPos()


   public Token getTokenFromCurrLine(int pos) {
      if (pos >= currLine.size() || pos < 0) {
         return null;
      }
      else {
         return ((Token)(currLine.get(pos)));
      }
   } // end getTokenFromCurrLine()


   public void setCurrLine(int lineStart) {
      this.lineLength = this.getLineLength(lineStart);
      
      // this will get the tokens [lineStart->((lineStart+lineLength)-1)]
      currLine = this.getTokens(lineStart, (lineStart + this.lineLength) - 1);
      if (currLine == null) {
         System.err.println("currLine is null!!!!");
         System.exit(1);
      }

      // pack all non-ws tokens
      this.packedList = createPackedList();

   } // end setCurrLine()       


   /**
    * This will use the super classes methods to keep track of the 
    * start and end of the original line, not the line buffered by
    * this class.
    */
   public int findTokenInSuper(int lineStart, int desiredToken) {
      int lookAhead = 0;
      int tk, channel;

/*****OBSOLETE NOTE: returning -1 is painful when looking for T_EOS
      // if this line is a comment, skip scanning it
      if (super.LA(1) == FortranLexer.LINE_COMMENT) {
         return -1;
      }
OBSOLETE*****/

      do {
         // lookAhead was initialized to 0
         lookAhead++;

         // get the token
         Token token = LT(lookAhead);
         tk = token.getType();
         channel = token.getChannel();

         // continue until find what looking for or reach end
      } while ((tk != FortranLexer.EOF && tk != FortranLexer.T_EOS && tk != desiredToken)
    		   || channel == lexer.getIgnoreChannelNumber());

      if (tk == desiredToken) {
         // we found a what we wanted to
         return lookAhead;
      }
         
      return -1;
   } // end findTokenInSuper()


   public void printCurrLine() {
      System.out.println("=================================");
      System.out.println("currLine.size() is: " + currLine.size());
      System.out.println(currLine.toString());
      System.out.println("=================================");

      return;
   } // end printCurrLine()


   public void printPackedList() {

      System.out.println("*********************************");
      System.out.println("packedListSize is: " + this.packedList.size());
      System.out.println(this.packedList.toString());
      System.out.println("*********************************");

      return;
   } // end printPackedList()


   public void outputTokenList(IFortranParserAction actions) {
      ArrayList<Token> tmpArrayList = null;
      List tmpList = null;
		      
      tmpList = super.getTokens();
      tmpArrayList = new ArrayList<Token>(tmpList.size());
      for (int i = 0; i < tmpList.size(); i++) {
  	     try {
            tmpArrayList.add((Token)tmpList.get(i));
         } catch(Exception e) {
            e.printStackTrace();
            System.exit(1);
         }
      }
	      
      for (int i = 0; i < tmpArrayList.size(); i++) {
         Token tk = tmpArrayList.get(i);
         actions.next_token(tk);
      }
   } // end printTokenList()


   public int currLineLA(int lookAhead) {
      Token tk = null;

      // get the token from the packedList
      try {
         tk = (Token)(packedList.get(lookAhead-1));
      } catch(Exception e) {
//         e.printStackTrace();
//         System.exit(1);
    	  return -1;
      }
      return tk.getType();
   } // end currLineLA()


   public boolean lookForToken(int desiredToken) {
      int lookAhead = 1;
      int tk;

      do {
         // get the next token
         tk = this.LA(lookAhead);
         // update lookAhead in case we look again
         lookAhead++;
      } while(tk != FortranLexer.T_EOS && tk != FortranLexer.EOF && 
              tk != desiredToken);
      
      if (tk == desiredToken) {
         return true;
      } else {
         return false;
      }
   } // end testForFunction()

   
   public boolean appendToken(int tokenType, String tokenText) {
		FortranToken newToken = new FortranToken(tokenType);
		newToken.setText(tokenText);
      // append a token to the end of newTokenList
      return this.packedList.add(newToken);   
   } // end appendToken()


   public void addToken(Token token) {
      this.packedList.add(token);
   }


   public void addToken(int index, int tokenType, String tokenText) {
      try {
         // for example: 
         // index = 1
         // packedList == label T_CONTINUE T_EOS  (size is 3)
         // newTokenList.size() == 22
         // 22-3+1=20 
         // so, inserted between the label and T_CONTINUE
         this.packedList.add(index, new FortranToken(tokenType, tokenText));
      } catch(Exception e) {
         e.printStackTrace();
         System.exit(1);
      }
      
      return;
   } // end addToken()


   public void set(int index, Token token) {
      packedList.set(index, token);
   } // end set()


   public void add(int index, Token token) {
      packedList.add(index, token);
   }


   public void removeToken(int index) {
      packedList.remove(index);
      return;
   } // end removeToken()


   public void clearTokensList() {
      this.packedList.clear();
      return;
   } // end clearTokensList()


   public ArrayList<Token> getTokensList() {
      return this.packedList;
   } // end getTokensList()

   
   public void setTokensList(ArrayList<Token> newList) {
      this.packedList = newList;
      return;
   } // end setTokensList()


   public int getTokensListSize() {
      return this.packedList.size();
   } // end getTokensListSize()


   public FortranToken createToken(int type, String text, int line, int col) {
      FortranToken token = new FortranToken(type, text);
      token.setLine(line);
      token.setCharPositionInLine(col);
      return token;
   } // end createToken()


   public void addTokenToNewList(Token token) {
      if (this.newTokenList.add(token) == false) {
         System.err.println("Couldn't add to newTokenList!");
      }
      return;
   }

   public void finalizeLine() {
      if (this.newTokenList.addAll(packedList) == false) {
         System.err.println("Couldn't add to newTokenList!");
      }
   } // end finalizeLine()


   public void finalizeTokenStream() {
      super.tokens = this.newTokenList;
   } // end finalizeTokenStream()

} // end class FortranTokenStream
