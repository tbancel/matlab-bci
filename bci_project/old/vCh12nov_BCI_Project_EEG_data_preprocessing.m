clear all
clc

%% Load data & parameters

%Files reading
filenames={'Tinder_S1.mat', 'Tinder_S2.mat', 'Tinder_S3.mat', 'Tinder_S4.mat', 'Tinder_S5.mat'};
files_count = length(filenames);

for s=1:length(filenames) % filecount
    pwd='C:\Users\Charles VERDONK\Documents\MATLAB\Data\BCI_Project\Raw_data\'; % your pathway to folder containing EEG data
    old_pwd=pwd
    filename=filenames{s};
    %load(strcat(filename));
    %load(strcat([pwd,'Raw_data\'],filename));
    load(strcat(pwd,filename));
    raw_EEG_data=s_EEG.data; % select EEG data
    behavioral_data=s_EEG.labels; % select responses of subject (+1= I like, -1= I dislike)

    %Parameters
    subject_number=s_EEG.subject_number;
    fs=s_EEG.sampling_rate;
    channel_names=s_EEG.channel_names;

%% Signal normalization
for i = 1:1 
    for j = 1:19
        for k = 1:1000
            normalized_EEG_data(j,:,i)=zscore(raw_EEG_data(j,:,i));     
        end
    end
end
%Check normalized data
mean_normalized_data=mean(normalized_EEG_data,2); %if mean value near zero > OK
std_normalized_data=std(normalized_EEG_data,0,2); %if standard deviation value equal to 1 > OK

%% Noise filtering

%%%%%%%%%%% Cancellation of noise components (eye blink, muscle activity,
%powerline interference & baseline wandering) with band pass filter
f1=0.5; %cuttoff low frequency to get rid of baseline wander
f2=50; %cuttoff frequency to discard high frequency noise
Wn=[f1 f2]*2/fs; % cutt off based on fs
N = 3; % order of 3 less processing
[a,b] = butter(N,Wn); %bandpass filtering
EEG_data_filtered = filtfilt(a,b,normalized_EEG_data); %zero phase filter to prevent phase shift of filtered signal

%%%%%%%%%% Identification of remaining noise components based on channel 
%statistics. Noise is signal with amplitude going out of the confident 
%interval at 95% of signal distribution (assumed as gaussian). Therefore
%the treshold is defined as 1.96*standard deviation of the signal.
%This agorithm uses the state-machine logic to determine remaining noise
%components. 
%NB:: code written below actually is a modified version of the algorithm
%'peak_detect' proposed by Hooman Sedghamiz (2014).  



for i = 1:1
    for j = 1:19
   
        %Parameters
        %Fp1 is the channel of interest because artefacts, for instance eye blinks,
        %are mainly visible on it
        [a,channel_index]= ismember('Fp1',channel_names) % find FP1 channel
        epoch_index=1 % selection of epoch to plot at the end
        
        %%%%% Firstly make signal more horizontal in applying a Notch filter
        %(50Hz).It seems impossible to apply a Notch filter to a multidimensional
        %matrix, therefore I apply it at this step of processing.
        data_Notch_filter=EEG_data_filtered(j,:,i); 
        Fs = fs/2;
        Fnotch = 50;     % Notch Frequency
        BW     = 0.8;  % Bandwidth
        Apass  = 0.1;      % Bandwidth Attenuation
        [b, a] = iirnotch(Fnotch/(Fs/2), BW/(Fs/2), Apass);
        data_detection_algorithm=locdetrend(filter(b,a,data_Notch_filter),Fs,[0.5 0.1]);
        if i==1 && j==channel_index %store data from 1rst epoch and channel FP1 to plot later
            data_detection_algorithm_Fp1=data_detection_algorithm;
        end
            
        %%Parameters
        artefact_max_ind = [];%save index of artefact
        artefact_max_amp = []; %save maximum amplitude of artefact
        data_k_plot =[];
        list_data_k=[];
        current_max = 0
        current_k = 0
        ind = 0
        state = 0 ; % determines the state of the machine in the algorithm
        dum = 0; %counter for detecting the artefact
        standard_deviation=std(data_detection_algorithm)
        
        for k = 1:1000
            fprintf('Epoch analyzing: %d\n', i);
            fprintf('Channel analyzing %d\n', j);
            fprintf('Analysis of sample point %d\n', k);
            
            list_data_k = [list_data_k data_detection_algorithm(k)];
            current_k = list_data_k(k);
            data_k_plot =[list_data_k];
            
            %Enter state as soon as that the signal exceeds the threshold
            if state == 0
                if k > 1
                    if abs(current_k) >= 1.96*standard_deviation && abs(data_k_plot(k-1)) > abs(data_k_plot(k))
                        state = 1; % entered in detection mode of maximum of artefact amplitude
                        current_max = abs(data_k_plot(k-1));
                        ind = k-1;
                    else
                        state = 0;
                    end
                end
            end

            %Locate the maximum of artefact amplitude by finding the highest local maxima
            if state == 1 % look for the highest peak
                if  current_max > abs(data_k_plot(k))
                    dum = dum + 1;
                    artefact_max_ind = [artefact_max_ind ind];%save index
                    artefact_max_amp = [artefact_max_amp data_k_plot(ind)]; %save index
                    state = 2; % change state of machine
                else
                    dum = 0;
                    state = 0;
                end
            end
            
            %Check whether the signal drops below the threshold
            if state == 2
                if abs(current_k) <= 1.96*standard_deviation
                state = 0;
                end
            end
        end
        
        %store data about artefacts (index, amplitude)
        %if s==1 && i==1 && j==1
            %mkdir('..\Data\BCI_Project','Artefacts_infos') % create a specific folder to store artefacts informations
            %pwd=([old_pwd,'Artefacts_infos\'])
        %else
        %    pwd=([old_pwd,'Artefacts_infos\'])
        %end
        
        if i == 1 && j == 1
                results_file = fopen([pwd,'Tinder_S',num2str(subject_number),'_artefacts_infos.txt'],'wt');	
                fprintf(results_file,['\nEpoch ',num2str(i),', Channel ',num2str(j)])
                fprintf(results_file,'\n>Indexes: ');
                fprintf(results_file, '%i\t',artefact_max_ind)
                fprintf(results_file,'\n>Amplitudes: ');
                fprintf(results_file, '%2.4f\t',artefact_max_amp)
                fclose(results_file)
        else
                results_file = fopen([pwd,'Tinder_S',num2str(subject_number),'_artefacts_infos.txt'],'at');	
                fprintf(results_file,['\nEpoch ',num2str(i),', Channel ',num2str(j)]);
                fprintf(results_file,'\n>Indexes: ');
                fprintf(results_file, '%i\t',artefact_max_ind)
                fprintf(results_file,'\n>Amplitudes: ');
                fprintf(results_file, '%2.6f\t',artefact_max_amp)
                fclose(results_file)
        end
        %in particular, storing data from 1rst epoch and channel FP1 to plot later
        if i==1 && j==channel_index
            artefact_max_ind_first_epoch_FP1=artefact_max_ind;
            artefact_max_amp_first_epoch_FP1=artefact_max_amp;    
        end
    end
end
    %Check filter output with plots
    %close all
    f=figure
    ax(1) = subplot(311);plot(raw_EEG_data(channel_index,:,epoch_index));axis tight;title(['Raw EEG signal on ',channel_names{channel_index}])
        ylabel('Amplitude')
    ax(2) = subplot(312);plot(EEG_data_filtered(channel_index,:,epoch_index));axis tight;title(['Filtered EEG signal on ',channel_names{channel_index}]);
        ylabel('Amplitude')
    ax(3) = subplot(313);plot(data_detection_algorithm_Fp1);axis tight;
        hold on,scatter(artefact_max_ind_first_epoch_FP1,artefact_max_amp_first_epoch_FP1,'r');
        title(['EEG signal on ',channel_names{channel_index},' with identification of extrema (potentials remaining artefacts)'])
        ylabel('Amplitude')
        legend('EEG Signal','Potentials artefacts','Location','Best','Orientation','horizontal');  
        suptitle(['Data Subject ',num2str(subject_number)])
end
    
    