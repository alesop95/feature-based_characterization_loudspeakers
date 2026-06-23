# Feature-based Characterization of Loudspeakers

This repository contains the complete experimental work developed for a Master's thesis in Sound and Music Engineering. The goal is to build a predictive model that correlates objective acoustic features extracted from loudspeaker frequency response measurements with perceptual attributes collected through controlled listening tests, using machine learning regression techniques.

The full thesis is available in this repository as a PDF: *Feature-based characterization of loudspeakers*.

## Overview

Characterizing how loudspeakers sound to human listeners is inherently multidimensional. Standard electroacoustic measurements (frequency response, THD) describe a speaker's physics but do not directly predict how it will be perceived. This work bridges that gap by combining a formal perceptual evaluation protocol with a data-driven learning pipeline.

Four woofers and four tweeters are evaluated. Subjects rate each loudspeaker along three perceptual attributes (Loudness, Timbral Balance, and Preference) while listening to audio tracks played in a controlled listening room. In parallel, an objective feature extraction pipeline computes thirteen spectral descriptors from the anechoic on-axis measurements of each driver. A machine learning model is then trained to predict subjective ratings from objective features, and its performance is validated statistically.

## Loudspeakers Under Test

Woofers: CK165, Scan-Speak Revelator (thII), ESK165, MPK165.

Tweeters: Hertz C26, Violino, ET26-5, MP25-3.

## Repository Structure

```
data_preprocessing/         preprocessing of raw listening test data
                            (normality tests, circular shift recovery,
                             response normalization for woofer and tweeter)

GUI APP/                    MATLAB GUI for administering the listening test
  GUI ENG/                  English version
  GUI ITA/                  Italian version
  tracks/                   audio stimuli used during the test
  tutorial_and_templates/   reference material for MATLAB GUI development

learning algorithm/         regression pipeline
  main_WOOF.m               main script for woofer model training and evaluation
  main_TWEET.m              main script for tweeter model training and evaluation
  correlation_weighting.m   STATIS-based aggregation of multi-subject ratings
  random_augment.m          data augmentation for training set
  error_metrics.m           RMSE, R2, adjusted R2 computation
  remove outlier/           outlier detection utilities (Cook's distance)
  reverse engineering/      auxiliary scripts for frequency domain analysis

objective feature extraction/
  FeatureExtraction.m       extracts all features from on-axis CSVs
  spec_centroid.m           spectral centroid
  spec_contrast.m           spectral contrast
  spec_decrease.m           spectral decrease
  spec_envelope.m           spectral envelope from THD measurements
  aad.m                     average absolute deviation of frequency response
  fract_oct_freq_band.m     fractional octave band utilities

statistical validation/     ANOVA tests and normality checks on listening test data
                            (MATLAB and Python implementations)
```

## Methodology

### Listening Test

The test is administered through a custom MATLAB GUI using the GUIDE framework. Subjects evaluate each loudspeaker by rating it on three perceptual scales using sliders. The test protocol is designed to minimize order effects through a balanced Latin square (120x120, then sampled), ensuring that each combination of speaker and track is presented to subjects in a counterbalanced sequence.

Audio playback is routed via OSC (Open Sound Control) to Reaper, a digital audio workstation, which handles sample-accurate switching between loudspeakers. The stimuli consist of commercial music excerpts selected to cover a broad range of spectral and dynamic content.

The dataset comprises 15 subjects, 4 speakers per category, and 3 audio tracks, yielding a three-way data structure: speakers × attributes × subjects.

### Objective Feature Extraction

Electroacoustic measurements for each driver are provided as CSV files: 1/48-octave smoothed on-axis frequency response and THD in dB. The feature extraction script (`FeatureExtraction.m`) computes the following descriptors for each driver:

- spectral decrease, rolloff point, centroid, spread, kurtosis, entropy, flatness, crest, slope
- spectral contrast
- average absolute deviation of frequency response (AAD)
- spectral envelope (derived from THD measurements)
- THD spectral flatness

MATLAB's Audio Toolbox is used for the standard spectral descriptors. Custom implementations cover the remaining ones.

### Learning Algorithm

Multi-subject ratings are aggregated using a STATIS-based correlation weighting (`correlation_weighting.m`), which assigns higher weight to subjects whose rating patterns are most consistent with the consensus. The aggregated vector becomes the regression target Y.

The feature matrix X combines extracted spectral descriptors with directly measured electroacoustic quantities. The dataset is split 70/30 into training and test sets. A ReliefF feature selection step retains the five most informative predictors per attribute.

Three regression models are trained and compared for each perceptual attribute:

- Ordinary linear regression (`fitlm`)
- Stepwise linear regression with AIC criterion (`stepwiselm`)
- Support vector regression with polynomial kernel (`fitrsvm`)

Model performance is measured with RMSE, R², and adjusted R².

### Statistical Validation

One-way and two-way ANOVA are used to test whether perceptual differences across loudspeakers are statistically significant for each attribute. Both MATLAB and Python (SciPy / biokit) implementations are provided. Box plots with confidence intervals visualize the distribution of ratings per speaker and attribute.

## Requirements

- MATLAB R2019b or later, with the following toolboxes:
  - Audio Toolbox (spectral feature extraction)
  - Statistics and Machine Learning Toolbox (ReliefF, regression models, ANOVA)
- Python 3.x with `scipy`, `numpy`, `pandas`, and `biokit` for the Python ANOVA scripts
- Reaper DAW with OSC enabled, for running the listening test
- `oscsend` MATLAB binding (license included in `GUI APP/GUI ENG/` and `GUI ITA/`)

## Running the Pipeline

The pipeline runs in four independent stages. Measurement CSVs and listening test output files (not included in this repository) must be placed in the expected `Input/` and `Y/` directories before running the learning algorithm.

1. **Listening test**: open `GUI APP/GUI ENG/slider_prova.m` or the Italian equivalent in MATLAB and run it. Reaper must be open with OSC configured as described in the included documentation.
2. **Data preprocessing**: run the scripts in `data_preprocessing/` to normalize and validate the raw listening test data.
3. **Feature extraction**: run `objective feature extraction/FeatureExtraction.m`. Output `.mat` files are saved to the `Output/` directory.
4. **Model training and evaluation**: run `learning algorithm/main_WOOF.m` and `main_TWEET.m`. Results are plotted as bar charts of RMSE, R², and adjusted R² for each attribute and each model.
