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
    a_event = zeros(1,srate*2.5);
    a_event(srate+1) = 1;
    
    m_event = zeros(1,srate*3);
    m_event(srate*1.5+1) = 1;
   
    %%
    n_trials = ecog.n_trials;
    n_ch = size(ecog.rest_data,2);
    
    %%
    rest_data = reformsig(ecog.rest_data,n_trials);
    stim_data = reformsig(ecog.stim_data,n_trials);
    button_data = reformsig(ecog.button_data,n_trials);
    
    %% Removing phase reset for each trials
    if isub ~= 5
        clear lp_cue_data lp_stim_data lp_button_data env_data
        fband = [3 30];
        for tr = 1:n_trials
            base_data = rest_data(1:srate,ach_data{isub},tr);
            lp_stim_data(:,:,tr) = giver_steady_pv_for_each_freq_v4(stim_data(:,ach_data{isub},tr),srate,base_data, fband);
            base_data = rest_data(1:srate,mch_data{isub},tr);
            lp_button_data(:,:,tr) = giver_steady_pv_for_each_freq_v4(button_data(:,mch_data{isub},tr),srate,base_data, fband);
        end
        
        %% take average
        stim_erp = mean(lp_stim_data,3);
        stim_erp = baselineCorS(stim_erp',a_event,[-500 0],srate)';
        button_erp = mean(lp_button_data,3);
        button_erp = baselineCorS(button_erp',m_event,[-1400 -900],srate)';
        
        eeg_a_erps{isub} = stim_erp;
        eeg_m_erps{isub} = button_erp;
    else
        clear lp_cue_data lp_stim_data lp_button_data env_data
%         fband = [3 199];
        for tr = 1:n_trials
            base_data = rest_data(1:srate,ach_data{isub},tr);
            lp_stim_data(:,:,tr) = giver_steady_pv_for_each_freq_v4(stim_data(:,ach_data{isub},tr),srate,base_data, fband);           
        end
        
        %% take average
        stim_erp = mean(lp_stim_data,3);
        stim_erp = baselineCorS(stim_erp',a_event,[-500 0],srate)';
                
        eeg_a_erps{isub} = stim_erp;
        eeg_m_erps{isub} = nan;
    end
    
end

%%
save no_phase_erp_3_hz_ch_final_400hz eeg_a_erps eeg_m_erps 



