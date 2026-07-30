## 96-well methods analysis
1 - Well backgrounds were removed before segmentation by applying an ImageJ macro (Image_analysis_1_cercle_ROi) that automatically generated 96 circular assigned ROIs centered on the wells.
2 - The outside of the wells are cleared by applying an ImageJ macro (Image_analysis_2_clear_outside_cercle_ROI).
3 - Explant area was measured over the full stack automatically for each ROI using an ImageJ macro (Image_analysis_3_Analyse_Particles).
4 - Resulting area time series were analysed with a MATLAB peak detection script to extract three contractility parameters: contraction frequency (contractions per 10 min), amplitude and contraction duration (peak width at half-prominence, in minutes) (uterus_analysis_contractility_96well).
5 - Mean of basal and % differences betwenn before and after molecules effect for each replicates and concentrations are extracted with a MATLAB script (uterus_analysis_contractility_96well2).

# Isotonic force transducer method (emkaBATH4) 
This MATLAB script is applied for each organ bath. Raw force in grams is extracted from text file that are generated from the iox software included with the emka machine and are copy-paste in the first column of a matrix called 'data'. It traces Forces (g) against Time (min) for all experiment and each concentration (0, 0.01, 0.1, 1 and 10 µM)(uterus_analysis_contractility_forceTransducer).



