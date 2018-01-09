clear all
clc

% Step 1: define your current pathway below
% -----------------------------------------
pwd='C:\Users\Charles VERDONK\Documents\MATLAB\Data\BCI_Project\';
old_pwd=pwd

% Step 2: if necessary, create a folder 'Raw_data' with the raw data in your current pathway
% ------------------------------------------------------------------------------------------

% Step 3: check that files names look like 'Tinder_SX.mat'
% --------------------------------------------------------

% Step 4: load data for each subject & preprocess it
% -------------------------------------------------

    %Overall parameters
    number_of_subjects=8;


    for s=1:number_of_subjects 
        
        %% Files reading
        
        pwd=old_pwd;
        load([pwd,'Raw_data\','Tinder_S',num2str(s),'.mat']);
        raw_EEG_data=s_EEG.data; % select EEG data
        behavioral_data=s_EEG.labels; % select responses of subject (+1= I like, -1= I dislike)

        %Subject's parameters
        fs=s_EEG.sampling_rate;
        channel_names=s_EEG.channel_names;
        labels = s_EEG.labels;
        unique_labels = unique(s_EEG.labels);

        %% Identification of labels & removal of wrong labels (label=0)
        
        epochs_number = length(labels);
        likes_index_labels = find(labels == 1);
        dislikes_index_labels = find(labels == -1);
        number_of_likes = length(likes_index_labels);
        number_of_dislikes = length(dislikes_index_labels);
        index_of_rightly_labelled_epochs = cat(2, likes_index_labels, dislikes_index_labels);
        index_of_wrongly_labelled_epochs = [];
        rightly_labelled_epochs=labels(index_of_rightly_labelled_epochs);

        for j=1:length(unique_labels)
            label = unique_labels(j);
            if length(find([-1 1] == label)) == 0
                index_of_wrongly_labelled_epochs = cat(2, index_of_wrongly_labelled_epochs, find(labels == label));
            end
        end

        data_cleaned_from_wrong_labels = raw_EEG_data(:,:, index_of_rightly_labelled_epochs);
        cleaned_labels = labels(index_of_rightly_labelled_epochs);
        
        
         %% Signal normalization
         normalized_EEG_data=zeros(size(data_cleaned_from_wrong_labels));
         for i = 1:size(data_cleaned_from_wrong_labels,3) % number of epochs differs between subject 
             for j = 1:19
                     normalized_EEG_data(j,:,i)=zscore(data_cleaned_from_wrong_labels(j,:,i));
             end
         end

        %Check normalized data
        %mean_normalized_data=mean(normalized_EEG_data,2); %if mean value near zero > OK
        %std_normalized_data=std(normalized_EEG_data,0,2); %if standard deviation value equal to 1 > OK

        %% Noise filtering

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        % Cancellation of noise components (powerline interference and
        % baseline wandering) with band pass filter
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%         f1=1; %cuttoff low frequency to get rid of baseline wander
%         f2=50; %cuttoff frequency to discard high frequency noise
%         Wn=[f1 f2]*2/fs; % cutt off based on fs
%         N = 3; % order of 3 less processing
%         [a,b] = butter(N,Wn); %bandpass filtering
%         EEG_data_filtered = filtfilt(a,b,normalized_EEG_data); %zero phase filter to prevent phase shift of filtered signal
          
          %filtered_data=zeros(size(data_cleaned_from_wrong_labels,1), size(data_cleaned_from_wrong_labels,2), size(data_cleaned_from_wrong_labels,3));
          EEG_data_filtered = zeros(size(data_cleaned_from_wrong_labels,1),size(data_cleaned_from_wrong_labels,2),size(data_cleaned_from_wrong_labels,3));
          for k=1:size(normalized_EEG_data,3)
              f1=1; %cuttoff low frequency to get rid of baseline wander
              f2=45; %cuttoff frequency to discard high frequency noise
              Wn=[f1 f2]*2/fs; % cutt off based on fs
              N = 3; % order of 3 less processing
              [b,a] = butter(N,Wn); %bandpass filtering
                          
              raw_EEG_filtered_data = filtfilt(b,a,normalized_EEG_data(:,:,k));
              EEG_data_filtered(:,:,k)=raw_EEG_filtered_data;
          end
        
        %save filtered data into a new folder 'Filtered_data' as MATLAB file for next steps on EEGLAB
            if s==1
                filtered_data_folder = sprintf('Filtered_data');
                if ~exist(filtered_data_folder, 'dir') == 1 % create the folder if it doesn't exist already
                    mkdir([pwd,'Filtered_data']);
                    pwd=[old_pwd,'Filtered_data\'];
                else
                    pwd=[old_pwd,'Filtered_data\'];
                end
            else
                pwd=[old_pwd,'Filtered_data\'];
            end
            EEG.data=EEG_data_filtered;
            %EEG.labels=cleaned_labels;
            save([pwd,'subject_',num2str(s),'_data_filtered.mat'],'-struct','EEG');
            
        %create new folder 'Cleaned_data' to store data after cleaning by EEGLAB
            if s==1
                cleaned_data_folder = sprintf('Cleaned_data');
                if ~exist(cleaned_data_folder, 'dir') == 1 % create the folder if it doesn't exist already
                    mkdir([old_pwd,'Cleaned_data']);
                    pwd=[old_pwd,'Cleaned_data\'];
                else
                    pwd=[old_pwd,'Cleaned_data\'];
                end
            else
                pwd=[old_pwd,'Cleaned_data\'];
            end
    %end
    
% Step 5: Removing artefacts on all data using EEGLAB toolbox and graphic interface
% ---------------------------------------------------------------------------------    

    %eeglab

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % Semi-automatic artifact rejection using high order statistics
    % (probability and kurtosis) and independent component analysis
    % References: 
    % [1] Delorme, A., et al. (2001). Automatic artifact rejection for EEG
    %     data using high-order statistics and independent component
    %     analysis. Proceedings of the third international ICA conference.
    % [2] https://sccn.ucsd.edu/wiki/Chapter_01:_Rejecting_Artifacts 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For each subject
    %
    %        1) load filtered data file .mat 
    %                >>File>Import data>Using EEGLAB functions and plugins>From ASCII/float file or Matlab array
    %           and specify
    %               - sampling rate (Hz): 500
    %               - number of channels: 19
    %               - channel location file: Browse>pathway to EEGLAB>eeglab14_1_1b>sample_locs>Standard-10-20-Cap19.ced
    %
    %        2) run ICA with default parameters of EEGLAB
    %            >>Tools>Run ICA
    %
    %        3) perform semi-automated rejection of data epochs on the independent components
    %
    %            >>Tools>Reject data using ICA>Reject data (all methods)
    %            - and specify value 5 as parameter (limit) both for Find
    %                  improbable data & Find abnormal distribution
    %            - then click on 'Calculate' for the two high order
    %                   statistics 
    %            - close in clicking on 'Close (keep marks)' (lower left corner) 
    %
    %        4) export indexes of epochs targeted as artefacts
    %            >>Tools>Reject data using ICA>Export marks to data reject
    %            then
    %            >>Tools>Reject data epochs>Reject by inspection
    %            - close in clicking on 'UPDATE MARKS' (lower right corner)
    %
    %        6) save cleaned data
    %               >>File>Save current dataset as
    %               - save as subject_X_data_cleaned.set in folder Cleaned_data
    %
    %        7) modify directly in its folder the format of file .set -> .mat 


% Step 6: Concatenation of data from all subjects in a single matrice
% -------------------------------------------------------------------

    %number_of_epochs_per_subject=[]
    %for s=1:number_of_subjects  % filecount

    %% Load data just cleaned with EEGLAB interface
         load([old_pwd,'Cleaned_data\','subject_',num2str(s),'_data_cleaned.mat']);
         raw_EEG_data_cleaned=EEG.data;
         results_ICA=EEG.reject.rejglobal; % for each epoch: 1 if artefacted, 0 if non artefacted
         epochs_to_keep = find(results_ICA == 0);
         %number_of_epochs_per_subject=[number_of_epochs_per_subject size(EEG_data_cleaned,3)];
         
         %selection of non artefacted epochs among raw epochs
         EEG_data_cleaned=raw_EEG_data_cleaned(:,:,epochs_to_keep);
         %select of labels of interest for keeped epochs
         EEG_data_cleaned_labels=rightly_labelled_epochs(epochs_to_keep);

    %% Concatenation of data matrices from all subjects
         if s==1
             all_data_matrice=EEG_data_cleaned;
             all_labels_vector=EEG_data_cleaned_labels;
             % rearrange dimensions of matrice is a prerequisite for next
             % concatenations
             all_data_matrice_permuted=permute(all_data_matrice,[1 3 2]);
         else
             new_data_matrice=EEG_data_cleaned;
             new_label_vector=EEG_data_cleaned_labels;
             % rearrange dimensions of matrice is a prerequisite for concatenation
             new_data_matrice_permuted=permute(new_data_matrice,[1 3 2]); 
             % concatenationne
             all_data_matrice_permuted=[all_data_matrice_permuted new_data_matrice_permuted];
             all_labels_vector=[all_labels_vector new_label_vector];
         end     
    end
    
    %% rearrange dimensions of the matrice as other matrices
    all_data_matrice=permute(all_data_matrice_permuted,[1 3 2]);

% Step 7: Clustering epochs function of labels in order to balance training
% data in terms of labels (50% with -1 and +1). This balance is a
% prerequisite to optimise performance QDA & LDA classification approach;
% ------------------------------------------------------------------------------------    
    
    all_like_labels=find(all_labels_vector == 1);
    all_dislike_labels=find(all_labels_vector == -1);
    all_like_data_matrice=all_data_matrice(:,:,all_like_labels);
    all_dislike_data_matrice=all_data_matrice(:,:,all_dislike_labels);
    
% Step 8: Select randomly data targeted for
%           (i)  training the classifier: 80% of all epochs (irrespective to subjects), with a balance about labels (50% -1 et +1)
%           (ii) testing the model: 20% remaining data
% --------------------------------------------------------------------------------------------------------------------------------

    % Random selection of epochs with label (+1)
    epochs_like=linspace(1,size(all_like_data_matrice,3),size(all_like_data_matrice,3));
    epochs_like_for_training = transpose(randsample(length(epochs_like),(0.5*0.7*length(all_labels_vector)))); 
    
    % Random selection of epochs with label (-1)
    epochs_dislike=linspace(1,size(all_dislike_data_matrice,3),size(all_dislike_data_matrice,3));
    epochs_dislike_for_training = transpose(randsample(length(epochs_dislike),(0.5*0.7*length(all_labels_vector)))); 
    
    % Define remaining as epochs for testing model
    epochs_like_for_testing_model = epochs_like;epochs_like_for_testing_model(epochs_like_for_training)=[]; % epochs for testing model are remaining epochs 
    raw_epochs_dislike_for_testing_model = epochs_dislike;raw_epochs_dislike_for_testing_model(epochs_dislike_for_training)=[];
    epochs_dislike_for_testing_model=randsample(length(raw_epochs_dislike_for_testing_model),length(epochs_like_for_testing_model));

    % Finally create data for training & testing model
%     training_data=all_data_matrice(:,:,[epochs_like_for_training epochs_dislike_for_training]);
%     training_labels=all_labels_vector([epochs_like_for_training epochs_dislike_for_training]);
%     testing_data=all_data_matrice(:,:,[epochs_like_for_testing_model epochs_dislike_for_testing_model]);
%     testing_labels=all_labels_vector([epochs_like_for_testing_model epochs_dislike_for_testing_model]);
    
    like_training_data=all_like_data_matrice(:,:,[epochs_like_for_training]);
    like_training_labels=all_like_labels(epochs_like_for_training);
    dislike_training_data=all_dislike_data_matrice(:,:,[epochs_dislike_for_training]);
    dislike_training_labels=all_dislike_labels(epochs_dislike_for_training);
    training_data=[permute(like_training_data,[1 3 2]) permute(dislike_training_data,[1 3 2])];training_data=permute(training_data,[1 3 2]);
    training_labels=all_labels_vector([like_training_labels dislike_training_labels]);
    
    like_testing_data=all_like_data_matrice(:,:,[epochs_like_for_testing_model]);
    like_testing_labels=all_like_labels(epochs_like_for_testing_model);
    dislike_testing_data=all_dislike_data_matrice(:,:,[epochs_dislike_for_testing_model]);
    dislike_testing__labels=all_dislike_labels(epochs_dislike_for_testing_model);
    testing_data=[permute(like_testing_data,[1 3 2]) permute(dislike_testing_data,[1 3 2])];testing_data=permute(testing_data,[1 3 2]);
    testing_labels=all_labels_vector([like_testing_labels dislike_testing__labels]);

    %save training and testing matrices as MATLAB files for next steps on
    %SIGMA toolbox

        data_SIGMA_folder = sprintf('Data_for_SIGMA_box');
        if ~exist(data_SIGMA_folder, 'dir') == 1 % create the folder if it doesn't exist already
            mkdir([old_pwd,'Data_for_SIGMA_box']);
            pwd=[old_pwd,'Data_for_SIGMA_box\'];
        else
            pwd=[old_pwd,'Data_for_SIGMA_box\'];
        end

        % save matrice data for training classifier
        raw_s_EEG=struct('data',double(training_data),'labels',double(training_labels),'subject_number',1,'sampling_rate',500,'channel_names',{{'P7'  'P4'  'Cz'  'Pz'  'P3'  'P8'  'O1'  'O2'  'T8'  'F8'  'C4'  'F4'  'Fp2'  'Fz'  'C3'  'F3'  'Fp1'  'T7'  'F7'}});
        s_EEG=struct(raw_s_EEG);
        save([pwd,'subject_1.mat'],'s_EEG');
        
        % save matrice data for testing model
%         s_EEG_testing.subject_number=2; % 1 for training, 2 for testing
%         s_EEG_testing.sampling_rate=500;
%         s_EEG_testing.channel_names={'P7'  'P4'  'Cz'  'Pz'  'P3'  'P8'  'O1'  'O2'  'T8'  'F8'  'C4'  'F4'  'Fp2'  'Fz'  'C3'  'F3'  'Fp1'  'T7'  'F7'};
%         s_EEG_testing.data=testing_data;
%         s_EEG_testing.labels= testing_labels;
%         save([pwd,'Data_for_test.mat'],'-struct','s_EEG_testing');
        raw_s_EEG=struct('data',double(testing_data),'labels',double(testing_labels),'subject_number',2,'sampling_rate',500,'channel_names',{{'P7'  'P4'  'Cz'  'Pz'  'P3'  'P8'  'O1'  'O2'  'T8'  'F8'  'C4'  'F4'  'Fp2'  'Fz'  'C3'  'F3'  'Fp1'  'T7'  'F7'}});
        s_EEG=struct(raw_s_EEG);
        save([pwd,'subject_2.mat'],'s_EEG');

% Step 9: Create randomly fake subject data 
% -----------------------------------------

    % Overall parameters
    number_of_fake_subjects=14;
    fake_training_data=training_data;
    
    % Create matrice of data
    for fake_s=10:(number_of_fake_subjects+10)
        fake_subject_data=[];
        if fake_s==10
            fake_subject_labels=transpose(randsample(length(training_labels),size(training_data,3)/number_of_fake_subjects));
            remaining_fake_subject_labels=training_labels;remaining_fake_subject_labels(fake_subject_labels)=[];
        else
            fake_subject_labels=transpose(randsample(length(remaining_fake_subject_labels),size(training_data,3)/number_of_fake_subjects));
            remaining_fake_subject_labels(fake_subject_labels)=[];
        end
        fake_subject_data=fake_training_data(:,:,[fake_subject_labels]);
  
        
    %save filtered data into a new folder 'Fake_subjects_data' as MATLAB file 
            if fake_s==10
                pwd=old_pwd;
                fake_subjects_data_folder = sprintf('Fake_subjects_data');
                if ~exist(fake_subjects_data_folder, 'dir') == 1 % create the folder if it doesn't exist already
                    mkdir([pwd,'Fake_subjects_data']);
                    pwd=[old_pwd,'Fake_subjects_data\'];
                else
                    pwd=[old_pwd,'Fake_subjects_data\'];
                end
            else
                pwd=[old_pwd,'Fake_subjects_data\'];
            end
            
            
        raw_s_EEG=struct('data',double(fake_subject_data),'labels',double(fake_subject_labels),'subject_number',fake_s,'sampling_rate',500,'channel_names',{{'P7'  'P4'  'Cz'  'Pz'  'P3'  'P8'  'O1'  'O2'  'T8'  'F8'  'C4'  'F4'  'Fp2'  'Fz'  'C3'  'F3'  'Fp1'  'T7'  'F7'}});
        s_EEG=struct(raw_s_EEG);
        save([pwd,'subject_',num2str(fake_s),'.mat'],'s_EEG');
    end
        
        display "Processing finished"
        
        
% Step 10: Machine learning with SIGMA box
% ---------------------------------------        
        
        
        
