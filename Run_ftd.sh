#!/bin/bash
# stdbuf -o0 command > output: This buffers stdout up to line
# stdbuf -oL command > output: This disbales stdout buffering altogether
# example:
stdbuf -oL setsid ftd -f Fctalsmnu cg.C.x.trace > output 2>&1
