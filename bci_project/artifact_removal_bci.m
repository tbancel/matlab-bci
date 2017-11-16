delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

filenames={'Tinder_S1.mat', 'Tinder_S2.mat', 'Tinder_S3.mat', 'Tinder_S4.mat', 'Tinder_S5.mat', 'Tinder_S6.mat', 'Tinder_S7.mat', 'Tinder_S8.mat' };
files_count = length(filenames);

clean_data_folder_pathname='/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/clean-data/';

artefact_variance_threshold = 7;
sprintf("Artefact variance threshold : " + artefact_variance_threshold) 

% Here we define the threshold in (microV)
% delta in voltage above which an epoch will be erase

% Define filter
f1=0.5; %cuttoff low frequency to get rid of baseline wander
f2=45; %cuttoff frequency to discard high frequency noise

 
% loop on all subjects
for i=1:files_count
    filename=filenames{i};
    
    load(strcat('data-project/',filename));

    data = s_EEG.data;
    fs = s_EEG.sampling_rate;
    channel_names = s_EEG.channel_names;
    
    Wn=[f1 f2]*2/fs; % cutt off frequencie based on fs
    N = 3; % order of 3 less processing
    [a,b] = butter(N,Wn); %bandpass butterworth filter
    
    size_data = size(data);
    number_of_epochs = size_data(3);

    % data filtering
    filtered_data = filtfilt(a,b,data);
    
    % TODO vérifier qu'on obtient la même chose que le calcul manuel ?
    norm_data = zscore(filtered_data,0,2);
   
    % data centering (remove the average signal for each channel on all data)
    % average_filtered_data_channel = mean(filtered_data,2); % average on each channel
    % center_data = filtered_data - average_data_channel;
    
    % data reduction (centered divided by the standard deviation):
    % std_epoch_norm_data = std(center_data,0,2);
    % norm_data=center_data./std_epoch_norm_data;
    
    % calculate the min and max variation for each channel for each epoch
    % 19 x 1 x #epochs size of array.
    max_norm_data = max(norm_data,[],2);
    min_norm_data = min(norm_data,[],2);
    
    % calculate the max variation for each channel and each epoch
    delta = max_norm_data-min_norm_data;
    
    % the max among all channels for each epochs
    epoch_max_delta_norm = max(delta,[],1);
    
    epoch_wo_artifact = epoch_max_delta_norm < artefact_variance_threshold;
    
    number_of_epochs_wo_artifact = sum(epoch_wo_artifact);
    
    display(filename+": Number of epochs :"+number_of_epochs+" / Number of epochs without artefact : "+number_of_epochs_wo_artifact);
    
    % index of cleaned epochs
    clean_epoch_index = find(epoch_wo_artifact);
    % display("Clean epoch index"+strcat(clean_epoch_index));
    
    % artifact removal (all epoch where at least one epochs variates too
    % much (ie more than XX times std) is eliminated)
    norm_data_wo_artefact = norm_data(:,:, clean_epoch_index);
    
    % s_EEG structure creation that we will save
    s_EEG.labels = s_EEG.labels(clean_epoch_index);
    s_EEG.data = norm_data_wo_artefact;
    
    clean_data_filename = strcat(clean_data_folder_pathname,filename,'_clean_epochs_normalized_and_filtered.mat');
    
    save(clean_data_filename, 's_EEG');
    display(filename+" treated and saved");
    display("============");
end

% plot_epoch(norm_data(:,:,1), fs, channel_names)

% illustrate all treatement on 1 channel for 1 epoch
% here we take the first clean epoch
% clean_epoch_number = 1
% subplot(2,1,1)
% plot(data(1,:,clean_epoch_index(1)))
% subplot(2,1,2)
% plot(filtered_norm_data(1,:,1))

% high pass filter
% remove the average for each channel
% remove frequencies below 0.5Hz
% remove 49-51 and 59-61Hz
% remove blinking artefact (value beyond a certain threshold)
% save file

function plot_epoch(epoch_data, fs, channel_names)
    % plot data for each channel given a specific epoch
    % epoch_data is 19x1000 array
    
    % 2 seconds x_axis (temporal)
    Ts = 1/fs;
    x = Ts:1/fs:2;
    
    channel_number = length(epoch_data(:,1))
    for i=1:channel_number
        subplot(channel_number, 1, i)
        plot(epoch_data(i,:))
        ax = gca;
        ax.XTick = [];
        ax.XTickLabelMode = 'manual';
        ax.YTick = [-10,0,10];
        ax.YTickLabelMode = 'manual';
        title(channel_names(i), 'Position', [1,0])
    end
end

%% Commented Code but could be useful
% choose epoch: here epoch 1 for instance
% epoch_number = 1;
% epoch_data=data(:,:,epoch_number);

% figure(1)
% plot_epoch(data(:,:,1), fs)
% figure(2)
% plot_epoch(norm_data(:,:,1), fs)

% subplot(2,1,1)
% plot(norm_data_wo_artefact(1,:,1))
% subplot(2,1,2)
% plot(X(1,:,1))