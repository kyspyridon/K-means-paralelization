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
#                   based on varying optimization parameters  #
#                   and different compilers                   #
#                                                             #
# Authors: Kyritsis Spyridon     AEM: 2697                    #
#          Karaiskos Charalampos AEM: 2765                    #
###############################################################


SOURCE_DIR="source/"
BUILD_DIR="build/"


# CC_LIST=("gcc" "icc" "icx")
CC_LIST=("icc")


# OPT_LIST=("-O1" "-O2" "-O3" "-O4" "-fast")
OPT_LIST=("-fast")

if [[ $# -eq 1 ]]
then
  DEBUG=$1
else
  DEBUG=0
fi

TESTNUM=0

for i in ${!CC_LIST[@]}
do
  CCSTRING=${CC_LIST[i]}
  echo -e "\\nRunning tests for" $CCSTRING

  if [ $CCSTRING = "gcc" ]
  then
    LDFLAG="-fopenmp"
  else
    LDFLAG="-qopenmp"
  fi

  for j in ${!OPT_LIST[@]}
  do
    OPTSTRING=${OPT_LIST[j]}

    if [ $CCSTRING = "gcc" ] && [ $OPTSTRING = "-fast" ]
    then
      continue
    fi

    if [ $CCSTRING = "icc" ] && [ $OPTSTRING = "-O4" ]
    then
      continue
    fi

    if [ $CCSTRING = "icx" ] && [ $OPTSTRING = "-O4" ]
    then
      continue
    fi

    echo -e "\\tRunning tests with" $OPTSTRING

    for DIR in $(find $SOURCE_DIR -type d)
    do
      if [ $DIR = $SOURCE_DIR ]
      then
        continue
      fi

      ## increase number of testcases ##
      TESTNUM=`expr $TESTNUM + 1`

      echo -e "\\t   Building test:" $TESTNUM
      echo -e "\\t\\t   Test file is" $(basename $DIR)

      TESTDIR=$(basename $DIR)
      echo -e "\\t\\t   TESTDIR is" $TESTDIR

      case "-fast" in
        $OPTSTRING)
          EXECUTABLE=$TESTDIR"_"$CCSTRING"-Ofast"
          FOLDER=$TESTDIR"_"$CCSTRING"-Ofast"
          ;;

        *)
          EXECUTABLE=$TESTDIR"_"$CCSTRING$OPTSTRING
          FOLDER=$TESTDIR"_"$CCSTRING$OPTSTRING
          ;;
      esac

      mkdir $BUILD_DIR$FOLDER

      echo -e "\\t\\t   make DEBUG="$DEBUG "TEST_DIR="$TESTDIR "FOLDER="$FOLDER "CC="$CCSTRING "OFLAG="$OPTSTRING "LDFLAGS="$LDFLAG "EXECUTABLE="$EXECUTABLE"\\n"
      make DEBUG=$DEBUG TEST_DIR=$TESTDIR FOLDER=$FOLDER CC=$CCSTRING OFLAG=$OPTSTRING LDFLAGS=$LDFLAG EXECUTABLE=$EXECUTABLE
    done
  done
done
