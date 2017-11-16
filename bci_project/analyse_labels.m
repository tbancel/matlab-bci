delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

filenames={'subject_1.mat', 'subject_2.mat', 'subject_3.mat', 'subject_4.mat', 'subject_5.mat', 'subject_6.mat', 'subject_7.mat', 'subject_8.mat' };
files_count = length(filenames);
folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/clean-data/';

for i=7:7 %files_count
    load(strcat(folder_path,filenames{i}));
    labels = s_EEG.labels;
    display(unique(s_EEG.labels))
    epochs_number = length(labels);
    number_of_likes = length(find(labels == 1));
    number_of_dislikes = length(find(labels == -1));
    index_of_wrong_labelled_epochs = find(labels == 0);
end