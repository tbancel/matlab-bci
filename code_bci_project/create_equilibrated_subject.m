clc; clear; close all;
% create equilibrated subject

load('/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/3. equilibrated-data/subject_1.mat');

folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data/4. new-rand-subject/';

large_EEG = s_EEG;

large_data = large_EEG.data;
large_labels = large_EEG.labels;
channel_names = large_EEG.channel_names;
sampling_rate = large_EEG.sampling_rate;

% randomize the order of the epochs
% epoch_length = size(large_data, 3);
% permutation = randperm(epoch_length);
% large_data = large_data(:,:, permutation);
% large_labels = large_labels(permutation);

% splitting likes / dislikes
like_epochs = large_data(:,:,find(large_labels == +1));
like_labels = large_labels(find(large_labels == +1));

dislike_epochs = large_data(:,:, find(large_labels == -1));
dislike_labels = large_labels(find(large_labels == -1));

% create 7 subjects

for i=1:7 
  range = (1+(i-1)*37):(i*37)
  
  s_EEG.data = cat(3, like_epochs(:,:,range), dislike_epochs(:,:,range))
  s_EEG.labels = cat(2,like_labels(range), dislike_labels(range))
  s_EEG.subject_number = i;
  s_EEG.channel_names = channel_names;
  s_EEG.sampling_rate = sampling_rate;

  filename=strcat(folder_path, 'subject_', int2str(i), '.mat');

  save(filename, 's_EEG');
end
    