%run offline bci
clc; clear;

model_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/export_sigma_box/best_export_sigma_box_v3/';
sigma_test_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/SIGMA_V3/SIGMA_data/subject_for_test/'

load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/0. raw-data/raw_epoch.mat');
[predicted_labels, time] = my_bci(s_EEG, model_folder_path, sigma_test_folder_path);
real_labels = s_EEG.labels;

display(predicted_labels);
display(real_labels);
display(time);