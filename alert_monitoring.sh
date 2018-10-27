#!/bin/bash

export ORACLE_SID=orcl
export ORACLE_BASE=/u01/app/oracle
export LOG_DIR=$ORACLE_BASE/diag/rdbms/$ORACLE_SID/$ORACLE_SID/trace

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
