% create equilibrated data_set for each subject

% analyse for each subject if there are some wrongly labelled epochs (with
% -1 for instance) and remove
delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

% subject 4 = for classification
% subject 3 = for validation

filenames={'subject_1.mat', 'subject_2.mat', 'subject_3.mat', 'subject_4.mat', 'subject_5.mat', 'subject_6.mat', 'subject_7.mat', 'subject_8.mat' };
% filenames={'subject_3.mat' };


files_count = length(filenames);
folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/clean-data/';
new_folder_path = 'Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/equilibrated-data/'

for i=1:files_count
    load(strcat(folder_path,filenames{i}));
    labels = s_EEG.labels;
    data = s_EEG.data;
    unique_labels = unique(s_EEG.labels);
    epochs_number = length(labels);
    
    likes_index_labels = find(labels == 1);
    dislikes_index_labels = find(labels == -1);
    
    number_of_likes = length(likes_index_labels);
    number_of_dislikes = length(dislikes_index_labels);

    if number_of_likes > number_of_dislikes
      likes_index_labels = likes_index_labels(1:number_of_dislikes)

    elseif number_of_likes < number_of_dislikes
      dislikes_index_labels = dislikes_index_labels(1:number_of_likes)
    end
    

    

    % create the new s_EEG equilibrated data

    s_EEG.data = data(:,:, index_of_rightly_labelled_epochs);
    s_EEG.labels = labels(index_of_rightly_labelled_epochs);

    clean_data_filename = strcat(folder_path,filenames(i));
    
    % save(clean_data_filename, 's_EEG');
    
    str1= "Subject : " + i + "/ Number of epochs : " + epochs_number;
    str2= "Number of likes : "+ number_of_likes +" / Number of dislikes :"+ number_of_dislikes;
    display(str1);
    display(str2);
    
    display(clean_data_filename+" treated and saved");
    display("============");
end