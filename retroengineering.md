Sigma BOX Retro-engineering

Gui_main_function executes Gui_mainfcn at line 42.

gui_aure_v1_OpeningFcn is the main function to understand.

> handles represent the GUI as far as I understand.


1. Compute features 
handles = compute_features(handles, hObject);

SIGMA > SIGMA_gui > gui_function > compute_features.m

Sigma_feature_extraction.m

Start here:

At line 374 of gui_aure_v1, we see the callback function to compute features.
```matlab
function FEM_pb_compute_Callback(hObject, eventdata, handles)
% compute the features
handles = compute_features(handles, hObject);
```
At line 16 of the `compute_features.m` file in the folder `SIGMA > SIGMA_gui > gui_function` the Sigma_feature_extraction function is called.

Sigma_main > sigma_feature_extraction.m


At line 115 of Sigma_feature_extraction, it is the first execution of feature computing !!!!

```init_method(init_parameter.method(Nmethode)).method_name```

In our working example, it is ```time_sample_entropy```
sigma_script > features_extraction/time_sample_entropy.m

%% It is a script (it can be executed as a script or as a function)

It applies the filter first, then calculate the fc_sample_entropy(dim,r,dataM, tau)
located in `SIGMA > SIGMA_external >` folder. It was written by someone else.

At the end of the calculation, ```features_results.o_time_sample_entropy=o_time_sample_entropy;``` stores the result in the features_results structure.

We see that the script loops first on the channel, and then on the band.
Therefore, the time_sample_entropy array first 3 elements are the time_sample_entropy calculated for each band on the FIRST channel.


The next step is to understand feature_assembling



------------------

2. Compute feature ranking

At line 82, we see the `update_feature_ranking`

```matlab
handles = update_feature_ranking(handles, hObject);
```

------------------

3. Compute classification

SIGMA > SIGMA_gui > gui_function > compute_classification

sigma_cross_validation_

At line 508, the callback function for classification calls compute_classification

```function DC_pb_compute_Callback(hObject, eventdata, handles)
% compute the classification
handles = compute_classification(handles, hObject);
guidata(hObject, handles);```




-------------------


Notes : 


```matlab
if (apply_filter==1)
for Nband=1:init_parameter.nb_bands
filt=init_parameter.filt_band_param;
fdata = filter(filt(Nband),i_EEG);

o_time_sample_entropy0 = fc_sample_entropy( dim, r*std(fdata), fdata, tau );       
o_time_sample_entropy_ch =[o_time_sample_entropy_ch,o_time_sample_entropy0];
% Track the identification of the band
if((Nsubj==1)&&(Nepochs==1))
temp0=[temp0; init_parameter.method(Nmethode) Nchannel init_parameter.selected_band(Nband) ];
end
end
else
o_time_sample_entropy0 = fc_time_sample_entropy( dim, r*std(i_EEG), i_EEG, tau );;
o_time_sample_entropy_ch =[o_time_sample_entropy_ch,o_time_sample_entropy0];
% Track the identification of the band
if ((Nsubj==1)&&(Nepochs==1))
temp0=[temp0;init_parameter.method(Nmethode) Nchannel nan];
end    
end

% o_time_sample_entropy0 = fc_time_sample_entropy( dim, r*std(i_EEG), i_EEG, tau );
% o_time_sample_entropy_ch =[o_time_sample_entropy_ch,o_time_sample_entropy0];
clear o_time_sample_entropy0
end
o_time_sample_entropy_epo=o_time_sample_entropy_ch';  
o_time_sample_entropy=[o_time_sample_entropy o_time_sample_entropy_epo];

features_results.o_time_sample_entropy=o_time_sample_entropy;

if ((Nsubj==1)&&(Nepochs==1))
features_results.o_time_sample_entropy_band=temp0;
end    
``

NB:

Ce qu'il faut bien comprendre c'est les 3 structures suivantes: 

handles.init_parameters
handles.features_results
handles.


Ou se trouvent les data ?

s_EEG contient (pour les données de la section 2)
> data (#electrodes x #datapoints x #epochs)
> subject_number = 1
> sampling_rate = 2000

Les données du TP Tinder sont formatées exactement de la même manière - malheureusement nous n'avons pas les données sur les images.

