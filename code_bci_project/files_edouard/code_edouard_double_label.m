load('Users/Edouardmalandain/Documents/MATLAB/SIGMA_V2/SIGMA/SIGMA_data/subject_1.mat')  % your pathway directory
s_EEG.labels=double(s_EEG.labels);
save('subject_1_double.mat','s_EEG');
class(s_EEG.labels) %confirmation