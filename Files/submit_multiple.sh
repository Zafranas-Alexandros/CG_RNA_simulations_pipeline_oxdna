#!/bin/bash

# A Simple script to submit multiple simulations to an hpc cluster. 
# The FolderName_NucleotideNumberN, would for example correspond to a filename of 01_35N
# Change the y variables, i range, and last file name depending on the splitting of the sequence done.

# If one wants to run many simulation on a different system one can adapt the job scheduling scheme to fit said system 
# If no system is utilised one can run ./main.sh instead of qsub commands diretly

for i in {0..28}
do
    if [ $i -eq 0 ]; then
        y=35
        cd 0${i}_${y}N/working_dir/ || exit 1
        qsub submit_basic.pbs
        cd ../..
        continue
    fi

    if [ $i -lt 10 ]; then
        y=$(((i+1) * 35))  
        cd 0${i}_${y}N/working_dir/ || exit 1
        qsub submit_basic.pbs
        cd ../..
        continue
    fi

    y=$(((i+1) * 35)) 
    cd ${i}_${y}N/working_dir/ || exit 1
        qsub submit_basic.pbs
    cd ../..
done

cd 29_1058N/working_dir/
qsub submit_basic.pbs



