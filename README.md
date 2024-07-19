# Improving Processor Fuzzing through Dependency-aware Control Flow Analysis in Flattened Design

## Introduction
This project aims to enhance processor fuzzing by extracting control flow graphs (CFGs) from flattened processor designs and analyzing the dependencies of branch statements within these graphs. Experimental results demonstrate the effectiveness of utilizing control flow information derived from flattened designs in enhancing the convergence speed of coverage metrics and guiding test sequences towards hard-to-reach states.

## Features
- **Flattened RTL Design**: Simplifies dependency analysis and helps identify critical test areas by flattening the target processor RTL design.
- **Dependency Analysis**: Performs dependency-aware control flow analysis to extract the dependencies of basic blocks (BBs) and build a control flow graph (CFG).
- **Optimized Test Generation**: Integrates an input evaluation and selection algorithm to continuously optimize the test corpus for improved functional coverage.
- **Proven Effectiveness**: Demonstrates superior functional coverage on complex processor designs compared to traditional methods.

## Framework
The framework consists of three main parts:
1. **RTL Flattening**: Converts hierarchical RTL models into a flattened structure to simplify subsequent analysis. (Benchmark/Verilog/xxx_CFG.v)
2. **Static Analysis**: Extracts dependency relationships of basic blocks (BBs) by constructing a control flow graph (CFG). (CFG/xxx.txt & CFG/xxx.pkl)
3. **Fuzzing Loop**: Integrates these dependency relationships into a traditional fuzzing loop to guide and optimize directed test generation. 

## Directory Structure

Fuzz_RTL
├── Benchmarks
├── CFG
├── firrtl
├── Fuzzer
├── script
├── spike
├── .gitignore
├── .gitmodules
├── docker_cmd
├── LICENSE
├── README.md
├── run_docker.sh
├── start_fuzzing_boom.sh
└── start_fuzzing_rocket.sh

## Command

./start_fuzzing_boom.sh 0 10000 > log/boom_1000_Explr_Alt2.log 2>&1 &
./start_fuzzing_rocket.sh 0 10000 > log2/rocket3.log 2>&1 &