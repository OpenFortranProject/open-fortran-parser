#!/bin/sh

##
## shell script to automatically get all of the jar files necessary
##
CLASSPATH="`pwd`/antlr_jars/antlr.jar:`pwd`/antlr_jars/antlr-3.1.1.jar:`pwd`/antlr_jars/stringtemplate-3.2.jar:."

echo $CLASSPATH

if [ -d ./antlr_jars ]; then
    echo ""
else
    echo ""
    echo "CLASSPATH IS ABOVE"
    echo ""
    echo ""
    IFS=:
    
    WEBGETTER=none
    
    for p in $PATH
      do

      if [ -d ./antlr_jars ]; then
          WEBGETTER=$WEBGETTER
      else
          if [ -x $p/wget ]; then
              WEBGETTER=$p/wget
              $WEBGETTER http://www.antlr.org/download/antlr-3.1.1.jar
              $WEBGETTER http://www.stringtemplate.org/download/stringtemplate-3.2.jar
              $WEBGETTER http://www.antlr2.org/download/antlr-2.7.7.tar.gz
              mkdir antlr_jars
              mv antlr-3.1.1.jar antlr_jars
              mv stringtemplate-3.2.jar antlr_jars
              tar xzf antlr-2.7.7.tar.gz
              mv antlr-2.7.7/antlr.jar antlr_jars
              rm -rf antlr-2.7.7 antlr-2.7.7.tar.gz
              
          fi
      fi

      if [ -d ./antlr_jars ]; then
          WEBGETTER=$WEBGETTER
      else
          if [ -x $p/curl ]; then
              WEBGETTER=$p/curl
              $WEBGETTER http://www.antlr.org/download/antlr-3.1.1.jar -o antlr-3.1.1.jar
              $WEBGETTER http://www.stringtemplate.org/download/stringtemplate-3.2.jar -o stringtemplate-3.2.jar
              $WEBGETTER http://www.antlr2.org/download/antlr-2.7.7.tar.gz -o antlr-2.7.7.tar.gz
              mkdir antlr_jars
              mv antlr-3.1.1.jar antlr_jars
              mv stringtemplate-3.2.jar antlr_jars
              tar xzf antlr-2.7.7.tar.gz
              mv antlr-2.7.7/antlr.jar antlr_jars
              rm -rf antlr-2.7.7 antlr-2.7.7.tar.gz
          fi
      fi
    done
    
    if [ $WEBGETTER = "none" ]; then
	echo "You need to manually download the files."
	return 1
    fi
    
fi


