############### Command to Run: sptopo3d <file_name> #################
define_structure pmc_file=./pmc_model_output.pmc
fill material=Blank thickness=0.0 
######################################################################
set MN_Probes [list ]
set M_Scan 0.006
set M_Stop 0.026
set M_Step 0.001

set N_Scan 0
set N_Stop 0.01
set N_Step 0.001

while {$M_Scan <= $M_Stop} {
	while {$N_Scan <= $N_Stop}{
		set point [list]
		lappend point $M_Scan
		lappend point $N_Scan
        lappend MN_probes [point]
		set N_Scan [expr $N_Scan + $N_Step]
	}
	set M_Scan [expr $M_Scan + $M_Step]
}
######################################################################

set Metrology_out_file [open "Metrology_out.csv" "w"]
puts $Metrology_out_file "x1, y1, z1, x2, y2, z2, Metrology_Out"
######################################################################
foreach yz $MN_Probes {
	set x1 0
	set y1 $yz[0]
	set z1 $yz[1]
	set x2 0.014
	set y2 $yz[0]
	set z2 $yz[1]
	set Metrology_Out [extract type=probe property=length  materials={SiGe} point1= "$x1 $y1 $z1" point2= "$x2 $y2 $z2" output=inside]
	puts $Metrology_out_file "$x1, $y1, $z, $x2, $y2, $z, $Metrology_Out"
	}
close $Metrology_out_file
