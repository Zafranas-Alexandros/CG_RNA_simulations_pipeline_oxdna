# CG_RNA_simulations_pipeline_oxdna
A simple pipeline to run and analyze simulations of RNA with Lammps or Oxdna utilising the OxRNA2 model.


## Running the Simulations

- Step 1: Split the sequence. In the SPLITSEQ folder, there exists a script, which utilising as input a one-line seuence of RNA in a .seq file, produces .txt files containig the sequence fragments.
- Step 2: Generate the starting structure and set up the directories. From the .txt files containing the sequence, initial oxdna-format structure files can be produced. Internally, there exists a python script to do so, however for sequence lengths larger than 20 Nucleotides, the script can't be used. Externally the topology can be built using [OxView](https://sulcgroup.github.io/oxdna-viewer/).
- Step 3: Configure the input files.
- Step 4: Run the simulations.


## Analysing the simulations

- Step 1: Run the .tcl script and produce the .dat file(s).
- Step 2: Run the corresponding Jupyter Notebook.


### Required Software - Dependencies

- Python (3.11.2)
- VMD
- Lammps 
- oxdna


