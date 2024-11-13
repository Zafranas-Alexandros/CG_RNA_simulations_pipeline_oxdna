# Load the trajectory file provided as an argument
set trajectory_file [lindex $argv 0]
mol new $trajectory_file waitfor all 

# Get the number of frames in the trajectory
set n_frames [molinfo top get numframes]

# Create atom selection for all atoms in the system
set all_atoms [atomselect top "all"]

# Open file to write the RMSD matrix
set outfile [open "rmsd_matrix.txt" w]

# Set the interval to analyze every 10th frame
set frame_interval 10

# Loop through each pair of frames to calculate RMSD
for {set i 0} {$i < $n_frames} {incr i $frame_interval} {
    set row [list] ;# Initialize a list for the current row (i-th frame)
    
    # Select atoms in frame i
    set ref_i [atomselect top "all" frame $i]
    
    for {set j 0} {$j <= $i} {incr j $frame_interval} {

        # Select atoms in frame j
        set ref_j [atomselect top "all" frame $j]
        
        # Check if i and j are the same frame to avoid unnecessary comparison
        if {$i == $j} {
            set rmsd 0.0
        } else {
            # Calculate RMSD between frame i and frame j
            set rmsd [measure rmsd $ref_i $ref_j]
        }
        
        # Store the RMSD value in the row
        lappend row $rmsd

        # Delete the selection for frame j to free memory
        $ref_j delete


    }

    # Write the current row to the output file
    puts $outfile [join $row " "]
    
    # Delete the selection for frame i to free memory
    $ref_i delete

    # Optional: Print progress for long runs
    puts "Completed frame $i out of $n_frames"
}

# Close the output file
close $outfile

# Print completion message
puts "RMSD calculation completed and written to rmsd_matrix.txt"


