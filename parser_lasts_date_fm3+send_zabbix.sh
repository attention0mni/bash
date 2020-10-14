#!/bin/bash
cookie=$HOME/fort-cookie.tmp
#открытие сессии с сохранением куки
curl -X GET --header 'Accept: application/json' 'http://HOST/api/integration/v1/connect?login=LOGIN&password=PASSWORD&lang=ru-ru&timezone=%2B3' -c $cookie

#функция для доставания времени последней отправки данных и названия объекта.
get_data ()
{
#	name=`curl http://HOST/api/integration/v1/fullobjinfo?oid=$uid -b $cookie |
#	awk -F'"' '{print $6}'`
	ltime=`curl http://HOST/api/integration/v1/fullobjinfo?oid=$uid -b $cookie |
	awk -F'"' '{print $16}'`
}

#решил написать цикл именно так для простоты добавления\удаления новых машин (просто либо стираем uid, либо дописываем новый)
#uid можно посмотреть прямо в вебморде форта. Нажимаем на машину и слева вместе с прочей информацией о машине в самом низу будет uid.
for uid in 1 2 3 4 5 6 7 8
do
	get_data;
	#приводим все даты к секундам для сравнения
	ltime_s=`date --date="$ltime" +"%s"`
	time_now_s=`date "+%s"`
	time_diff_s=$[ ($time_now_s - $ltime_s - 10800) ] #форт выдает время не +3, поэтому вычитаем еще и разницу в 3 часа.
	#сравниваем дату последней отправки данных (из функции get_data) и текущую, если разница больше 300 секунд
	#то шлем в заббикс "2", если меньше то 0. uid - ключ элемента данных.
	if [ $time_diff_s -le 300 ]; then
		#echo 0 $name $ltime
		zabbix_sender -z ZABBIX_HOST -s FortMonitor -k $uid -o 0 
		#else echo 2 $name $ltime
		else zabbix_sender -z ZABBIX_HOST -s FortMonitor -k $uid -o 2
	fi
done

#закрыть сессию
curl -X GET --header 'Accept: application/json' 'http://HOST/api/integration/v1/disconnect' -b $cookie
#удаляем файлик с куками
rm -f $cookie
