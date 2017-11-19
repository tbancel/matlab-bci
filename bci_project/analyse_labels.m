% analyse for each subject if there are some wrongly labelled epochs (with
% -1 for instance) and remove
delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

filenames={'subject_1.mat', 'subject_2.mat', 'subject_3.mat', 'subject_4.mat', 'subject_5.mat', 'subject_6.mat', 'subject_7.mat', 'subject_8.mat' };
files_count = length(filenames);
folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/clean-data/';

for i=2:2
    load(strcat(folder_path,filenames{i}));
    labels = s_EEG.labels;
    data = s_EEG.data;
    unique_labels = unique(s_EEG.labels);
    epochs_number = length(labels);
    
    likes_index_labels = find(labels == 1);
    dislikes_index_labels = find(labels == -1);
    
    number_of_likes = length(likes_index_labels);
    number_of_dislikes = length(dislikes_index_labels);
    
    index_of_rightly_labelled_epochs = cat(2, likes_index_labels, dislikes_index_labels);
    index_of_wrongly_labelled_epochs = [];
    
    for j=1:length(unique_labels)
        label = unique_labels(j);
        if length(find([-1 1] == label)) == 0
            index_of_wrongly_labelled_epochs = cat(2, index_of_wrongly_labelled_epochs, find(labels == label));
        end
    end
    
    s_EEG.data = data(:,:, index_of_rightly_labelled_epochs);
    s_EEG.labels = labels(index_of_rightly_labelled_epochs);
    
    clean_data_filename = strcat(folder_path,'subject_', int2str(i),'.mat');
    
    save(clean_data_filename, 's_EEG');
    display(clean_data_filename+" treated and saved");
    display("============");
end
