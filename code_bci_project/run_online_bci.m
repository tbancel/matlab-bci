%run offline bci
clc; clear;

%%%%%%%%
% Set the initial parameters
%
sigma_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/SIGMA_V4/';
sigma_test_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/SIGMA_V4/SIGMA_data/subject_for_test/';

%%%%%%%%
% Give the model path
% 
% model_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/export_sigma_box/best_export_sigma_box_v3/';
model_file_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/export_sigma_box/best_model.mat'

%%%%%%%%
% load the epochs to predict
%
% load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/0. raw-data/raw-epoch.mat');
% load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/4. new-rand-subject/subject_8.mat');
load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/0. raw-data/Tinder_S2.mat');

%%%%%%%%
% call my bci:
%
%[predicted_labels, time] = my_bci(s_EEG, model_folder_path, sigma_test_folder_path);
[apply_model_out, time] = my_bci(s_EEG, model_file_path, sigma_folder_path, sigma_test_folder_path);

%%%%%%%%
% calculate accuracy:
real_labels = s_EEG.labels;
correct_answers = (real_labels' == apply_model_out.predicted_labels);
accuracy = sum(correct_answers)/length(correct_answers);

% display the results:

display("Number of epochs to predict:"+length(s_EEG.labels));
display("Number of correctly predicted epochs:"+sum(correct_answers));
display("Accuracy:"+accuracy);
display("Time to perform the prediction (s):"+time);

% display(predicted_labels);
% display(real_labels);