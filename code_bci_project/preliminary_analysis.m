% Preliminary analysis of Timder database
% Dec.13

clc
clear all
close all

tic
%% data loading
% data loading
load 'D:\Download\v12dec_datasets_training_testing_model\subject_1.mat';
eeg1 = s_EEG;
% load 'D:\MJ\ѧϰ\curriculum\UE3.7-8 BCI\BCI_project\SIGMA_svm\SIGMA_svm\SIGMA\SIGMA_data\subject_for_test\subject_2.mat';
% eeg2 = s_EEG;
% data parameter
fs = s_EEG.sampling_rate;% sample rate

%% label collection
% converge the eeg data
% eeg_labels = cat(2,eeg1.labels,eeg2.labels);
% eeg_data = cat(3,eeg1.data,eeg2.data);
eeg_labels = eeg1.labels;
eeg_data=eeg1.data;

% find like=1, dislike=-1
likes_index_labels = find(eeg_labels == 1);
dislikes_index_labels = find(eeg_labels == -1);
number_of_likes = length(likes_index_labels);
number_of_dislikes = length(dislikes_index_labels);

% converge the data
eeg_like = eeg_data(:,:,likes_index_labels);
eeg_dislike = eeg_data(:,:,dislikes_index_labels);
eeg_data_conv = cat(3,eeg_like,eeg_dislike);

%% freqband analysis
% fast Fourier transform
epoch_nfft = size(eeg_data_conv,2);
% F = ((0:1/epoch_nfft:1/2-1/epoch_nfft)*fs);%1/epoch_nfft is the frequency resolution
F = (0:epoch_nfft/2-1)/epoch_nfft;
F = F * fs;
Freq = [1,4,8,12,25];
n_Freq = (Freq/fs+1/fs)*epoch_nfft;



for i = 1:size(eeg_data_conv,3)
    for j = 1:19
%         wo = 50/(500/2);  
%         bw = wo/45;
%         [b,a] = iirnotch(wo,bw);
%         eeg_data_notch(j,:,i) =filtfilt(b,a,eeg_data(j,:,i));
%         freq_fft(j,:,i) = abs(fft(eeg_data_notch(j,:,i),epoch_nfft)); 
        freq_fft(j,:,i) = abs(fft(eeg_data(j,:,i),epoch_nfft)); 
%         figure
%         plot(F,freq_fft(j,1:500,i))
%         title(['Single-Sided Amplitude Spectrum by FFT, Channel-',num2str(j),'  Epoch-',num2str(i)])
%         xlabel('Frequency(Hz)');
%         ylabel('Magnitude');

        %Total Magnitude
        Mag_total(j,i)=sum(freq_fft(j,:,i))/epoch_nfft/2;
        % Reletive power 
        m(j,i) = sum(freq_fft(j,1:n_Freq(1),i))/epoch_nfft/Mag_total(j,i);
        d(j,i) = sum(freq_fft(j,n_Freq(1):n_Freq(2),i))/epoch_nfft/Mag_total(j,i);
        t(j,i) = sum(freq_fft(j,n_Freq(2):n_Freq(3),i))/epoch_nfft/Mag_total(j,i);
        a(j,i) = sum(freq_fft(j,n_Freq(3):n_Freq(4),i))/epoch_nfft/Mag_total(j,i);
        b(j,i) = sum(freq_fft(j,n_Freq(4):n_Freq(5),i))/epoch_nfft/Mag_total(j,i);
        e(j,i) = sum(freq_fft(j,n_Freq(5):500,i))/epoch_nfft/Mag_total(j,i);
        q(j,i) = sum(freq_fft(j,1:500,i))/epoch_nfft/Mag_total(j,i);

        
    end
end


freqband_fft = cat(3,d,t,a,b);
freqband_fft_like = freqband_fft(:,1:number_of_likes,:);
freqband_fft_dislike = freqband_fft(:,number_of_likes+1:end,:);

% mean
mean_d_like = mean(d(:,1:number_of_likes),2);
mean_t_like = mean(t(:,1:number_of_likes),2);
mean_a_like = mean(a(:,1:number_of_likes),2);
mean_b_like = mean(b(:,1:number_of_likes),2);
mean_like = cat(2,mean_d_like,mean_t_like,mean_a_like,mean_b_like);

mean_d_dislike = mean(d(:,number_of_likes+1:end),2);
mean_t_dislike = mean(t(:,number_of_likes+1:end),2);
mean_a_dislike = mean(a(:,number_of_likes+1:end),2);
mean_b_dislike = mean(b(:,number_of_likes+1:end),2);
mean_dislike = cat(2,mean_d_dislike,mean_t_dislike,mean_a_dislike,mean_b_dislike);

% standard deviation
std_d_like = std(d(:,1:number_of_likes),0,2);
std_t_like = std(t(:,1:number_of_likes),0,2);
std_a_like = std(a(:,1:number_of_likes),0,2);
std_b_like = std(b(:,1:number_of_likes),0,2);
std_like = cat(2,std_d_like,std_t_like,std_a_like,std_b_like);

std_d_dislike = std(d(:,number_of_likes+1:end),0,2);
std_t_dislike = std(t(:,number_of_likes+1:end),0,2);
std_a_dislike = std(a(:,number_of_likes+1:end),0,2);
std_b_dislike = std(b(:,number_of_likes+1:end),0,2);
std_dislike = cat(2,std_d_dislike,std_t_dislike,std_a_dislike,std_b_dislike);

%% boxplot for each channel 
figure
for j=1:19
   %     figure
   subplot(4,5,j)
   % Boxplot for the Freqency band (d=1-4,t=4-8,a=8-12,b=12-25)
   Freqname_like = {'d+','t+','a+','b+'};
   position_1 = 1:4;
   % Define position for 4 freqency boxplots
   box_O = boxplot(squeeze(freqband_fft_like(j,:,:)),'colors','b','positions',position_1,'width',0.18)
   set(gca,'XTickLabel',{' '})  % Erase xlabels
   hold on 
   % Boxplot for the dislike
   Freqname_dislike = {'d-','t-','a-','b-'};
   position_0 = 1.2:1:4.2;  % Define position for 4 freqency boxplots
   box_S = boxplot(squeeze(freqband_fft_dislike(j,:,:)),'colors','r','positions',position_0,'width',0.18)
   title(['channel-',num2str(j)])
end

%% t-Test
Freq_name = {'Delta','Theta','Alpha','Beta'};
t_result = zeros(19,4);
for j=1:19
    for k = 1:4
%         disp(['channel',num2str(j)]);
%         disp([Freq_name(k)]);
        t_result(j,k) = ttest(freqband_fft_dislike(j,:,k),freqband_fft_like(j,:,k));
    end
end
%%
toc