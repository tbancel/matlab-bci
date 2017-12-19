function [predicted_labels, time_to_execute_function] = my_BCI(s_EEG, model_folder_path, test_folder_path)
  % raw_s_EEG must be formatted like a s_EEG file

  tic

  % load the file to initialize the SIGMA box
  % load the model which best performs after a lot of computation
  load(strcat(model_folder_path,'init_method.mat'));
  load(strcat(model_folder_path,'selected_model.mat'));
  load(strcat(model_folder_path,'init_parameter.mat'));
  
  % preprocess the data:
  preprocessed_s_EEG = preprocess_raw_EEG(s_EEG);

  % create a s_EEG subject file in the SIGMA test_directory:
  s_EEG.subject_number = 5;
  s_EEG.data = preprocessed_s_EEG.data
  filename = strcat(test_folder_path, 'subject_5.mat');
  save(filename,'s_EEG');

  % change the init_parameter:
  init_parameter.subject_for_test = 5;

  % run the calculation using the Sigma_apply_model0:
  [computed_feature_new_data, predicted_labels, predicted_scores,validation_results,validation_results_infos]=Sigma_apply_model0(init_parameter,init_method,selected_model,'Application');

  time_to_execute_function = toc;
end