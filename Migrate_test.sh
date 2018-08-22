#!/bin/bash

#!!!!!!!!!!!!  Run  AS ROOT !!!!!!!!!!!!!

#!!!! Can not use $1 to input parameter, because line 61 PID0=... will return two values
#!!!! which will cause PID0 looks like: 31100    32400

BENCH_NAME=cg.C.x

PWD=`pwd`
SYS_TRACE_PATH=/sys/kernel/debug/tracing/
BENCH_PATH=`pwd`
cd $SYS_TRACE_PATH
pwd
echo "Configuring ftrace..."
#echo function >current_tracer
echo 0 >tracing_on
echo 0 >trace
echo function_graph >current_tracer
#echo function >current_tracer

echo 'SyS_migrate_pages:snapshot' > set_ftrace_filter 
echo SyS_migrate_pages >> set_ftrace_filter
  echo get_nodes >> set_ftrace_filter
  echo ptrace_may_access >> set_ftrace_filter
  echo cpuset_mems_allowed >> set_ftrace_filter
  echo capable >> set_ftrace_filter
  echo cpuset_mems_allowed >> set_ftrace_filter
  echo security_task_movememory >> set_ftrace_filter
  echo get_task_mm >> set_ftrace_filter
  echo migrate_prep >> set_ftrace_filter
  echo do_migrate_pages.part.31 >> set_ftrace_filter
    echo down_read >> set_ftrace_filter
    echo migrate_to_node >> set_ftrace_filter
      echo  queue_pages_range>> set_ftrace_filter
        echo walk_page_range >> set_ftrace_filter
      echo migrate_pages >> set_ftrace_filter
#          echo PageHuge >> set_ftrace_filter
#          echo _cond_resched >> set_ftrace_filter
          echo new_node_page >> set_ftrace_filter
          echo page_get_anon_vma >> set_ftrace_filter
#          echo page_mapped >> set_ftrace_filter
          echo try_to_unmap >>set_ftrace_filter
          echo move_to_new_page >> set_ftrace_filter
#          echo unlock_page >> set_ftrace_filter
#          echo putback_lru_page >> set_ftrace_filter
#          echo mod_node_page_state >> set_ftrace_filter
          echo __put_page >> set_ftrace_filter
          echo remove_migration_ptes >> set_ftrace_filter
            echo rmap_walk >> set_ftrace_filter
              echo try_to_unmap_one >> set_ftrace_filter
#                echo ptep_clear_flush >> set_ftrace_filter
#                  echo flush_tlb_mm_range >> set_ftrace_filter
#                    echo native_flush_tlb_others >> set_ftrace_filter
                      echo flush_tlb_func_remote >> set_ftrace_filter

echo 1000000  > per_cpu/cpu0/buffer_size_kb
echo 1 >tracing_on

echo 'schedule' > set_ftrace_notrace
echo 1 > snapshot
sleep 0.000001 
cd $BENCH_PATH

echo "Running benchmark..."
su - zhangqianlong -c "cd $BENCH_PATH;mpirun -np 22 --report-bindings  -rf rank  ./$BENCH_NAME  &>$BENCH_NAME.out &"
sleep 8 
#get pid on processor 0
PID0=`ps -aeF|grep ${BENCH_NAME}|grep -v mpirun|grep -v grep|grep " 0 "|awk '{print $2}'`
echo "processID on processor 0 is $PID0"
cat /proc/$PID0/numa_maps > maps_before_migrate

if [ ! -d $BENCH_PATH/Overhead ];then
	mkdir $BENCH_PATH/Overhead 
fi
echo "move_pages..."

if [ ! -f $BENCH_PATH/Overhead/migrate.time ];then
	touch ${BENCH_PATH}/Overhead/migrate.time
fi

{ time numactl --physcpubind=0 migratepages $PID0 0 1 ;} &>$BENCH_PATH/Overhead/migrate.time
cat /proc/$PID0/numa_maps > maps_after_migrate 

echo "Moving down, disable ftrace"
cd $SYS_TRACE_PATH
echo 0 >tracing_on


echo "Copy trace to $BENCH_PATH/Overhead/"
cp $SYS_TRACE_PATH/trace $BENCH_PATH/Overhead/$BENCH_NAME.trace











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

