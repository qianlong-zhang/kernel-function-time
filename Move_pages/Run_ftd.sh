#!/bin/bash
# stdbuf -o0 command > output: This buffers stdout up to line
# stdbuf -oL command > output: This disbales stdout buffering altogether
# example:
#set -x

for tr in `ls ./Overhead/*.trace`
do
	echo $tr
	#echo "stdbuf -oL setsid ftd -f Fctalsmnu $tr > ${tr}.ftd.out 2>&1"
	stdbuf -oL setsid ftd -f Fctalsmnu $tr > ${tr}.2.ftd.out 2>&1  &
done
