% calculating in command line time_sample_entropy for band 1,2,3 on every
% channel and every epoch for subject 2

load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/export_sigma_box/init_method.mat')
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/export_sigma_box/subject_2.mat')

% Parameters of the scripts
% to chose the method of the feature and the bands, refer to the init_method structure

% In this specific example, the chosen feature is 'time_sample_entropy' on the first 3 channels.

feature_method_number = 3;
selected_bands = [1, 2, 3];

% to make the script compatible with the sigma box
init_parameter.apply_filter = [1];
init_parameter.nb_bands = length(selected_bands);
init_parameter.selected_band =  selected_bands;
init_parameter.filt_band_param = [dfilt.df2sos dfilt.df2sos dfilt.df2sos];
init_parameter.method = [feature_method_number];
Nmethode = 1;
Nsubj = 1;
data = s_EEG.data;
nb_epoch=size(s_EEG.data,3);
subject_epoch = [];

% looping on all epochs
% using the eval trick to transform a string into a method name
for Nepochs=1:nb_epoch
    method_name=init_method(feature_method_number).method_name;
    disp(method_name);
    eval(method_name);  
    
    str = method_name + " calculated for Epoch " + Nepochs;
    disp(str)
end

% it creates several variables along the way, the output is stored in the o_time_sample_entropy array.
% The next step is to understand :
% > feature assembly
% > feature ranking