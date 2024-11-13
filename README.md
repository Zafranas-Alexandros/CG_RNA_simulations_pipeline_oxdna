# CG_RNA_simulations_pipeline_oxdna
A simple pipeline to run and analyze simulations of RNA with Lammps or Oxdna utilising the OxRNA2 model.


## Running the Simulations

- Step 1: Split the sequence. In the SPLITSEQ folder, there exists a script, which utilising as input a one-line seuence of RNA in a .seq file, produces .txt files containing the sequence split in fragments.
- Step 2: Configure the input files. Before running the main script to execute the simulations, make sure to parameterize the input files according to the simulation goals. More information on Input files for Oxdna can be found [here](https://lorenzo-rovigatti.github.io/oxDNA/input.html), while for Lammps can be found [here](https://docs.lammps.org/Commands_input.html).
- Step 3: Generate the starting structure and set up the directories. From the .txt files containing the sequence, initial oxdna-format structure files can be produced. Internally, there exists a python script to do so, however for sequence lengths larger than 60 Nucleotides, the script can't be used. Externally, the topology can be built using [OxView](https://sulcgroup.github.io/oxdna-viewer/). Having the intial oxdna topologies, copy the FolderName_NucleotideNumberN folder as many times as there are fragments - simulations to be run - and place the starting topologies in each working directory. Be careful to name the starting topologies oxdna - or change the filename in the main.sh script. 
- Step 4: Run the simulations. Parameterize and execute main.sh script. In order to run simulations in bulk, submit_multiple.sh script can be used.


## Analysing the simulations

- Step 1: Run the .tcl script and produce the .dat file(s). To run the .tcl script, VMD is used in text mode - to perform this, the teminal command template is provided in the Analysis folder.
- Step 2: Run the corresponding Jupyter Notebook.


### Required Software - Dependencies

- Python (3.11.2 was used, however any python 3 version should work. If python is used to produce starting topologies, python 2 is necessary.)
- VMD (1.9.3 was used, any later version should work.)
- Lammps (2Aug2023 - Update 3 was used. When compiling Lammps, make sure to incorporate CG-DNA and prerequisite packages.)
- Oxdna


