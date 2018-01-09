function [apply_model_out, time_to_execute_function] = my_BCI(s_EEG, model_file_path, sigma_folder_path, sigma_test_folder_path)
  % raw_s_EEG must be formatted like a s_EEG file

  tic

  %%%%%%%
  % load the model
  %
  load(model_file_path);
  
  %%%%%%%
  % preprocess the data:
  %
  preprocessed_s_EEG = preprocess_raw_EEG(s_EEG);

  % create a s_EEG subject file in the SIGMA test_directory:
  s_EEG.subject_number = 5;
  s_EEG.data = preprocessed_s_EEG.data
  filename = strcat(sigma_test_folder_path, 'subject_5.mat');
  save(filename,'s_EEG');

  % change the init_parameter:
  init_parameter.subject_for_test = 5;
  init_parameter.sigma_directory = sigma_folder_path;
  init_parameter.data_location = strcat(sigma_folder_path, 'SIGMA_data/');

  model_in.init_parameter = init_parameter;
  model_in.init_method = init_method;
  model_in.selected_model = selected_model;
  model_in.test_or_application = 'Application';

  apply_model_out = Sigma_apply_model_final(model_in);
  % run the calculation using the Sigma_apply_model0:
  % [computed_feature_new_data, predicted_labels, predicted_scores,validation_results,validation_results_infos]=Sigma_apply_model0(init_parameter,init_method,selected_model,'Application');

  time_to_execute_function = toc;
end