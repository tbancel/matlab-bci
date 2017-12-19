function [cleaned_s_EEG] = preprocess_raw_EEG(raw_s_EEG)
  % normalization (zscoring)
  % data filtering (bandpass [0,5Hz - 45Hz])

  cleaned_s_EEG = raw_s_EEG;

  data = raw_s_EEG.data;
  fs = raw_s_EEG.sampling_rate;
  channel_names = raw_s_EEG.channel_names;
  labels = raw_s_EEG.labels;


  size_data = size(data);

  if length(size_data) == 2
    number_of_epochs = 1;
  else
    number_of_epochs = size_data(3);
  end
    
  % normalization
  for i = 1:number_of_epochs % number of epochs for subject
    for j = 1:19
      normalized_EEG_data(j,:,i)=zscore(data(j,:,i));
    end
  end

  % filtering
  f1=0.5; %cuttoff low frequency to get rid of baseline wander
  f2=45; %cuttoff frequency to discard high frequency noise

  Wn=[f1 f2]*2/fs; % cutt off frequencie based on fs
  N = 3; % order of 3 less processing
  [a,b] = butter(N,Wn); %bandpass butterworth filter
    
  % data filtering
  filtered_data = filtfilt(a,b,normalized_EEG_data);

  % change the data attribute of s_EEG structure
  cleaned_s_EEG.data = filtered_data;
end