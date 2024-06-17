##start - script

##start - structure definition
define_structure file=initial.tdr 

##end - structure definition


##start - pmc simple etch model definition
define_model name=HCl_etch_Si description="Silicon chemical etch by HCl"
#add_source_species model=HCl_etch_Si name=H

add_source_species model=HCl_etch_Si name=Cl

add_reaction model=HCl_etch_Si name=SiCl  expression="Cl<g> + Si<s> = SiCl<s>"
add_reaction model=HCl_etch_Si name=SiCl2 expression="Cl<g> + SiCl<s> = SiCl2<v>"  

add_reaction model=HCl_etch_Si name=GeCl  expression="Cl<g> + Ge<s> = GeCl<s>"
add_reaction model=HCl_etch_Si name=GeCl2 expression="Cl<g> + GeCl<s> = GeCl2<v>"  

   
finalize_model model=HCl_etch_Si
##end - pmc simple etch model definition

##start - define distribution
#define_species_distribution name=distribution exponent=1 species=H flux=3.0e-3
define_species_distribution name=distribution exponent=ClExponent species=Cl flux=ClFlux
##end - spdefine distribution

##start - define machine
define_etch_machine model=HCl_etch_Si species_distribution=distribution 
##end - define machine

##start - reaction properties
# Original
#add_reaction_properties reaction=SiCl p=0.4
#add_reaction_properties reaction=SiCl2 p=0.005

#add_reaction_properties reaction=GeCl p=0.7
#add_reaction_properties reaction=GeCl2 p=0.05

add_reaction_properties reaction=SiCl p=p1
add_reaction_properties reaction=SiCl2 p=p2

add_reaction_properties reaction=GeCl p=p3
add_reaction_properties reaction=GeCl2 p=p4

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