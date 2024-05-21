#!/bin/bash

###############################################################
#              ECE415 High Performance Computing              #
###############################################################
#                            Lab 2                            #
#                                                             #
# Project: Optimizing the performance of a K-means clustering #
#          algorithm for an aribtrary number of dimensions    #
#                                                             #
# File Description: Bash script to automatically create       #
#                   executables for all project source files, #
#                   based on varying thread numbers and       #
#                   different compilers                       #
###############################################################
# Authors: Kyritsis Spyridon     AEM: 2697                    #
#          Karaiskos Charalampos AEM: 2765                    #
###############################################################

BUILD_DIR="build"
OUTPUT_DIR="output"

TESTNUM=0

# Run all the tests #
for EXECFILE in $(find $BUILD_DIR -type f | sort)
do
  if [[ "$EXECFILE" == *".o"* ]]; then
    continue
  fi
  ## increase number of testcases ##
  TESTNUM=`expr $TESTNUM + 1`

  echo -e "\\nRunning test" $TESTNUM
  echo "Test file is" $EXECFILE

  # Build the output directory structure #
  mkdir output/$(basename $EXECFILE)

  # for THREADSNUM in 1 2 4 8
  for THREADSNUM in 1 2 4 8 16 32 64
  do
    echo -e "\\tRunning tests using" $THREADSNUM "threads"
    # echo -e "\\texport OMP_NUM_THREADS="$THREADSNUM

    export OMP_NUM_THREADS=$THREADSNUM

    if [ 10 -gt $THREADSNUM ]; then
      echo -e "Clustering time" >> $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-0"$THREADSNUM"threads.runlog"
    else
      echo -e "Clustering time" >> $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-"$THREADSNUM"threads.runlog"
    fi

    for i in {1..22}
    do
      echo -e "\\t\\tRun" $i

      if [ 10 -gt $THREADSNUM ]; then
        echo -e "\\t\\t   "$EXECFILE "-o -q -b -n 2000 -i input/texture17695.bin" ">>" $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-0"$THREADSNUM"threads.runlog"
        $EXECFILE -o -b -n 2000 -i input/texture17695.bin >> $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-0"$THREADSNUM"threads.runlog"
      else
        echo -e "\\t\\t   "$EXECFILE "-o -q -b -n 2000 -i input/texture17695.bin" ">>" $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-"$THREADSNUM"threads.runlog"
        $EXECFILE -o -b -n 2000 -i input/texture17695.bin >> $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-"$THREADSNUM"threads.runlog"
      fi

      # echo -e "\\t\\t   "$EXECFILE "-o -q -b -n 2000 -i input/texture17695.bin" ">>" $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-"$THREADSNUM"threads.runlog"
      # $EXECFILE -o -b -n 2000 -i input/texture17695.bin >> $OUTPUT_DIR/$(basename $EXECFILE)/$(basename $EXECFILE)"-"$THREADSNUM"threads.runlog"
    done
  done
done