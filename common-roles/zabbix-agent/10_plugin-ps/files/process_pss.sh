#!/bin/bash

##########################################################
# Show Process's PSS Memory Size (Need Root Permission)
# argument
# - Process Cmd Name
# - User name
########################################################## 

PSS=0
PGREP=`pgrep -u $2 $1`

while read line
do
	TMPPSS=`grep -E "^Pss" /proc/${line}/smaps | awk '{sum += $ 2 ; }END{ print sum ; }' `
	PSS=`expr $PSS + $TMPPSS`
done <<END
$PGREP
END

echo $PSS
