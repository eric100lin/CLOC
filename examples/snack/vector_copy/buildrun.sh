#!/bin/bash

#  Set HSA Environment variables
[ -z $HSA_RUNTIME_PATH ] && HSA_RUNTIME_PATH=/opt/hsa
[ -z HSA_LLVM_PATH ] && HSA_LLVM_PATH=/opt/amd/bin
export LD_LIBRARY_PATH=$HSA_RUNTIME_PATH/lib
# Compile accelerated functions
echo 
if [ -f vector_copy.o ] ; then rm vector_copy.o ; fi
echo cloc -q -c vector_copy.cl 
cloc -q -c vector_copy.cl 

# Compile Main and link to accelerated functions in vector_copy.o
echo 
if [ -f VectorCopy ] ; then rm VectorCopy ; fi
echo "g++ -o VectorCopy vector_copy.o VectorCopy.cpp -L $HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf "
g++ -o VectorCopy vector_copy.o VectorCopy.cpp -L $HSA_RUNTIME_PATH/lib -lhsa-runtime64 -lelf 

#  Execute
echo
echo ./VectorCopy
./VectorCopy
