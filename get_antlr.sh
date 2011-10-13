#!/usr/bin/env bash

##
## shell script to automatically get all of the jar files necessary
##
ANTLR_VERSION=3.4.4
ANTLR_JAR=antlr-${ANTLR_VERSION}.jar
ANTLR_TARGZ=antlr-${ANTLR_VERSION}.tar.gz
ANTLR_URL=http://www.antlr.org/download/${ANTLR_TARGZ}
CLASSPATH="`pwd`/antlr_jars/antlr.jar:`pwd`/antlr_jars/${ANTLR_JAR}:."

echo $CLASSPATH
echo ${ANTLR_JAR}

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
              $WEBGETTER "$ANTLR_URL"
              mkdir antlr_jars
              mv ${ANTLR_JAR} antlr_jars
          fi
      fi

      if [ -d ./antlr_jars ]; then
          WEBGETTER=$WEBGETTER
      else
          if [ -x $p/curl ]; then
              WEBGETTER=$p/curl
              $WEBGETTER "$ANTLR_URL" -o $ANTLR_JAR
              mkdir antlr_jars
              mv $ANTLR_JAR antlr_jars
          fi
      fi
    done
    
    if [ $WEBGETTER = "none" ]; then
	echo "You need to manually download the files."
	return 1
    fi
    
fi


