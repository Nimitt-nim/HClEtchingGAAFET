# Initialize the MN_Probes list
set MN_Probes {}
 
# Set initial values for M and N scans
set M_Scan 0.006
set M_Stop 0.026
set M_Step 0.005
 
set N_Scan 0
set N_Stop 0.01
set N_Step 0.005

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