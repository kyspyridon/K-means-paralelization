# K-means Paralelization

The goal of this project is to optimize a given implementation of the K-means clustering algorithm by parallelizing it using OpenMP.

K-means clustering is a method of vector quantization, originally from signal processing, that aims to partition n observations into k clusters in which each observation belongs to the cluster with the nearest mean (cluster centers or cluster centroid), serving as a prototype of the cluster. k-means clustering minimizes within-cluster variances (squared Euclidean distances).

This project was developed as a Lab assignment for the "ECE415 High Performance Computing" course, in the University of Thessaly, in collaboration with Charalampos Karaiskos, over the course of a week. Our development was based on the requirements set by [Lab2.pdf](https://github.com/kyspyridon/K-means-paralelization/blob/main/Lab2.pdf).
As per the assignment’s requirements all our tests were performed using the Intel compiler icc.

# Naming Convention
All source file directories follow a specific naming convention. A number indicating the order in which the optimizations were performed during the projects development, followed by the name of the optimization itself meaning that each test builds on top of each predecessor. All optimisations were performed in an additive manner, with each test building on the previous ones.​ The results showed performance improvements for each optimisation. ​

Our full work can be seen in the report file [report.pdf](https://github.com/kyspyridon/K-means-paralelization/blob/main/report.pdf). Our numerical results can be viewed in detail in [results.xlsx](https://github.com/kyspyridon/K-means-paralelization/blob/main/results.xlsx).

# Target Hardware
All experiments were performed in the same machine, a server with the following specs:
- Intel Xeon E5-2683 v4 CPUs clocked at 2.10GHz
- Each CPU has 16 cores and both CPUs are 2-way hyperthreaded, thus totaling 64 logical cores
- 128 GBs of RAM
- Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-126-generic x86_64)

# Tool API
A scripting suite was developed to help streamline the experimental process. This consisted of several Bash and Python scripts. These are available as makefile commands for ease of use. Detailed descriptions for all the commands below can be found in [here](https://github.com/kyspyridon/K-means-paralelization/blob/main/results.xlsx).

The scripting suite is an expansion of the one described [here](https://github.com/kyspyridon/Sobel_filter_optimisation/blob/main/report.pdf). The suite now can handle different compilers and optimization levels as input and appends them as a suffix to the created directory in the build directory. 

Here is the list of available commands:
```sh
make clean
make all
make run
make excel
```

At the top of [run_make.sh](https://github.com/kyspyridon/Sobel_filter_optimisation/blob/main/run_make.sh) we can can find a list of all supported compilers and optimisation levels.  

Use ```make all``` to build the executables under the build/ directory and ```make run``` to perform the tests. Each test is performed 22 times for 1, 2, 4, 8, 18, 32 and 64 threads. ```make excel``` discards the best and worst performances as outliers and creates an Excel spreadsheet by parsing the results under the output/ directory.

In this repository we included our results from the tests used to create [results.xlsx](https://github.com/kyspyridon/K-means-paralelization/blob/main/results.xlsx).

# Notes
The scripting suite was developed using Python 3.9 and Bash. Certain make commands require the installations of a few packages.

For the full suite to run:
```sh
apt-get install python3.9
pip install openpyxl
pip install pandas
```
