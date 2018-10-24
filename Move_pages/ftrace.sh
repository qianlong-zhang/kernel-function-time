#!/bin/bash

SYS_TRACE_PATH=/sys/kernel/debug/tracing/
BENCH_PATH=`pwd`

cd $SYS_TRACE_PATH
pwd
echo function_graph >current_tracer
#echo function >current_tracer

#echo SyS_move_pages >> set_ftrace_filter
#  echo security_task_movememory >> set_ftrace_filter
#  echo cpuset_mems_allowed >> set_ftrace_filter
#  echo get_task_mm >> set_ftrace_filter
#    echo migrate_pages >> set_ftrace_filter
#	echo PageHuge >> set_ftrace_filter
#	#echo _cond_resched >> set_ftrace_filter
#	echo new_node_page >> set_ftrace_filter
#	echo page_get_anon_vma >> set_ftrace_filter
#	echo page_mapped >> set_ftrace_filter
#       echo try_to_unmap >>set_ftrace_filter
#	echo move_to_new_page >> set_ftrace_filter
#	echo unlock_page >> set_ftrace_filter
#	echo putback_lru_page >> set_ftrace_filter
#	echo mod_node_page_state >> set_ftrace_filter
#	echo __put_page >> set_ftrace_filter
#	echo remove_migration_ptes >> set_ftrace_filter
#       echo rmap_walk >> set_ftrace_filter
#         echo try_to_unmap_one >> set_ftrace_filter
#           echo ptep_clear_flush >> set_ftrace_filter
#      	echo flush_tlb_mm_range >> set_ftrace_filter
#                echo native_flush_tlb_others >> set_ftrace_filter
#                  echo flush_tlb_func_remote >> set_ftrace_filter

echo 0 >tracing_on
echo 0 >trace
echo 1000000  > per_cpu/cpu0/buffer_size_kb


echo 1 >tracing_on
echo 'SyS_move_pages:snapshot' >> set_ftrace_filter 
echo 1 > snapshot
sleep 0.000001 
cd $BENCH_PATH
echo "move_pages..."
{ time taskset 0x00000001 ./move_pages; } &> $BENCH_PATH/OverHead/time.temp
sleep 0.000001
cd $SYS_TRACE_PATH
echo 0 >tracing_on

echo "copy trace to my_trace..."
#cat $SYS_TRACE_PATH/trace >> $BENCH_PATH/OverHead/my_trace
cp $SYS_TRACE_PATH/trace $BENCH_PATH/OverHead/
