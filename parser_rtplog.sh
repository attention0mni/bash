#!/bin/bash
DATE=`date -d "1 hour ago" +%Y-%m-%d`
DATE1=`date +%H:%M`
DATE2=`date -d "1 hour ago" +%H:%M`
HOUR=`date -d "1 hour ago" +%H`
PSWD='elephant	'

sshpass -p $PSWD scp USERNAME@HOST:/usr/protei/MAK/logs/rtp.log /home/omni/Templates/Protei/
t1=`cat /home/omni/Templates/Protei/rtp.log | awk '/[^'226-8']...;$/{print $0}' | awk '!/;0.0[0-3];/{print $0}' | grep $DATE  | grep $HOUR:[0-5].|wc -l`
t2=`cat /home/omni/Templates/Protei/rtp.log | grep $DATE | grep $HOUR:[0-5] | wc -l`
t3=`echo $t1*100 / $t2 |bc -l`
echo " "
echo $DATE $DATE2-$DATE1 "-Время"
echo $t1 "                    -Общее количество потерь >=0.03%" 		
echo $t2 "                   -Общее количество звонков"
echo $t3 "-Процент звонков с потерями пакетов >=0.03%"
