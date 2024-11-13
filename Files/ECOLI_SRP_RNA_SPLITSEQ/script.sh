#!/bin/bash

#A simple script to split a .seq file to fragments of specific length

# Define the input file containing the string
input_file="Ecoli_4.5S_SRP_RNA.seq"

# Read the input string from the file
input_string=$(<"$input_file")

# Define the directory to store the output files
output_dir="output_files_3"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop to create 10 files with increasing lengths
for i in {1..3}; do
    # Define the output file name
    output_file="$output_dir/first_$((38*i))_STMV_Ns.txt"
    
    # Calculate the number of characters to include
    num_chars=$((38 * i))
    
    # Extract the substring from the input string
    substring="${input_string:0:num_chars}"
    
    # Write the substring to the output file
    echo "$substring" > "$output_file"
done

#Manually insert the last characters of the original string to the last file,
# if the original string's length isn't perfectly divisible in the for-loop.
