dnl -*- shell-script -*-
dnl 
dnl OFP_SETUP_ANTLR
dnl
dnl defines:
dnl OFP_ANTLR 

# Much of this is taken by example from CCAIN 
# (http://sourceforge.net/projects/ccain).

AC_DEFUN([OFP_SETUP_ANTLR],[

ofp_show_subtitle "ANTLR parser generator" 

if test -n "$1" ; then
    # The user specified an ANTLR jar with --with-antlr to configure so try it.
 
    # Verify that the jar file exists.  
    AC_CHECK_FILE([$1], OFP_ANTLR=$1,  AC_MSG_ERROR([$1 specified but does not exist]))
else
	OFP_ANTLR=no
fi

if test "$OFP_ANTLR" = "no" ; then
    # We assume that ANTLR will be set in the environment when we build.
    AC_MSG_WARN([ANTLR will need to be on CLASSPATH at build time.])
else
    AC_MSG_CHECKING([that $OFP_ANTLR can process a grammar])
    # Create a test file
    cat > ConfTest.g <<EOF
		grammar ConfTest; main: X; X:  'x';
EOF

    # We know we can run Java since that was already tested (or should have
    # been, if configure.ac sets up OFP_JAVA first).
    $OFP_JAVA -classpath $OFP_ANTLR org.antlr.Tool -fo ./ ConfTest.g

    # See whether ANTLR produced an expected output file.
    if test -s ConfTestParser.java ; then
		# We successfully processed the grammar.
		rm -f ConfTest.g ConfTest.tokens ConfTestLexer.java ConfTestParser.java
		AC_MSG_RESULT([yes])
    else
		# Clean up and exit configure with an error message.
		rm -f ConfTest.g
		AC_MSG_ERROR([$OFP_ANTLR cannot process a grammar])
    fi
fi

AC_SUBST(OFP_ANTLR)    
AC_DEFINE_UNQUOTED(OFP_ANTLR, "$OFP_ANTLR", [OFP build-time ANTLR parser generator])
])

