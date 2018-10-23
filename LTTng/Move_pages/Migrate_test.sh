#!/bin/bash
set -x
#set -e

#!!!!!!!!!!!!  Run  AS ROOT !!!!!!!!!!!!!
BENCH_NAME=move_pages
INPUT=

PWD=`pwd`
SYS_TRACE_PATH=/sys/kernel/debug/tracing/
BENCH_PATH=`pwd`
#cd $BENCH_PATH;
if [ ! -d $BENCH_PATH/Overhead ];then
	mkdir $BENCH_PATH/Overhead 
fi

cd $SYS_TRACE_PATH
pwd
echo "reset ftrace..."
trace-cmd reset
echo 0 > trace
echo 0 > tracing_on
echo 1 > /proc/sys/kernel/ftrace_enabled
echo function_graph > current_tracer
#echo ffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff > tracing_cpumask 

echo "config set_ftrace_filter..."
#echo 1 > snapshot
#echo  > set_ftrace_filter
#echo function >current_tracer

echo 'schedule' > set_ftrace_notrace
echo 'SyS_move_pages:snapshot' > set_ftrace_filter 
echo SyS_move_pages > set_ftrace_filter
##  echo security_task_movememory >> set_ftrace_filter
##  echo cpuset_mems_allowed >> set_ftrace_filter
##  echo get_task_mm >> set_ftrace_filter
    echo migrate_pages >> set_ftrace_filter
##	echo PageHuge >> set_ftrace_filter
##	echo _cond_resched >> set_ftrace_filter
##	echo new_node_page >> set_ftrace_filter
##	echo page_get_anon_vma >> set_ftrace_filter
##	echo page_mapped >> set_ftrace_filter
	echo try_to_unmap >>set_ftrace_filter
	echo move_to_new_page >> set_ftrace_filter
##	echo unlock_page >> set_ftrace_filter
##	echo putback_lru_page >> set_ftrace_filter
##	echo mod_node_page_state >> set_ftrace_filter
##	echo __put_page >> set_ftrace_filter
	echo remove_migration_ptes >> set_ftrace_filter
           echo remove_migration_pte >> set_ftrace_filter
           echo rmap_walk >> set_ftrace_filter
#		   echo page_lock_anon_vma_read >> set_ftrace_filter
           echo rmap_walk_anon >> set_ftrace_filter
#		   echo PageHeadHuge >> set_ftrace_filter
#		   echo invalid_migration_vma >> set_ftrace_filter
##		   echo set_page_dirty >> set_ftrace_filter
		   echo page_remove_rmap >> set_ftrace_filter
##			echo page_mapcount_is_zero >> set_ftrace_filter
##                 echo flush_tlb_mm_range >> set_ftrace_filter
##                    echo flush_tlb_func_remote >> set_ftrace_filter
		   echo try_to_unmap_one >> set_ftrace_filter
           echo ptep_clear_flush >> set_ftrace_filter
##		   echo native_flush_tlb_global   >> set_ftrace_filter               
##		   echo native_flush_tlb_one_user >> set_ftrace_filter
#		   echo native_flush_tlb          >> set_ftrace_filter
#		   echo do_flush_tlb_all	  >> set_ftrace_filter
##		   echo flush_tlb_func_common.constprop.11 >> set_ftrace_filter
#		   echo native_flush_tlb_others    >> set_ftrace_filter  #IPI
##		   echo flush_tlb_all             >> set_ftrace_filter
##		   echo flush_tlb_kernel_range    >> set_ftrace_filter
##		   echo flush_tlb_batched_pending >> set_ftrace_filter
		   echo page_vma_mapped_walk >> set_ftrace_filter
		   echo page_vma_mapped_in_vma >> set_ftrace_filter
		   echo page_vma_mapped_walk_done >> set_ftrace_filter
		   echo page_add_anon_rmap >> set_ftrace_filter

#echo 'SyS_migrate_pages:snapshot' > set_ftrace_filter 
#echo SyS_migrate_pages >> set_ftrace_filter
#  echo get_nodes >> set_ftrace_filter
#  echo ptrace_may_access >> set_ftrace_filter
#  echo cpuset_mems_allowed >> set_ftrace_filter
#  echo capable >> set_ftrace_filter
#  echo security_task_movememory >> set_ftrace_filter
#  echo get_task_mm >> set_ftrace_filter
#  echo migrate_prep >> set_ftrace_filter
#  echo do_migrate_pages.part.31 >> set_ftrace_filter
#    echo down_read >> set_ftrace_filter
#    echo migrate_to_node >> set_ftrace_filter
#      echo  queue_pages_range>> set_ftrace_filter
#        echo walk_page_range >> set_ftrace_filter
#     echo migrate_pages >> set_ftrace_filter
#          echo PageHuge >> set_ftrace_filter
##          echo _cond_resched >> set_ftrace_filter
#         echo new_node_page >> set_ftrace_filter
#         echo page_get_anon_vma >> set_ftrace_filter
#          echo page_mapped >> set_ftrace_filter
#         echo try_to_unmap >>set_ftrace_filter
#         echo move_to_new_page >> set_ftrace_filter
#          echo unlock_page >> set_ftrace_filter
#          echo putback_lru_page >> set_ftrace_filter
#          echo mod_node_page_state >> set_ftrace_filter
#          echo __put_page >> set_ftrace_filter
#         echo remove_migration_ptes >> set_ftrace_filter
#           echo remove_migration_pte >> set_ftrace_filter
#           echo rmap_walk >> set_ftrace_filter
#		   echo page_lock_anon_vma_read >> set_ftrace_filter
#           echo rmap_walk_anon >> set_ftrace_filter
#		   echo PageHeadHuge >> set_ftrace_filter
#		   echo invalid_migration_vma >> set_ftrace_filter
#		   echo set_page_dirty >> set_ftrace_filter
#		   echo page_remove_rmap >> set_ftrace_filter
#			echo page_mapcount_is_zero >> set_ftrace_filter
#             echo try_to_unmap_one >> set_ftrace_filter
#                echo ptep_clear_flush >> set_ftrace_filter
#                  echo flush_tlb_mm_range >> set_ftrace_filter
#                    echo native_flush_tlb_others >> set_ftrace_filter
#                      echo flush_tlb_func_remote >> set_ftrace_filter
#

#echo 1000000  > per_cpu/cpu0/buffer_size_kb
#echo 1000000  > buffer_size_kb


echo "Running benchmark..."
#for i in 1 4 8 16 32 64
for i in 1 
do
	echo 1 >tracing_on
	#echo 1 > events/tlb/tlb_flush/enable
	sleep 0.000001 
	#echo  > set_ftrace_pid

	cd $BENCH_PATH;
	{ time numactl --physcpubind=2 ./$BENCH_NAME  $INPUT  &>$BENCH_PATH/Overhead/${BENCH_NAME}-${i}.out; } &>$BENCH_PATH/Overhead/${BENCH_NAME}-${i}_migrate.time
	#{ time numactl --membind=0 ./$BENCH_NAME  $INPUT  &>$BENCH_PATH/Overhead/${BENCH_NAME}-${i}.out; } &>$BENCH_PATH/Overhead/${BENCH_NAME}-${i}_migrate.time


	echo "Copy trace to $BENCH_PATH/Overhead/"
	cp $SYS_TRACE_PATH/trace $BENCH_PATH/Overhead/${BENCH_NAME}-${i}.trace

	cd $SYS_TRACE_PATH
	echo 0 > tracing_on
	echo 0 > trace
	#echo 0 > events/tlb/tlb_flush/enable


done















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



