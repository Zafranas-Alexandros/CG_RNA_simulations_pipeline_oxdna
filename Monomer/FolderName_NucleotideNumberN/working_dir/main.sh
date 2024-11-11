#!/bin/bash

VAR=70

############################### IF NEEDED TO PRODUCE THE STARTING STRUCTURE ########################################
##set up conda functionality locally for this script
#eval "$(conda shell.bash hook)"

##activate the environment with needed python version - 2.7 here  . replace pytho2 with your environment's name 
#conda activate pytho2

## wait for the env to activate
#wait

##generate initial RNA structure in oxdna format
#./../Dependencies_and_scripts_python/oxDNA/generate-RNA.py first_${VAR}_STMV_Ns.txt oxdna 20.0
#####################################################################################################################


################################## SETTING UP THE SYSTEM FOR SIMULATION ############################################
#run minimization with OxDNA
~/usr/src/oxDNA/build/bin/oxDNA_mpi ./../input_scripts/OxDNA_input_min
wait

# OPTIONAL (best if not done when there's a partially folded part in the Starting structure)
#run relaxation with OxDNA
~/usr/src/oxDNA/build/bin/oxDNA_mpi ./../input_scripts/OxDNA_input_relax
wait
#####################################################################################################################


############################################### CONVERT TO LAMMPS ###################################################
# convert to lammps format from the output of the relaxation with tacoxdna - python3
python3 ./../Dependencies_and_scripts_python/tacoxdna/oxDNA_LAMMPS.py oxdna.top mpi_0_last_conf_relax.dat

#rename lammps data file for ease of use
mv mpi_0_last_conf_relax.dat.lammps First${VAR}N_STMV.lammps

#configure the lammps input script to correspond to the correct length of polynucleotide being simulated
sed -i "4s/.*/variable number equal ${VAR}/" ./../input_scripts/input.lammps
#####################################################################################################################


############################################ SIMULATION WITH LAMMPS #################################################
# run the simulation using lammps
lmp -in ./../input_scripts/input.lammps
#####################################################################################################################


############################################ SIMULATION WITH OXDNA ###################################################
## Extract the three float numbers from the fourth line of the source file
#coords=$(sed -n '4p' last_conf_relax.dat | awk '{print $1", "$2", "$3}')

## Write the extracted coordinates in the desired format to the fourth line of the target file
#sed -i "4s/.*/pos0 = $coords/" external_forces.txt

## run the simulation using oxdna
#oxDNA_mpi ./../input_scripts/OxDNA_input_simulation
#####################################################################################################################


