clear;
clc;
hemi = [1 -1 1 -1 -1 1 1 -1];

load ach_data_final.mat
load mch_data_final.mat

for isub = 1:8
    load(['s' num2str(isub) '_auditory_ds.mat']);
    %%
    ecog
    
    srate = ecog.srate;
    
    %%
    n_trials = ecog.n_trials;
    n_ch = size(ecog.rest_data,2);
    
    %%
    rest_data = reformsig(ecog.rest_data,n_trials);
    stim_data = reformsig(ecog.stim_data,n_trials);
    button_data = reformsig(ecog.button_data,n_trials);
    
    %%
    roi_channels = [ach_data{isub} mch_data{isub}];
    
    %% removing additive power for each trial    
    clear lp_cue_data lp_stim_data lp_button_data
    lp_button_data = [];
    
    if isub ~= 5
        for tr = 1:n_trials
            fprintf('.');
            
            lp_stim_data(:,:,tr) = giver_steady_power_for_each_freq_v4(stim_data(:,ach_data{isub},tr),srate,rest_data(:,ach_data{isub},tr),[3 30]);
            lp_button_data(:,:,tr) = giver_steady_power_for_each_freq_v4(button_data(:,mch_data{isub},tr),srate,rest_data(:,mch_data{isub},tr),[3 30]);
        end
        fprintf('\n');
        
        %% take average
        stim_erp = mean(lp_stim_data,3);
        button_erp = mean(lp_button_data,3);
        
        eeg_a_erps{isub} = stim_erp;
        eeg_m_erps{isub} = button_erp;
    else
        for tr = 1:n_trials
            fprintf('.');
            lp_stim_data(:,:,tr) = giver_steady_power_for_each_freq_v4(stim_data(:,ach_data{isub},tr),srate,rest_data(:,ach_data{isub},tr),[3 30]);
            %             lp_button_data(:,:,tr) = [];
        end
        fprintf('\n');
        %% take average
        stim_erp = mean(lp_stim_data,3);
        button_erp = mean(lp_button_data,3);
        
        eeg_a_erps{isub} = stim_erp;
    end
    
    
    
end

%%
save no_power_erp_3Hz_ch_final_400hz_v1 eeg_a_erps eeg_m_erps 

