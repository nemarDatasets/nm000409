Dataset and code accompanying publication: "Revealing the Physiological Origin of Event-Related Potentials using Electrocorticography in Humans"
------------------------------------------------------------------------------------------------------------------------

Code written by Hohyun Cho, PhD (cho@neurotechcenter.org)

This repository contains the MATLAB scripts (*.m) used to create the figures of this publication. 
All non-MATLAB dependencies are included in ./functions.

MATLAB versions tested: R2017b to R2020a

Before running the scripts, please run "add_path.m" first.


[MATLAB scripts reproducing the figures shown in this publication]

Figure 2: figure2A.m
Figure 2: figure2B_and_C.m

Figure 2 - Figure supplement 1: figure2_supplement_1.m

Figure 2 - Figure supplement 2: figure2_supplement_2.m

Figure 2 - Figure supplement 3: figure2_supplement_3.m

Figure 2 - Figure supplement 4: figure2_supplement_4.m

Figure 3: figure3_erp_analysis.m

Figure 3 - Figure supplement 1: figure3_supplement_1_auditory.m
Figure 3 - Figure supplement 1: figure3_supplement_1_motor.m

Figure 3 - Figure supplement 2: figure3_supplement_2.m

Figure 5: figure5.m

Figure 5 - Figure supplement 1: figure5_supplement_1.m

Figure 5 - Figure supplement 2: figure5_supplement_2A.m
Figure 5 - Figure supplement 2: figure5_supplement_2B_auditory.m
Figure 5 - Figure supplement 2: figure5_supplement_2B_motor.m


[MATLAB scripts implementing the methods presented in this publication]

removing_addivity_under_3Hz.m 
- a script for removing effect of additivity from the evoked potentials across all subjects

removing_phase_reset_of_ongoing_osillation.m 
- a script for removing effect of phase resetting within ongoing oscillation from the evoked potentials across all subjects

removing_asymmetry_of_ongoing_oscillation.m 
- a script for removing effect of asymmetry within ongoing oscillation from the evoked potentials across all subjects

removing_additive_power.m 
- a script for removing additive power from the evoked potentials across all subjects

removing_addivity_and_phase_reset.m 
- a script for removing effect of additivity and phase resetting from the evoked potentials across all subjects


