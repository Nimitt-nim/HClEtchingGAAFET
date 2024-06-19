
############### Command to Run: sptopo3d <file_name> #################
define_structure pmc_file=./pmc_model_output.pmc
fill material=Blank thickness=0.0 
######################################################################
set point1 {0.0 0.0 0.1}
set point2 {-0.05 -0.05 0.1}
set Metrology_Out [extract type=probe property=length materials= {Blank} point1= $point1 point2=$point2 output=inside]
puts "Output Metrology = $Metrology_Out"


--------------------



############### Command to Run: sptopo3d <file_name> #################
define_structure pmc_file=./pmc_model_output.pmc
fill material=Blank thickness=0.0 
######################################################################
set M_Probes [list ]
set M_Scan 0
set M_Stop 1.1
set M_Step 0.01
while {$M_Scan <= $M_Stop} {
	lappend M_Probes $M_Scan
	set M_Scan [expr $M_Scan + $M_Step]
}
######################################################################

set Metrology_out_file [open "Metrology_out.csv" "w"]
puts $Metrology_out_file "x1, y1, z1, x2, y2, z2, Metrology_Out"
######################################################################
foreach z $M_Probes {
	set x1 0
	set y1 0
	set z1 $z
	set x2 0.5
	set y2 0.5
	set z2 $z
	set Metrology_Out [extract type=probe property=length  axis=x point1= "$x1 $y1 $z1" point2= "$x2 $y2 $z2" output=inside]
	puts $Metrology_out_file "$x1, $y1, $z, $x2, $y2, $z, $Metrology_Out"
	}
close $Metrology_out_file




----------------------------------


############### Command to Run: svisual -bx <file_name> #################
set data [load_file ./Output.tdr]

############################  Save 3D View ##############################
create_plot -name P1_out -dataset $data  
select_plots P1_out  
rotate_plot -plot P1_out -x -1.004 -y -10.6 -z -2.21 -absolute
set_plot_prop -plot P1_out -hide_title
export_view "./Output_Structure_3D_View.png" -plots P1_out -resolution 800x600 \
-format PNG -overwrite

###########################  X Cutplane Part ############################
create_cutplane -name CX_out -plot P1_out -type x -at 0
create_plot -name P2_out -dataset CX_out -ref_plot P1_out
select_plots P2_out
set_plot_prop -plot P2_out -hide_title
export_view "./Output_Structure_2D_View_1.png" -plots P2_out -resolution 800x600 \
-format PNG -overwrite

###########################  Y Cutplane Part ############################
create_cutplane -name CY_out -plot P1_out -type y -at 0
create_plot -name P3_out -dataset CY_out -ref_plot P1_out
select_plots P3_out
set_plot_prop -plot P3_out -hide_title
export_view "./Output_Structure_2D_View_2.png" -plots P3_out -resolution 800x600 \
-format PNG -overwrite