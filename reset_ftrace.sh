#!/bin/bash
#run as root

set -x
SYS_FTRACE_PATH=/sys/kernel/debug/tracing

cd $SYS_FTRACE_PATH
trace-cmd reset
#echo ffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff > tracing_cpumask 
echo ff > tracing_cpumask 
echo 0 > trace
echo 0 > tracing_on
echo 1 > /proc/sys/kernel/ftrace_enabled
echo function_graph > current_tracer
#echo  > set_ftrace_filter
echo 1 > tracing_on 
sleep 3 

echo 0 >tracing_on
