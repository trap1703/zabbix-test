Тестовое задание:
Для системы мониторинга zabbix создать метрику, которая показывала бы количество строк в файле /var/log/messages (если такого файла нет, то взять /var/log/syslog). 
Метрика должна собираться с помощью внешнего скрипта и локально установленного агента zabbix. 
Ссылка на документацию: https://www.zabbix.com/documentation/current/manual/config/items/itemtypes/external
Будет плюсом, если в заббиксе появится график изменения количества строк с шагом в 30 секунд.

Результатом выполнения задачи должны стать:
1. инструкция по установке и настройке следующих частей: zabbix-agent, дополнительного скрипта, графика в zabbix
2. исходный код скрипта
=========================================

Для меня осталось не понятным требование: Метрика должна собираться с помощью внешнего скрипта и локально установленного агента zabbix.

В то время как документация по предоставленной ссылке говорит: Внешние проверки не требуют на наблюдаемом узле сети какого-либо агента.

Сделано было так:
Тестовый стенд:
1. Zabbix server - Виртуальная машина на основе zabbix appliance v4.4
2. test-host-01 - хост для мониторинга ubuntu 20.04 server
3. test-host-02 - хост для мониторинга ubuntu 20.04 server
4. test-host-03 - хост для мониторинга ubuntu 20.04 server

Шаблон с параметром и графиком создан руками (Template string log file.xml)

Создан ansible playbook zabbix-play.yaml
состоит из двух ролей
dj-wasabi.zabbix-agent (https://github.com/dj-wasabi/ansible-zabbix-agent) переработанно для данной задачи
- устанавливает zabix-agent с настройкой zabbix_conf
- добавляет хост в zabbix server
- добавляет к хосту шаблоны

copy.scrypt самодельный
- копирует файл скрипта на хост 
- добавляет пользователя zabbix в группу adm
- добавляет возможность запуска команд от пользователя zabbix без ввода пароля с повышенными правами
- перезапускает zabbix agent

скрины результата работы и файл шаблона в папке addons

В результате

1.инструкция по установке и настройке следующих частей: zabbix-agent, дополнительного скрипта, графика в zabbix
Склонировать репозиторий
добавить хосты в файл /inventories/zabbix/hosts
запустить команду выполнения 
sudo ansible-playbook zabbix-play.yaml -i inventories/zabbix/hosts -u trap -v
К хостам должен быть доступ по ssh, у пользователя должны быть права root и разрешение на выполнение команд без ввода пароля.

2.исходный код скрипта =========================================
FILE=/var/log/messages
FILE1=/var/log/syslog
if test -f "$FILE"; then
    cat "$FILE" | wc -l
else
    cat "$FILE1" | wc -l
fi


