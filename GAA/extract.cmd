############### Command to Run: sptopo3d <file_name> #################
define_structure pmc_file=./Data_GAA/PMC_files/results_Clflux/result_Clflux_etch_time.pmc
fill material=Blank thickness=0.0 
######################################################################
# Initialize the MN_Probes list
set MN_Probes {}
 
# Set initial values for M and N scans
set M_Scan 0.006
set M_Stop 0.026
set M_Step 0.001
 
set N_Scan 0
set N_Stop 0.04
set N_Step 0.001

# Loop through M_Scan values
while {$M_Scan <= $M_Stop} {
    
    # Reset N_Scan for each new M_Scan
    set N_Scan 0
    # Loop through N_Scan values
    while {$N_Scan <= $N_Stop} {
        # Create a point list with current M_Scan and N_Scan values
        set point [list $M_Scan $N_Scan]
        # Append the point list to the MN_Probes list
        lappend MN_Probes $point
        # Increment N_Scan
        set N_Scan [expr {$N_Scan + $N_Step}]
    }
    # Increment M_Scan
    set M_Scan [expr {$M_Scan + $M_Step}]
}

######################################################################
#set yz [lindex $MN_Probes 100]
#set point1 [list 0 [lindex $yz 0] [lindex $yz 1]]
#set point2 [list 0.014 [lindex $yz 0] [lindex $yz 1]]

#set Metrology_Out [extract type=probe property=length materials= {Ge} point1= $point1 point2=$point2 output=inside]
#puts "Output Metrology = $Metrology_Out"

set Metrology_out_file [open "Data_GAA/CSV_files/results_Clflux/result_Clflux_etch_time.csv" "w"]
puts $Metrology_out_file "x1, y1, z1, x2, y2, z2, Metrology_Out"
######################################################################
for {set i 0} {$i < [llength $MN_Probes]} {incr i} {
    	# Access the current element of MN_Probes
    	set yz [lindex $MN_Probes $i]
    
    	# Extract values for point1 and point2
    	set x1 0
    	set y1 [lindex $yz 0]
    	set z1 [lindex $yz 1]
    	set x2 0.014
    	set y2 [lindex $yz 0]
    	set z2 [lindex $yz 1]

    	# Create point1 and point2
    	set point1 [list 0 $y1 $z1]
    	set point2 [list 0.014 $y1 $z1]

	set Metrology_Out [extract type=probe property=length materials= {Ge} point1= $point1 point2=$point2 output=inside]
	puts $Metrology_out_file "$x1, $y1, $z1, $x2, $y2, $z2, $Metrology_Out"
}
close $Metrology_out_file