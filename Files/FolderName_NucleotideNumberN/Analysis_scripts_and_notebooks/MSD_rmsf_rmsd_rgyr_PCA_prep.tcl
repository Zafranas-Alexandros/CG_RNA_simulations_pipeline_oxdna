#------------------------------LOAD TRAJ.-----------------------------------------
set trajectory_file [lindex $argv 0]

mol new $trajectory_file waitfor all 


#------------------------------COMMON VARIABLES------------------------------------

set nf [molinfo top get numframes]
set ref_0 [atomselect top "all" frame 0]
set all [atomselect top "all"]
set ref [atomselect top "all"]

#-------------------------------MSD-----------------------------------------------


set output_file [open "MSD.dat" w]
set miden [measure center $ref_0]

set x_0 [lindex $miden 0]
set y_0 [lindex $miden 1]
set z_0 [lindex $miden 2]

for {set f 0 } {$f < $nf} {incr f} {
    set ref [atomselect top "all" frame $f]
    set twra [measure center $ref]

    set x_t [lindex $twra 0]
    set y_t [lindex $twra 1]
    set z_t [lindex $twra 2]

    set diafora_x [expr {$x_t - $x_0}]
    set diafora_y [expr {$y_t - $y_0}]
    set diafora_z [expr {$z_t - $z_0}]

    set diafora_x_sq [expr {$diafora_x * $diafora_x}]
    set diafora_y_sq [expr {$diafora_y * $diafora_y}]
    set diafora_z_sq [expr {$diafora_z * $diafora_z}]

    set msd [expr {$diafora_x_sq + $diafora_y_sq + $diafora_z_sq}]

    puts $output_file $f\t$msd
}

close $output_file

#-------------------------------RMSF--------------------------------------------

set output_file [open "rmsf.dat" w]
for {set f 0 } {$f < $nf} {incr f} {
    $ref frame $f
    $all frame $f
    set M [measure fit $ref $ref_0]
    $all move $M
}

set rmsf [measure rmsf $all]
puts $output_file $rmsf

close $output_file

#-------------------------------RMSD--------------------------------------------

set output_file [open "rmsd.dat" w]
for {set f 0 } {$f < $nf} {incr f} {
    $ref frame $f
    $all frame $f
    set M [measure fit $ref $ref_0]
    $all move $M
    set rmsd [measure rmsd $ref_0 $ref]
    puts $output_file $f\t$rmsd
}

close $output_file


#-------------------------------RGYR--------------------------------------------

set output_file [open "rgyr.dat" w]
for {set f 0 } {$f < $nf} {incr f} {
    $ref frame $f
    $all frame $f
    set M [measure fit $ref $ref_0]
    $all move $M
    set rgyr [measure rgyr $all]
    puts $output_file $f\t$rgyr
}

close $output_file

#-------------------------------PCA_PREP--------------------------------------------

set output_file [open "PCA_prep.dat" w]

for {set f 0 } {$f < $nf} {incr f} {
    $ref frame $f
    $all frame $f
    set M [measure fit $ref $ref_0]
    $all move $M
    set coords [$all get {x y z}]
    
    
    foreach coord $coords {
        puts -nonewline $output_file $coord\t
    }

    puts $output_file " "

}


close $output_file
