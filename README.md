# 96-well methods analysis
## 1 - Image_analysis_1_cercle_ROI
Well backgrounds were removed before segmentation by applying an ImageJ macro that automatically generated 96 circular assigned ROIs centered on the wells.
## 2 - Image_analysis_1_cercle_ROI_clearOutside
The outside of the wells are cleared by applying an ImageJ macro.
## 3 - Image_analysis_2_Analyse_Particles
Explant area was measured over the full stack automatically for each ROI using an ImageJ macro.
## 4 - Contractility_analysis_Well_96tables_gaussian_filter_amplitude
Resulting area time series were analysed with a MATLAB peak detection script to extract three contractility parameters: contraction frequency (contractions per 10 min), amplitude and contraction duration (peak width at half-prominence, in minutes). Optionnal: Mean of basal and % differences betwenn before and after molecules effect for each replicates and concentrations are extracted with a MATLAB script (Contractility_analysis_Well_96tables_amplitude_data_diff_mean_replicates).
