delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

% load init methods
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/export_sigma_box/init_method.mat')
% load init parameters (which will be modified later)
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/export_sigma_box/init_parameter.mat')

% change all the following fields so that it can work on your machine

% sigma_directory: '/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing'
% data_output: 'SIGMA_output/'
% session_name: 'Session_20-Nov-2017_153820'
% logFilename: 'Sigma_logFile_Session_20-Nov-2017_153820.txt'
% diaryFilename: 'Sigma_diaryFile_Session_20-Nov-2017_153820.txt'
% full_session_name: 'SIGMA_output/Session_20-Nov-2017_153820'
% data_location: '/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/clean-data/'
% validation_data_location: 'SIGMA_data/'
% application_data_location: 'SIGMA_data/'

% choose your parameters
init_parameter.subject = [1 2]
init_parameter.nb_subject = 2
init_parameter.selected_band = 1
init_parameter.nb_bands = 3
init_parameter.method = 3
init_parameter.nb_method = 1



features_results = Sigma_feature_extraction(init_parameter,init_method);
performance_results = Sigma_cross_validation(features_results,init_parameter,init_method);
