#!/usr/bin/env bash

##
## shell script to automatically get all of the jar files necessary
##
ANTLR_VERSION=3.4-complete
ANTLR_JAR=antlr-${ANTLR_VERSION}.jar
ANTLR_URL=http://www.antlr.org/download/${ANTLR_JAR}
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
    WEB_ARGS=""
    
    for p in $PATH
      do
      if [ -d ./antlr_jars ]; then
          WEBGETTER=$WEBGETTER
      else
          if [ -x $p/wget ]; then
              WEBGETTER=$p/wget
              WEB_ARGS="--continue"
              break
          fi
      fi

      if [ -d ./antlr_jars ]; then
          WEBGETTER=$WEBGETTER
      else
          if [ -x $p/curl ]; then
              WEBGETTER=$p/curl
              WEB_ARGS="-o${ANTLR_JAR}"
              break
          fi
      fi
    done
    
    if [ $WEBGETTER = "none" ]; then
      echo "You need to manually download the files."
      return 1
    else
      $WEBGETTER $WEB_ARGS "$ANTLR_URL"
      mkdir antlr_jars
      mv ${ANTLR_JAR} antlr_jars
      cd antlr_jars && ln -s $ANTLR_JAR antlr.jar
    fi
    
fi


