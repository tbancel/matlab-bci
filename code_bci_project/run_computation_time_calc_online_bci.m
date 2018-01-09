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
% Load the test epoch

load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/0. raw-data/raw-epoch.mat')


%%%%
% Time to calculate the predicted label for one epoch.

% measuring computation times several times:
times = [];
for i=1:100
    [apply_model_out, time] = my_bci(s_EEG, model_file_path, sigma_folder_path,sigma_test_folder_path);
    times = [times, time];
end

mean_comp_time=mean(times);
std_comp_time=std(times);
