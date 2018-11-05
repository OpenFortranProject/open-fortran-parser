[This document is formatted with GitHub-Flavored Markdown.                       ]:#
[For better viewing, including hyperlinks, read it online at                     ]:#
[https://github.com/openfortranproject/open-fortran-parser/blob/master/INSTALL.md]:#

#             OFP installation and build instructions           #
 
## Contents                                                               
* [Help]
* [Required packages]
* [Before you start to compile OFP]
* [UNIX configure/compile instructions]
* [Running OFP]

## <a name="help">Help</a> ##

   - For help, please  e-mail fortran-parser-devel@lists.sourceforge.net            

## <a name="required-packages">Required packages</a> ##

The Open Fortran Parser (OFP) tools require [ANTLR] 3.5.2.
You can obtain ANTLR from http://www.antlr.org.  OFP also requires a Java installation.

## <a name="before-you-start">Before you start to compile OFP</a> ##

Assuming that you have downloaded the [OFP distribution](http://sourceforge.net/projects/fortran-parser),
unpacked, and untarred it, there should be, at least, the following files and directories:

* [configure] ................ used for Unix builds
* [test] ......................... test files
* [src] .......................... the OFP source code

## <a name="unix-configure">UNIX configure/compile instructions</a> ##

The instructions for building OFP on all Unix platforms are the
same.  First, cd to the OFP top level directory and do the following:

1. Configure for your environment.  A convenient way to see the possible
   options is to type
```bash
    ./configure --help
```
   The primary options are --enable-c-actions and --enable-c-main.  These
   are only needed if you wish build the action interfaces in C and are enabled
   by default.  Normally
```bash
    ./configure
```
   is sufficient for most users.  The --prefix option may be used to change
   the location of the install directory.

2. Run 'make' to build the OFP libraries.

4. Run 'make install' to install the OFP files under the location
   specified with the prefix configure option.  Note that you must have
   the necessary privileges to write to the install directory.

## <a name="running-ofp">Running OFP</a> ##

  - Run the parser with the command
```java
    java fortran.ofp.FrontEnd [--verbose] filename
``` 
   Your Java [CLASSPATH] must include the OpenFortranParser-<version>.jar
   and the antlr-3.5.2-complete.jar files (see the [README.md] file).
  
[Contents]:# 
[Help]: #help
[Required packages]: #required-packages
[Before you start to compile OFP]: #before-you-start
[UNIX configure/compile instructions]: #unix-configure
[Running OFP]: #running-ofp

[Body]:#
[OFP distribution]: http://sourceforge.net/projects/fortran-parser
[ANTLR]:  http://antlr.org/
[configure]: ./configure
[test]: ./test
[src]: ./src
[CLASSPATH]: https://en.wikipedia.org/wiki/Classpath_(Java)
[README.md]: ./README.md
