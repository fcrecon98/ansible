#!/bin/sh

FACILPATH=/usr/local/edgescape

#------------------------------------------------------------------------------------
#       usage
#------------------------------------------------------------------------------------
if [ "$1" = "" ] ; then
        echo "usage:"
        echo "edgescape [start|stop]"
        exit
fi

#------------------------------------------------------------------------------------
#       Start
#------------------------------------------------------------------------------------
if [ $1 = "start" ] ; then
        /usr/bin/java -classpath "/usr/local/edgescape/lib/*" -mx1024m -Djava.security.egd=file:/dev/urandom com.akamai.edgescape.Facilitator.Facilitator $FACILPATH/config/facil.conf  >  /usr/local/edgescape/logs/out.log 2> /usr/local/edgescape/logs/err.log  &

#------------------------------------------------------------------------------------
#       Stop
#------------------------------------------------------------------------------------
elif [ $1 = "stop" ] ; then
        kill -TERM `ps auxw | grep edgescape | egrep -v grep | awk '{print $2}'`

fi

exit
