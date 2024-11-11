# Load trajectory
set trajectory_file [lindex $argv 0]
mol new $trajectory_file waitfor all 

set nframes [molinfo top get numframes]
puts "Number of frames: $nframes"

set max_dist 1.2
set min_dist 0.6
set min_angle 80   ;# Minimum angle to define H-bond geometry
set max_angle 100  ;# Maximum angle to define H-bond geometry

# Open a file to write the results
set output_file [open "hbonds_output.csv" w]
puts $output_file "Frame,Atom1_ID,Atom1_Type,Atom2_ID,Atom2_Type,Distance,Angle1,Angle2"

# Function to compute the angle between two vectors
proc angle_between_vectors {vec1 vec2} {
    set dot_product [vecdot $vec1 $vec2]
    set mag1 [veclength $vec1]
    set mag2 [veclength $vec2]

    # Check for zero vectors to avoid division by zero
    if {$mag1 == 0 || $mag2 == 0} {
        return -1 ;# Return a special value to indicate an invalid angle
    }

    # Calculate the cosine of the angle
    set cos_theta [expr {$dot_product / ($mag1 * $mag2)}]

    # Clamp the value to ensure it's within the valid range for acos
    if {$cos_theta > 1} {
        set cos_theta 1
    } elseif {$cos_theta < -1} {
        set cos_theta -1
    }

    # Calculate the angle in degrees
    set theta [expr {acos($cos_theta) * 180.0 / 3.14159265}]  ;# Convert from radians to degrees
    return $theta
}

# Loop over frames
for {set i 0} {$i < $nframes} {incr i} {
    molinfo top set frame $i

    # Get all atoms in the system
    set all_atoms [atomselect top "all"]

    # Get the indices and coordinates of all atoms
    set all_indices [$all_atoms get index]
    set all_coords [$all_atoms get {x y z}]

    # Loop over all atom pairs
    foreach atom1_idx $all_indices atom1_coords $all_coords {
        foreach atom2_idx $all_indices atom2_coords $all_coords {
            if {$atom1_idx < $atom2_idx} {
                # Measure the distance between atom1 and atom2 (Vector AB)
                set dist [vecdist $atom1_coords $atom2_coords]

                # Check if distance is within the defined range
                if {$dist < $max_dist && $dist > $min_dist} {
                    # Get vectors for atom1 and atom2 neighbors (-1 and +1)
                    set atom1_minus1_idx [expr {$atom1_idx - 1}]
                    set atom1_plus1_idx [expr {$atom1_idx + 1}]
                    set atom2_minus1_idx [expr {$atom2_idx - 1}]
                    set atom2_plus1_idx [expr {$atom2_idx + 1}]

                    # Check for valid neighbors (they must be within the bounds)
                    if {($atom1_minus1_idx >= 0 && $atom1_plus1_idx < [llength $all_coords]) &&
                        ($atom2_minus1_idx >= 0 && $atom2_plus1_idx < [llength $all_coords])} {

                        # Get neighboring atom coordinates (CD and EF)
                        set atom1_minus1_coords [lindex $all_coords $atom1_minus1_idx]
                        set atom1_plus1_coords [lindex $all_coords $atom1_plus1_idx]
                        set atom2_minus1_coords [lindex $all_coords $atom2_minus1_idx]
                        set atom2_plus1_coords [lindex $all_coords $atom2_plus1_idx]

                        # Calculate vectors CD and EF
                        set vector_CD [vecsub $atom1_minus1_coords $atom1_plus1_coords]
                        set vector_EF [vecsub $atom2_minus1_coords $atom2_plus1_coords]

                        # Calculate vector AB (interaction vector between atom1 and atom2)
                        set vector_AB [vecsub $atom1_coords $atom2_coords]

                        # Calculate angles between AB-CD and AB-EF
                        set angle1 [angle_between_vectors $vector_AB $vector_CD]
                        set angle2 [angle_between_vectors $vector_AB $vector_EF]

                        # Check if both angles are within the defined range
                        if {($angle1 >= $min_angle && $angle1 <= $max_angle) && 
                            ($angle2 >= $min_angle && $angle2 <= $max_angle)} {

                            # Get nucleotide type for atom1 and atom2
                            set atom1_type [[atomselect top "index $atom1_idx"] get name]
                            set atom2_type [[atomselect top "index $atom2_idx"] get name]

                            # Write the valid hydrogen bond to the file
                            puts $output_file "$i,$atom1_idx,$atom1_type,$atom2_idx,$atom2_type,$dist,$angle1,$angle2"
                        }
                    }
                }
            }
        }
    }
}

# Close the output file
close $output_file
