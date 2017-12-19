% this function provides a user interface to identify for each epochs
% the blinking and eye artifact (in the 5% most extreme values)

function clean_s_EEG=remove_eye_artifact(s_EEG)
    % s_EEG has to be normalized and centered before.
    data = s_EEG.data;
    channel_names = s_EEG.channel_names;
    data_size = size(data);
    nb_epochs = data_size(3);
    nb_channels = length(channel_names);
    is_epoch_clean = [];
    
    for i=1:nb_epochs
        for j=1:nb_channels
            delete(findall(0, 'Type', 'figure'));
            x=1:data_size(2);
            y_inf = -1.96*ones(1, data_size(2));
            y_sup = 1.96*ones(1, data_size(2));
            
            plot(x, data(j,:,i)); hold on
            plot(x, y_sup); hold on
            plot(x, y_inf); hold on
            str = "Subject number : "+s_EEG.subject_number+" / Epoch: "+int2str(i)+" / Channel: "+channel_names{j}; 
            title(str);
            prompt = 'Is channel artifacted ? (1/0)';
            s = input(prompt)
            if s==1
                is_epoch_cleaned(i)=false;
                break
            end
        end
        
        % try for 3 epochs and break
        if i==2
            break
        end
    end
    clean_epoch_index = find(is_epoch_clean);
    s_EEG.data = data(:,:, clean_epoch_index);
    s_EEG.labels = s_EEG.labels(clean_epoch_index);
    
    clean_s_EEG = s_EEG;
end