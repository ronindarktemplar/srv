#!/bin/bash

SARG=$(which sarg)

#Get yesterday date
YESTERDAY=$(date --date "1 day ago" +%d/%m/%Y)
#YESTERDAY=$(date +%d/%m/%Y)
#echo $YESTERDAY
$SARG -o /var/www/html/squid-reports -d $YESTERDAY-$YESTERDAY  > /dev/null 2>&1

exit 0
