# An optical ex vivo approach - image and contractility analysis
## A high-throughput 96-well plate method to measure human uterine contractility
Article ID: 1953934
Article DOI: 10.3389/fphar.2026.1953934 
Journal: Frontiers in Pharmacology
### 1 - Image analysis - cercle_ROI
Well backgrounds were removed before segmentation by applying an ImageJ macro that automatically generated 96 circular assigned ROIs centered on the wells.
## 2 - Image analysis - clearOutside_cercle_ROI
The outside of the wells are cleared by applying an ImageJ macro.
## 3 - Image analysis - AnalyseParticles
Explant area was measured over the full stack automatically for each ROI using an ImageJ macro.
## 4 - Contractility analysis - peak_detection
Resulting area time series were analysed with a MATLAB peak detection script to extract three contractility parameters: contraction frequency (contractions per 10 min), amplitude and contraction duration (peak width at half-prominence, in minutes).
## Ex vivo spatiotemporal mapping of myometrium contractions in adenomyosis
### Ex vivo
#### 1 - Image analysis - TrackV2 plugin - ImageJ
#### 2 - Contractility analysis - MATLAB script
MATLAB_trackv2data_contractility_analysis.mat
### Immunofluorescence - OTR receptors analysis
#### 3 - Image analysis - ROI_automatic_placement - ImageJ macro
MacroROIauto.ijm
#### 4 - Image segmentation by machine learning - Trainable Weka Segmentation plugin
#### 5 - Integrated OTR density - MATLAB script
integrated_OTR_density.mat

