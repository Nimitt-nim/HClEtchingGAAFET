########################## Variable Declaration ############################
set plasma_model "plasma_model"


########################## Plasma Model ############################
define_plasma_model name=$plasma_model \
   bulk_model_type=global sheath_model_type=circuit

add_species plasma_model=$plasma_model name=Ar  mass=39.948<amu> charge=0
add_species plasma_model=$plasma_model name=Ar* mass=39.948<amu> charge=0  
add_species plasma_model=$plasma_model name=Ar+ mass=39.948<amu> charge=+1 

add_species plasma_model=$plasma_model name=HCl  mass=36.5<amu> charge=0
add_species plasma_model=$plasma_model name=H  mass=1<amu> charge=0
add_species plasma_model=$plasma_model name=Cl  mass=35.5<amu> charge=0

add_bulk_reaction plasma_model=$plasma_model name=r1 \
   expression="Ar + e- = Ar* + e-" \
   rate_coefficient_type=arrhenius \
   a=6.033e-15 b=0.3287 c=12.08 energy_transfer=11.6<eV>


add_bulk_reaction plasma_model=$plasma_model name=r1 \
   expression="HCl = H + Cl" \
   rate_coefficient_type=arrhenius \
   a=6.033e-15 b=0.3287 c=12.08 energy_transfer=11.6<eV>


########################## Reactor Parameters ############################
define_reactor name=R plasma_model=$plasma_model \
   type=icp \
   radius=rs<cm> \
   height=hte<cm> \
   power=pes<W> \
   power_absorption_coefficient=pact \
   gas_temperature=gt<K> \
   pressure=pse<mTorr> \
   rf_bias_power=rbp<W> \
   rf_bias_frequency=rbf<MHz> \
   inlet_gas_flow= {{Ar igf<sccm>}}

define_bulk_solver name=bs \
   bulk_model_type=global \
   stationary_state_tolerance=4.0e-13

define_sheath_solver name=ss \
   sheath_model_type=circuit \
   ied_solver=monte_carlo \
   power_tolerance=1e-3

define_extraction name=ex_bulk \
   type=plasma \
   bulk_model_type=global \
   quantities={reactions state residuals} output_type=tdr\
   file=n3_bulk_extractions.tdr

define_extraction name=ex_sheath \
   type=plasma \
   sheath_model_type=circuit \
   quantities={energy_distribution} \
   species_pattern= {*+} output_type=tdr \
   file=n3_sheath_extractions.tdr 

set plasma_results [solve_reactor name=ps reactor=R \
   bulk_solver=bs sheath_solver=ss extractions={ex_bulk ex_sheath}]

puts $plasma_results
array set plasma_results_array [join  $plasma_results]

#####################################################################
##start - structure definition
define_structure file=initial.tdr 

##end - structure definition


##start - pmc simple etch model definition
define_model name=HCl_etch_Si description="Silicon chemical etch by HCl"

add_source_species model=HCl_etch_Si name=H

add_source_species model=HCl_etch_Si name=Cl

add_reaction model=HCl_etch_Si name=SiCl  expression="Cl<g> + Si<s> = SiCl<s>"
add_reaction model=HCl_etch_Si name=SiH  expression="H<g> + Si<s> = SiH<s>"
add_reaction model=HCl_etch_Si name=SiHCl  expression="Cl<g> + SiH<s> = SiHCl<s>"
add_reaction model=HCl_etch_Si name=SiCl2 expression="Cl<g> + SiCl<s> = SiCl2<v>"  

add_reaction model=HCl_etch_Si name=GeCl  expression="Cl<g> + Ge<s> = GeCl<s>"
add_reaction model=HCl_etch_Si name=GeCl2 expression="Cl<g> + GeCl<s> = GeCl2<v>"  

   
finalize_model model=HCl_etch_Si
##end - pmc simple etch model definition

define_species_distribution name=my_distr species=H type=plasma solution=ps
define_species_distribution name=my_distr species=Cl type=plasma solution=ps

#####################################################################
##start - define machine
define_etch_machine model=HCl_etch_Si species_distribution=my_distr
##end - define machine

##start - reaction properties
# Original
add_reaction_properties reaction=SiCl p=0.4
add_reaction_properties reaction=SiCl2 p=0.005

add_reaction_properties reaction=GeCl p=0.7
add_reaction_properties reaction=GeCl2 p=0.05


##end - reaction properties

##start - multi-threading
let parallel=true
let num_threads=20
##end - multi-threading

##start - run pmc
etch spacing=0.001 time=etch_time<s> method=pmc
##end - run pmc

save type=dc dc_version=2 file=result.tdr
##end - script