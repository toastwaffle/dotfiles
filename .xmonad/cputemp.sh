#!/bin/bash
temp1=`cat /sys/class/thermal/thermal_zone0/temp`
temp=`expr $temp1 / 1000`
if [ $temp -le 50 ]
    then
        echo 'T: <fc=green>'`expr $temp`'</fc>'C
else
    if [ $temp -le 60 ]
        then
            echo 'T: <fc=orange>'`expr $temp`'</fc>'C
        else
            echo 'T: <fc=red>'`expr $temp`'</fc>'C
    fi
fi
