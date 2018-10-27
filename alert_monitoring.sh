#!/bin/bash

EXL_DB="ASM" 

for ORACLE_SID in $( ps -ef|grep pmon|grep -v grep|egrep -v ${EXL_DB}|awk '{print $NF}'|sed -e 's/ora_pmon_//g'|grep -v sed|grep -v "s///g" )
   do
    export ORACLE_SID
    ORACLE_HOME=$(cat /etc/oratab | grep $ORACLE_SID | cut -f2 -d ':')
 
export ORACLE_HOME
LOG_DIR=$(${ORACLE_HOME}/bin/sqlplus -S "/ as sysdba" <<EOF
set pages 0 feedback off lines 30000;
prompt
SELECT value from v\$diag_info where NAME='Diag Trace';
exit;
EOF
)

LINE_COUNT_OLD=0

while true
do	
	LINE_COUNT=`wc -l $LOG_DIR/alert_orcl.log | awk '{print $1}'`
	DIFF=$((LINE_COUNT - LINE_COUNT_OLD))
	if [ $DIFF -ne '0' ] && [ $LINE_COUNT_OLD -ne '0' ]
	then
		COUNT=0
		COUNT=`tail -$DIFF $LOG_DIR/alert_orcl.log|grep 'ORA-'|wc -l`
		if [ $COUNT -ne '0' ]
		then
			sed -n "$LINE_COUNT_OLD, $LINE_COUNT p" $LOG_DIR/alert_orcl.log > $LOG_DIR/alert_orcl_tmp.log
			date >> $LOG_DIR/alert_orcl_tmp.log
			cp $LOG_DIR/alert_orcl_tmp.log  $LOG_DIR/alert_orcl_email.log
			
		fi
	fi
	sleep 5
	LINE_COUNT_OLD=$LINE_COUNT
	rm -f $LOG_DIR/alert_orcl_tmp.log 
done

done