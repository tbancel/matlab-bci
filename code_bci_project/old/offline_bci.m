clc;
clear;
% online_bci

% load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/best_export_sigma_box_v3/apply_model_results.mat')
% load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/best_export_sigma_box_v3/features_results.mat')
% load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/best_export_sigma_box_v3/performances_results.mat')
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/best_export_sigma_box_v3/init_method.mat')
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/best_export_sigma_box_v3/selected_model.mat')
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/best_export_sigma_box_v3/init_parameter.mat')

[computed_feature_new_data, predicted_labels, predicted_scores,validation_results,validation_results_infos]=Sigma_apply_model0(init_parameter,init_method,selected_model,'Validation')