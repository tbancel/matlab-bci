delete(findall(0, 'Type', 'figure'));
clear;
close;
clc;

load('/Users/tbancel/Desktop/MS_BME/UE 3.6-7 BCI/matlab-signal-processing/clean-data/Tinder_S1.mat_clean_epochs_normalized_and_filtered.mat')
data = s_EEG.data;

for i=1:10
    subplot(10,1,i);
    plot(data(1,:,i));
    ax = gca;
    ax.XTick = [];
    ax.XTickLabelMode = 'manual';
    ax.YTick = [-10,0,10];
    ax.YTickLabelMode = 'manual';
end
