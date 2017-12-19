% plot 10 first epochs only first channel

delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

folder_path = '/Users/tbancel/Desktop/MS_BME/UE 3.7-8 BCI/matlab-signal-processing/'
filename = 'clean-data/subject_1.mat'
file_path = strcat(folder_path, filename);

load(file_path)
data = s_EEG.data;

for i=1:19
    subplot(19,1,i);
    plot(data(1,:,i));
    ax = gca;
    ax.XTick = [];
    ax.XTickLabelMode = 'manual';
    ax.YTick = [-10,0,10];
    ax.YTickLabelMode = 'manual';
end
