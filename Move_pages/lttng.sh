#!/bin/bash

lttng create numa
#lttng enable-event --kernel sys_migrate_pages  --probe sys_migrate_pages+0x0
#lttng enable-event --kernel sys_migrate_pages  --syscall sys_migrate_pages

lttng enable-event --kernel sys_move_pages  --function  sys_move_pages
lttng enable-event --kernel migrate_pages  --function  migrate_pages
lttng enable-event --kernel try_to_unmap  --function  try_to_unmap
lttng enable-event --kernel move_to_new_page  --function  move_to_new_page
lttng enable-event --kernel remove_migration_ptes  --function  remove_migration_ptes
#lttng enable-event --kernel --all

#lttng enable-event --userspace  numa_migrate_pages  --function  numa_migrate_pages
#lttng enable-event --userspace  numa_move_pages  --function numa_move_pages 
#lttng enable-event --userspace  main+0x0  --function main+0x0 
lttng enable-event --userspace move_pages:numa_move_pages_tracepoint

#lttng add-context --kernel -t perf:LLC-load-misses -t perf:LLC-store-misses 
#lttng enable-event --userspace  --all
lttng add-context -s numa -u -t procname -t vtid 
lttng list numa
lttng start

#compile app using gcc -finstrument-functions options
sudo LD_PRELOAD=liblttng-ust-cyg-profile.so ./move_pages

lttng stop
lttng view
lttng destroy
