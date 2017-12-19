
function [number_of_likes, number_of_dislikes, likes_index_labels, dislikes_index_labels] = analyse_labels(s_EEG)
% analyse for each subject if there are some wrongly labelled epochs (with
% -1 for instance) and remove

% delete(findall(0, 'Type', 'figure'));
% clear;
% close;
% clc;

% subject 4 = for classification
% subject 3 = for validation

% filenames={'subject_1.mat', 'subject_2.mat', 'subject_3.mat', 'subject_4.mat', 'subject_5.mat', 'subject_6.mat', 'subject_7.mat', 'subject_8.mat' };
% filenames={'subject_1.mat' };


% files_count = length(filenames);
% folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/data-after-ica/';

% for i=1:files_count
%     load(strcat(folder_path,filenames{i}));

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
    
    % s_EEG.data = data(:,:, index_of_rightly_labelled_epochs);
    % s_EEG.labels = labels(index_of_rightly_labelled_epochs);

    % clean_data_filename = strcat(folder_path,filenames(i));
    
    % save(clean_data_filename, 's_EEG');
    % display(clean_data_filename+" treated and saved");
    
    str1= "Subject : " + s_EEG.subject_number + "/ Number of epochs : " + epochs_number;
    str2= "Number of likes : "+ number_of_likes +" / Number of dislikes :"+ number_of_dislikes;
    display(str1);
    display(str2);
    display("============");

end
