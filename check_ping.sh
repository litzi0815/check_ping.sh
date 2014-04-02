#!/bin/bash

### $1 = host, $c = count, $3 = pl-warn, $4 = pl-crit, $5 = rtt-warn, $6 = rtt-crit

pingresult=`ping -c $2 $1`


### pl
packetloss=`echo $pingresult | grep 'packet loss' | awk -F',' '{ print $3}' | awk '{ print $1}'`
#echo ${packetloss//[-%]/}
rtt=`echo $pingresult | grep 'rtt' | awk -F'/' '{ print $6}' | awk '{ print $1}'`

if [ ${packetloss//[-%]/} -ge $4 ]
then
	echo "CRITICAL - Host $1 packetloss is $packetloss | rta=$rtt pl=$packetloss"
	exit 2
elif [ ${packetloss//[-%]/} -ge $3 ]
then
	echo "WARNING - Host $1 rta is $rtt ms | rta=$rtt pl=$packetloss"
        exit 1
fi

#echo "!!! $rtt !!!"

rtt_crit=$(awk 'BEGIN{ print "'$rtt'">="'$6'" }')  
rtt_warn=$(awk 'BEGIN{ print "'$rtt'">="'$5'" }')

if [ $rtt_crit -eq 1 ]
then
	echo "CRITICAL - Host $1 rta is $rtt | rta=$rtt pl=$packetloss"
        exit 2
elif [ $rtt_warn -eq 1 ]
then
	echo "WARNING - Host $1 rta is $rtt | rta=$rtt pl=$packetloss"
        exit 1
else
        echo "OK - Host $1 rta $rtt ms, packetloss $packetloss | rta=$rtt pl=$packetloss"
        exit 0
fi
