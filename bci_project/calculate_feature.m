% calculating in command line time_sample_entropy for band 1 on every
% channel and every epoch for subject 2

load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/export_sigma_box/init_method.mat')
load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/export_sigma_box/subject_2.mat')

% Parameters of the scripts
feature_method_number = 3;
selected_bands = [1, 2, 3];


init_parameter.apply_filter = [1];
init_parameter.nb_bands = length(selected_bands);
init_parameter.selected_band =  selected_bands;
init_parameter.filt_band_param = [dfilt.df2sos dfilt.df2sos dfilt.df2sos];
init_parameter.method = [feature_method_number];

Nmethode = 1;
Nsubj = 1;

% refer to init_method 
% method_chosen = 'time_sample_entropy';

data = s_EEG.data;
nb_epoch=size(s_EEG.data,3);
subject_epoch = [];


for Nepochs=1:nb_epoch
    method_name=init_method(feature_method_number).method_name;
    eval(method_name);  
    
    str = method_name + " calculated for Epoch " + Nepochs;
    disp(str)
end