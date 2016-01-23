[This document is formatted with GitHub-Flavored Markdown.                      ]:#
[For better viewing, including hyperlinks, read it online at                    ]:#
[https://github.com/openfortranproject/open-fortran-parser/blob/master/README.md]:#

#                Open Fortran Parser (OFP)                   #
####                 version 0.8.4                           ####
 
## Contents                                                               
* [Description]
* [Resources]
  * [Installation instructions]
  * [Documentation]
  * [Running the parser]
  * [Help]
  * [git Repository]
  * [Directories]

## <a name="description">Description</a> ##

The Open Fortran Parser (OFP) project provides a Fortran 2008 compliant
parser and associated tools.  These tools provide a Java and C API for
actions that are called when parser rules are completed.  These actions
allow a parser consumer to build a custom Abstract Syntax Tree ([AST]).

If you need access to a complete source-to-source Fortran compiler
infrastructure incorporating OFP, please consider using [ROSE].

The OFP parser is based on an [ANTLR] 3 grammar and ANTLR version 3.3
tools are used to generate the Fortran parser (written in Java).
The C action interfaces are currently provided by JNI.

## <a name="resources">Resources</a>  ##

### <a name="installation-instructions">Installation instructions</a>  ###

  - See the [INSTALL] file.

### <a name="documentation">Documentation</a>   ###

  - Still a little sparse.  Action interfaces are defined by the [Java file]

### <a name="running-the-parser">Running the parser</a> ###

  - Set your java [CLASSPATH] to include the ANTLR jar files and 
    OpenFortranParser-0.8.4.jar.  If you use the bash shell, you can set the
    CLASSPATH with something like (assuming files are installed in /usr/local):
```bash
  export CLASSPATH=/usr/local/antlr/lib/antlr-3.3-complete.jar:/usr/local/ofp/lib/OpenFortranParser-0.8.4.jar
```
  - Run the parser with the command
```bash
  java fortran.ofp.FrontEnd [--verbose] filename
```
### <a name="help">Help</a> ###

  - Please submit problem reports or feature requests via our [Issues] page.
  - Please send questions to fortran-parser-devel@lists.sourceforge.net.

### <a name="git-repository">git Repository</a>  ###

  - The public is free to clone the most recent copy of the [OFP] git repository
    repository and experiment with the tools.  To submit changes,
    please fork the repository, branch on your fork, and submit a pull request

### <a name="directories">Directories</a>   ###

[src]
  - Java and C source files for the project.

[build]
  - Build directory.

[tests]
  - Fortran test files for the parser.



[Hyperlinks]:#

[Contents]:#
[Installation instructions]: #installation-instructions
[Documentation]: #documentation
[Running the parser]: #running-the-parser
[Description]: #description
[Resources]: #resources


[Internal links]:#
[INSTALL]: ./INSTALL
[src]: ./src
[build]: ./build
[tests]: ./tests
[Issues]: https://github.com/openfortranproject/open-fortran-parser/issues
[OFP]: https://github.com/openfortranproject/open-fortran-parser/
[Help]: #help
[git Repository]: #git-repository
[Directories]: #directories


[External links]:#
[AST]: https://en.wikipedia.org/wiki/Abstract_syntax_tree
[Rose]: http://www.rosecompiler.org/
[ANTLR]: http://www.antlr.org
[Java file]: ./src/fortran/ofp/parser/java/IFortranParserAction.java
[CLASSPATH]: https://en.wikipedia.org/wiki/Classpath_(Java)

