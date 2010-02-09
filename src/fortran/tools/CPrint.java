/******************************************************************************
 * Copyright (c) 2005, 2006 Los Alamos National Security, LLC.  This
 * material was produced under U.S. Government contract
 * DE-AC52-06NA25396 for Los Alamos National Laboratory (LANL), which
 * is operated by the Los Alamos National Security, LLC (LANS) for the
 * U.S. Department of Energy. The U.S. Government has rights to use,
 * reproduce, and distribute this software. NEITHER THE GOVERNMENT NOR
 * LANS MAKES ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY
 * LIABILITY FOR THE USE OF THIS SOFTWARE. If software is modified to
 * produce derivative works, such modified software should be clearly
 * marked, so as not to confuse it with the version available from
 * LANL.
 *
 * Additionally, this program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *****************************************************************************/

package fortran.tools;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.io.FileWriter;
import java.io.IOException;

import fortran.ofp.parser.java.IFortranParserAction;


public class CPrint {

   /**
    * @param args
    */
   public static void main(String[] args) {
      String className = "fortran.ofp.parser.java.IFortranParserAction";
      
      // Generate C print functions for each action in IFortranParserAction.
      generateCPrintFuncs(className);
   }

   
   public static void generateCPrintFuncs(String className) {
      FileWriter cFile = null;

      // Open a file for the generated C code.
      try {
         cFile = new FileWriter("FortranParserActionPrint.c");
      } catch(Exception e) {
         e.printStackTrace();
         System.exit(1);
      }

      // Generate the C functions.
      try {
         generateCCode(className, cFile);
      } catch(Exception e) {
         // IOException
         e.printStackTrace();
         System.exit(1);
      }
      
      // Close the generated C file.
      try {
         cFile.close();
      } catch(Exception e) {
         e.printStackTrace();
         System.exit(1);
      }

      return;
   }
        

   public static void generateCCode(String className, FileWriter cFile) 
      throws IOException {

      try {
         // Print the extern "C" block in case C++ is compiling us.
         cFile.write("#ifdef __cplusplus\n");
         cFile.write("extern \"C\" {\n");
         cFile.write("#endif\n");

         // Print the includes for the C file.
         cFile.write("#include <stdio.h>\n");
         cFile.write("#include \"ActionEnums.h\"\n");
         cFile.write("#include \"token.h\"\n");
         cFile.write("#include \"FortranParserAction.h\"\n");
         cFile.write("\n");

         Method[] methods = 
            Class.forName(className).getDeclaredMethods();
         for (int i = 0; i < methods.length; i++) {
            // Print out the method mangled name.
            cFile.write("void " + "c_action_" + methods[i].getName() + "(");

            // Print out the args.
            printMethodArgsForC(methods[i], cFile);
            
            // print the closing paren for the function header.
            cFile.write(")\n");

            // print out the opening curly for the function block.
            cFile.write("{\n");

            // print the function body, including marshalling of params into 
            // C types and calling the regular (non-JNI) C action.
            printFunctionBody(methods[i], cFile);

            // print out the closing curly for the funtion block.
            cFile.write("}\n");

            // Print a blank line between functions for readability.
            cFile.write("\n");
         }


         // Print a close to the extern "C" block.
         cFile.write("#ifdef __cplusplus\n");
         cFile.write("}\n");
         cFile.write("#endif\n");
      } catch (Exception e) {
         // InstantiationException, IllegalAccessException, 
         // IllegalArgumentException, InvocationTargetException
         // ClassNotFoundException, NoSuchMethodException
         System.err.println(e);
      }

   }


   private static void printMethodArgsForC(Method currMethod, 
                                           FileWriter cFile) 
      throws IOException {
      Class[] paramTypes = currMethod.getParameterTypes();

      // Print the args, if any.
      for (int i = 0; i < paramTypes.length-1; i++) {
         printMethodArg(paramTypes[i], i, cFile);
         cFile.write(", ");
      }

      // Print out the last (or first and only) argument.
      if(paramTypes.length > 0) {
         printMethodArg(paramTypes[paramTypes.length-1], paramTypes.length-1, 
                        cFile);
      }
      
      return;
   }// end printMethodArgsForC()


   private static void printMethodArg(Class param, int paramNum, 
                                      FileWriter cFile) 
      throws IOException {
      if(param.isPrimitive()) {
         if(param.getSimpleName().compareTo("boolean") == 0) {
            cFile.write("int carg_" + paramNum);
         } else {
            cFile.write(param.getSimpleName() + " carg_" + paramNum);
            }
         } else if(param.getSimpleName().compareTo("Token") == 0) {
            cFile.write("Token_t *carg_" + paramNum);
         } else {
            System.err.println("Unhandled type in printMethodArgsForC!");
            System.exit(1);
         }
      
      return;
   }

   private static void printFunctionBody(Method currMethod, FileWriter cFile) 
      throws IOException {
      Class[] paramTypes = currMethod.getParameterTypes();
      
      // For debugging, put a print statement in each function for tracking.
      cFile.write("\tprintf(\"c_action_%s arguments (%d args):\\n\", \"" + 
                  currMethod.getName() + "\", " + paramTypes.length + ");\n");
      cFile.write("\n");

      // Generate the prints for each C decl.
      for(int i = 0; i < paramTypes.length; i++) {
         if(paramTypes[i].isPrimitive()) {
            String primitiveType = 
               new String(paramTypes[i].getCanonicalName());
            if(primitiveType.compareTo("boolean") == 0 ||
               primitiveType.compareTo("int") == 0) {
               // C has no boolean so convert to an int
               cFile.write("\tprintf(\"carg_" + i + " = %d\\n\"," + 
                           " carg_"+ i + ");\n");
            } 
         } else {
            // To print the Token_t, call a routine from token.h/c.
            cFile.write("\tif(carg_" + i + " != NULL)\n");
            cFile.write("\t{\n");
            cFile.write("\t\tprintf(\"carg_" + i + " token: \");\n");
            cFile.write("\t\tprint_token(carg_" + i + ");\n");
            cFile.write("\t}\n");
            cFile.write("\telse\n");
            cFile.write("\t{\n");
            cFile.write("\t\tprintf(\"carg_" + i + " token is NULL\\n\");\n");
            cFile.write("\t}\n");
         }
      }

      // Put a blank line after the initialization.
      cFile.write("\n");

      // Put in a return;
      cFile.write("\treturn;\n");
      
      return;
   }// end printFunctionBody()

}
