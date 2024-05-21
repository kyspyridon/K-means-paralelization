###############################################################
#              ECE415 High Performance Computing              #
###############################################################
#                            Lab 2                            #
#                                                             #
# Project: Optimizing the performance of a K-means clustering #
#          algorithm for an aribtrary number of dimensions    #
#                                                             #
# File Description: Makefile to be called through the 				#
#										run_make.sh script. It produces an 				#
#  							 		executable file depending on a varying 		#
# 									set of optimization parameters. It is   	#
# 									important that the Makefile is inside the #
# 									sources subdirectory to function properly #
###############################################################
# Source Code Author: Wei-keng Liao                           #
#             ECE Department Northwestern University          #
#             email: wkliao@ece.northwestern.edu              #
#                                                             #
#    Copyright (C) 2005, Northwestern University              #
#    See COPYRIGHT notice in top-level directory.             #
###############################################################
# Authors: Kyritsis Spyridon     AEM: 2697                    #
#          Karaiskos Charalampos AEM: 2765                    #
###############################################################

# All parameters have default values in case the make is called #
# in standalone form i.e. not from the run_make.sh script 			#
# In case the Makefile is called from the run_make.sh script 		#
# the default parameters are overriden by the script's ones 		#

# Directory Variables
INPUT_DIR=input
SOURCE_DIR=source
BUILD_DIR=build
OUTPUT_DIR=output
TEST_DIR=
FOLDER=

# This is the compiler to use
CC=icc

# These are the flags passed to the compiler. Change accordingly
DFLAG=-DNDEBUG # Debug flag
CFLAGS=-Wall -diag-disable=10441
OFLAG=-O0

# These are the flags passed to the linker. Nothing in our case
LDFLAGS=-qopenmp

DEBUG=0
ifeq ($(DEBUG), 1)
	DFLAG=-g
endif

FULL_SOURCE_DIR=$(SOURCE_DIR)/$(TEST_DIR)
FULL_BUILD_DIR=$(BUILD_DIR)/$(FOLDER)

H_FILES = $(FULL_SOURCE_DIR)/kmeans.h

COMM_SRC = $(FULL_SOURCE_DIR)/file_io.c $(FULL_SOURCE_DIR)/util.c
COMM_OBJ = $(FULL_BUILD_DIR)/file_io.o $(FULL_BUILD_DIR)/util.o

SEQ_SRC = $(FULL_SOURCE_DIR)/seq_main.c $(FULL_SOURCE_DIR)/seq_kmeans.c $(FULL_SOURCE_DIR)/wtime.c
SEQ_OBJ = $(FULL_BUILD_DIR)/seq_main.o $(FULL_BUILD_DIR)/seq_kmeans.o $(FULL_BUILD_DIR)/wtime.o

$(FULL_BUILD_DIR)/$(EXECUTABLE): $(SEQ_OBJ) $(COMM_OBJ) $(H_FILES)
	$(CC) $(CFLAGS) $(DFLAG) $(OFLAG) $(LDFLAGS) $(SEQ_OBJ) $(COMM_OBJ) -o $@

$(FULL_BUILD_DIR)/util.o: $(FULL_SOURCE_DIR)/util.c
	$(CC) $(CFLAGS) $(DFLAG) $(OFLAG) $(LDFLAGS) -c $< -o $@

$(FULL_BUILD_DIR)/file_io.o: $(FULL_SOURCE_DIR)/file_io.c
	$(CC) $(CFLAGS) $(DFLAG) $(OFLAG) $(LDFLAGS) -c $< -o $@

$(FULL_BUILD_DIR)/wtime.o: $(FULL_SOURCE_DIR)/wtime.c
	$(CC) $(CFLAGS) $(DFLAG) $(OFLAG) $(LDFLAGS) -c $< -o $@

$(FULL_BUILD_DIR)/seq_kmeans.o: $(FULL_SOURCE_DIR)/seq_kmeans.c $(H_FILES)
	$(CC) $(CFLAGS) $(DFLAG) $(OFLAG) $(LDFLAGS) -c $< -o $@

$(FULL_BUILD_DIR)/seq_main.o: $(FULL_SOURCE_DIR)/seq_main.c $(H_FILES)
	$(CC) $(CFLAGS) $(DFLAG) $(OFLAG) $(LDFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)/*
	rm -rf $(OUTPUT_DIR)/*

all:
	time ./run_make.sh

run:
	time ./run_script.sh

excel:
	python csv_to_Excel.py source/ build/ output/
