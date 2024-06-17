##start - script

##start - structure definition
define_structure material=SiN point_min = {0 0 -0.01} point_max = {0.024 0.032 0}
fill material=Ge thickness=0.01
fill material=Si thickness=0.005
fill material=Ge thickness=0.01
fill material=Si thickness=0.005
fill material=Ge thickness=0.01



define_shape type=cube name=e1 point_min={0.014 0 0} point_max={0.024 0.032 0.04} 
define_shape type=cube name=e2 point_min={0 0 0} point_max={0.014 0.006 0.04} 
define_shape type=cube name=e3 point_min={0 0.024 0} point_max={0.014 0.032 0.04} 

etch shape=e1
etch shape=e2
etch shape=e3

define_deposit_machine model=simple material=gate rate=1.0 \
anisotropy=1 curvature=0.1
deposit spacing={0.015 0.015 0.015} time=0.03

define_shape type=cube name=e4 point_min={0.014 0 0} point_max={0.024 0.032 0.5} 
define_shape type=cube name=e5 point_min={0.008 0 0} point_max={0.024 0.006 0.5} 
define_shape type=cube name=e6 point_min={0.008 0.024 0} point_max={0.024 0.032 0.5} 
define_shape type=cube name=e7 point_min={0 0 0.045} point_max={0.008 0.032 0.5} 
define_shape type=cube name=e8 point_min={0.008 0 0.04} point_max={0.014 0.032 0.5} 

etch shape=e4
etch shape=e5
etch shape=e6
etch shape=e7
etch shape=e8


define_deposit_machine name=spacer model=simple material=spacer rate=1.0 \
anisotropy=1 curvature=0.1
deposit machine=spacer spacing={0.015 0.015 0.015} time=0.03

define_shape type=cube name=e9 point_min={0.014 0 0} point_max={0.024 0.032 0.5} 
define_shape type=cube name=e10 point_min={0 0 0.045} point_max={0.014 0.032 0.5} 

etch shape=e9
etch shape=e10


##end - structure definition
save file=initial.tdr