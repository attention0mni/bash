#!/bin/sh
#делает цсвху из замеров спидтеста + шлет в заббикс. домру замеряет 3 раза
t=$(date +%m-%d%t%H:%M)
time=$(date +%H:%M)
date=$(date +%m-%d)
path="/home/gts/speedtest"
mkdir $path/$date/
zserv='ipserv'

#в s1, s2, s3 вставляем id серверов (s1 будет замерятся 3 раза подряд)
s1='2702'
s2='17014'
s3='17813'

s1=`speedtest --format=csv --server-id=$s1`
s2=`speedtest --format=csv --server-id=$s2`
s3=`speedtest --format=csv --server-id=$s3`

s6=`echo $s1|awk -F '"' '{print $12}'`
s7=`echo $s2|awk -F '"' '{print $12}'`
s8=`echo $s3|awk -F '"' '{print $12}'`

echo $s1,$s2,$s3 | awk -F '"' -v t="$t" '{print $2";", $12*0.000008";", $14*0.000008";", $22";", $32*0.000008";", $34*0.000008";", $42";", $52*0.000008";", $54*0.000008";", t}' | tr . , >> $path/all_result/new_all.csv
echo $s1,$s2,$s3 | awk -F '"' -v t="$t" '{print $2";", $12*0.000008";", $14*0.000008";", $22";", $32*0.000008";", $34*0.000008";", $42";", $52*0.000008";", $54*0.000008";", t}' | tr . , >> $path/$date/all.csv
echo $s1 | awk -F '"' -v t="$t" '{print $2";", $12*0.000008";", $14*0.000008";", t";"}' | tr . , >> $path/$date/domru.csv
echo $s2 | awk -F '"' -v t="$t" '{print $2";", $12*0.000008";", $14*0.000008";", t";"}' | tr . , >> $path/$date/izhevsk.csv
echo $s3 | awk -F '"' -v t="$t" '{print $2";", $12*0.000008";", $14*0.000008";", t";"}' | tr . , >> $path/$date/glazov.csv

#отправка змеров с 3х серверов
zabbix_sender -z $zserv -s 22244 -k domru -o $s6
zabbix_sender -z $zserv -s 22244 -k mts -o $s7
zabbix_sender -z $zserv -s 22244 -k glazov -o $s8

#отправка 3х замеров подрят
zabbix_sender -z $zserv -s 22244 -k testing -o $s6
s11=`speedtest --format=csv --server-id=$s1 | awk -F '"' '{print $12}'`; zabbix_sender -z $zserv -s 22244 -k testing -o $s11
s12=`speedtest --format=csv --server-id=$s1 | awk -F '"' '{print $12}'`; zabbix_sender -z $zserv -s 22244 -k testing -o $s12
