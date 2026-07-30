# An optical ex vivo approach - image and contractility analysis
## 1 - Image analysis - cercle_ROI
Well backgrounds were removed before segmentation by applying an ImageJ macro that automatically generated 96 circular assigned ROIs centered on the wells.
## 2 - Image analysis - clearOutside_cercle_ROI
The outside of the wells are cleared by applying an ImageJ macro.
## 3 - Image analysis - AnalyseParticles
Explant area was measured over the full stack automatically for each ROI using an ImageJ macro.
## 4 - Contractility analysis - peak_detection
Resulting area time series were analysed with a MATLAB peak detection script to extract three contractility parameters: contraction frequency (contractions per 10 min), amplitude and contraction duration (peak width at half-prominence, in minutes).
