clear all
clc

%% Load data & parameters
%File reading
cd ('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/data-project/');
[FileName, PathName] = uigetfile('*.mat');
load(FileName);
raw_EEG_data=s_EEG.data; % select EEG data
behavioral_data=s_EEG.labels; % select responses of subject (+1= I like, -1= I dislike)
%Parameters
subject_number=s_EEG.subject_number;
fs=s_EEG.sampling_rate;
channel_names=s_EEG.channel_names

%% Signal normalization
for i = 1:5 
    for j = 1:5
        for k = 1:1000
            log_raw_EEG_data(j,k,i)=log(raw_EEG_data(j,k,i));
            %raw_EEG_data(j,k,i)=abs(raw_EEG_data(j,k,i));
            %mean_raw_EEG_data(j,k,i)=mean(raw_EEG_data(j,:,i));
            %std_raw_EEG_data(j,k,i)=std(raw_EEG_data(j,:,i));
            %normalized_raw_EEG_data(j,k,i)=raw_EEG_data(j,k,i)-mean_raw_EEG_data(j,k,i)/std_raw_EEG_data(j,k,i);     
        end
    end
end

%% Noise cancelation (filtering)
f1=0.5; %cuttoff low frequency to get rid of baseline wander
f2=45; %cuttoff frequency to discard high frequency noise
Wn=[f1 f2]*2/fs; % cutt off based on fs
N = 3; % order of 3 less processing
[a,b] = butter(N,Wn); %bandpass filtering
EEG_data_filtered = filtfilt(a,b,raw_EEG_data);
%Plot raw and filtered signal
ax(1) = subplot(211);plot(raw_EEG_data(1,:,1));axis tight;title('Raw EEG signal')
    ylabel('Amplitude')
ax(2) = subplot(212);plot(EEG_data_filtered(1,:,1));axis tight; title('Filtered EEG signal');
    ylabel('Amplitude')
    



