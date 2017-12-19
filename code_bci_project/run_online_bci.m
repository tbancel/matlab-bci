%run offline bci
clc; clear;


sigma_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/SIGMA_V3/';
model_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/export_sigma_box/best_export_sigma_box_v3/';
sigma_test_folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/SIGMA_V3/SIGMA_data/subject_for_test/';

% load the epochs to predict
% load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/0. raw-data/raw-epoch.mat');
load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/0. raw-data/Tinder_S2.mat');

% call my bci:
[predicted_labels, time] = my_bci(s_EEG, model_folder_path, sigma_test_folder_path);

% calculate accuracy:
real_labels = s_EEG.labels;
correct_answers = (real_labels' == predicted_labels);
accuracy = sum(correct_answers)/length(correct_answers);

% display the results:

display("Number of epochs to predict:"+length(s_EEG.labels));
display("Number of correctly predicted epochs:"+sum(correct_answers));
display("Accuracy:"+accuracy);
display("Time to perform the prediction (s):"+time);
% display(predicted_labels);
% display(real_labels);

% measuring computation times several times:
% times = [];
% for i=1:100
%     [predicted_labels, time] = my_bci(s_EEG, model_folder_path, sigma_test_folder_path);
%     times = [times, time];
% end
% 
% mean_comp_time=mean(times);
% std_comp_time=std(times);
