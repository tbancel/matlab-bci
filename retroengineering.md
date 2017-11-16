Sigma BOX Retro-engineering

Gui_main_function executes Gui_mainfcn at line 42.

1. Compute features (where is the handles)
handles = compute_features(handles, hObject);

SIGMA > SIGMA_gui > gui_function > compute_features.m

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

Sigma_main > sigma_feature_extraction.m


2. Compute feature ranking


3. Compute classification

SIGMA > SIGMA_gui > gui_function > compute_classification

sigma_cross_validation_



