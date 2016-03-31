#!/bin/sh

HOST=`hostname`;
LOG=/tmp/inotify.log
LIST=/etc/myinotify/inotify.list

EXCLUDE=/tmp/exclude.lst

grep @ $LIST |cut -b 2- > $EXCLUDE

while [ 1 ] 
do
inotifywait -m --fromfile $LIST -r -e modify,move,create,delete -q --timefmt %F-%T --format "%T %e %w%f" --excludei '(jpg$|png$|tmp$|xml$|xml\.gz$)'|grep -v -f $EXCLUDE|tee $LOG
#grep -vi "jpg$"|grep -vi "tmp$"|grep -vi "png$" > $LOG

if [ -s $LOG ] 
then
    cat $LOG |uniq|mail -s "inotify on $HOST" security-guru@yandex.ru 
    cat $LOG |uniq>>/var/log/inotify.log
fi

done





