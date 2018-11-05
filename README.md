[This document is formatted with GitHub-Flavored Markdown.                      ]:#
[For better viewing, including hyperlinks, read it online at                    ]:#
[https://github.com/openfortranproject/open-fortran-parser/blob/master/README.md]:#

#                Open Fortran Parser (OFP)                   #

[![latest GitHub release](https://img.shields.io/github/release/mbdevpl/open-fortran-parser.svg)](https://github.com/mbdevpl/open-fortran-parser/releases) [![latest Bintray version](https://img.shields.io/bintray/v/mbdevpl/pkgs/open-fortran-parser.svg)](https://bintray.com/mbdevpl/pkgs/open-fortran-parser) [![build status from Travis CI](https://travis-ci.org/mbdevpl/open-fortran-parser.svg?branch=master)](https://travis-ci.org/mbdevpl/open-fortran-parser) [![test coverage from Codecov](https://codecov.io/gh/mbdevpl/open-fortran-parser/branch/master/graph/badge.svg)](https://codecov.io/gh/mbdevpl/open-fortran-parser)

This is a fork of [Open Fortran Parser from Open Fortran Project](https://github.com/OpenFortranProject/open-fortran-parser). Changes from the source are described on [releases page](https://github.com/mbdevpl/open-fortran-parser/releases). This fork of OFP was mainly created to enable creation of XML Fortran AST through [Open Fortran Parser XML (OFP XML)](https://github.com/mbdevpl/open-fortran-parser-xml).


Original README follows.

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

The OFP parser is based on an [ANTLR] 3 grammar and ANTLR version 3.5.2
tools are used to generate the Fortran parser (written in Java).
The C action interfaces are currently provided by JNI.

## <a name="resources">Resources</a>  ##

### <a name="installation-instructions">Installation instructions</a>  ###

  - See the [INSTALL.md] file.

### <a name="documentation">Documentation</a>   ###

  - Still a little sparse.  Action interfaces are defined by the [Java file]

### <a name="running-the-parser">Running the parser</a> ###

  - Set your java [CLASSPATH] to include the ANTLR jar files and
    OpenFortranParser-<version>.jar.  If you use the bash shell, you can set the
    CLASSPATH with something like (assuming files are installed in /usr/local):
```bash
  export CLASSPATH=/usr/local/antlr/lib/antlr-3.5.2-complete.jar:/usr/local/ofp/lib/OpenFortranParser-<version>.jar
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
[INSTALL.md]: ./INSTALL.md
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
