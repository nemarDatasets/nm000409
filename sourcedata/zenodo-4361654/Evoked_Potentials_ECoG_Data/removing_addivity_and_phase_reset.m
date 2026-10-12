clear;
clc;
hemi = [1 -1 1 -1 -1 1 1 -1];

load ach_data_final.mat
load mch_data_final.mat

isub_cnt = 1;

for isub = 1:8
    load(['s' num2str(isub) '_auditory_ds.mat']);
    
    %%
    ecog    
    srate = ecog.srate;
    
    %%
    a_timex = linspace(-1,1.5,srate*2.5);
    m_timex = linspace(-1.5,1.5,srate*3);
    
    %%
    n_trials = ecog.n_trials;
    n_ch = size(ecog.rest_data,2);
    
    %%
    rest_data = reformsig(ecog.rest_data,n_trials);
    stim_data = reformsig(ecog.stim_data,n_trials);
    button_data = reformsig(ecog.button_data,n_trials);
    
    n_tp_a = size(stim_data,1);
    n_tp_b = size(button_data,1);
    %%
    roi_channels = [ach_data{isub} mch_data{isub}];
    
    %%
    clear raw_stim_data  bp_stim_data env_stim_data raw_button_data bp_button_data env_button_data
    clear lp_stim_data lp_button_data
    a_event = zeros(1,n_tp_a);
    a_event(srate*1.0+1) = 1;
    m_event = zeros(1,n_tp_b);
    m_event(srate*1.5+1) = 1;
    
   
    %% Removing additivity and phase reset for auditory responses
    clear corrected_data ch_corrected_erp 
    clear ch_corrected_erp corrected_data ch_to_be_corrected
    clear nph_stim_data npo_stim_data bs_estimated_y1 bs_estimated_y2 bs_estimated_y3
    
    
    for tr = 1:n_trials
        base_data = rest_data(1:srate,ach_data{isub},tr);
        nph_stim_data(:,:,tr) = giver_steady_pv_for_each_freq_v4(stim_data(:,ach_data{isub},tr),srate,base_data, [3 30]);
        npo_stim_data(:,:,tr) = butter_lowpass_filtering(stim_data(:,ach_data{isub},tr),srate,3,8);
    end
    
    temporal_roi = floor([srate*1+1:srate*1.5]);
    delta_t = 0;
    order = 10;
    
    for ch = 1:length(ach_data{isub})
        for tr = 1:n_trials
            
            bs_estimated_y2(:,tr) = nph_stim_data(:,ch,tr);
            bs_estimated_y3(:,tr) = npo_stim_data(:,ch,tr);
        end
        bs_estimated_y2 = baselineCorS(bs_estimated_y2',a_event,[-500 -0],srate)';
        bs_estimated_y3 = baselineCorS(bs_estimated_y3',a_event,[-500 -0],srate)';
        
        corrected_data(:,:,ch) = bs_estimated_y2 - bs_estimated_y3;
        
        ch_corrected_erp(:,ch) = mean(corrected_data(:,:,ch),2);
        ch_corrected_erp(:,ch) = baselineCorS(ch_corrected_erp(:,ch)',a_event,[-500 -0],srate)';

    end
    
    eeg_a_erps{isub} = ch_corrected_erp;

    
    %% Removing additivity and phase reset for button responses
    if isub == 5
        eeg_m_erps{isub} = nan;
    else
        clear  hg_powers raw_voltage bs_estimated_y corrected_data ch_corrected_erp ch_original_erp estimated_y
        clear ch_corrected_erp corrected_data
        clear nph_button_data npo_button_data bs_estimated_y1 bs_estimated_y2 bs_estimated_y3
        
        for tr = 1:n_trials
            base_data = rest_data(1:srate,mch_data{isub},tr);
            nph_button_data(:,:,tr) = giver_steady_pv_for_each_freq_v4(button_data(:,mch_data{isub},tr),srate,base_data, [3 30]);
            npo_button_data(:,:,tr) = butter_lowpass_filtering(button_data(:,mch_data{isub},tr),srate,3,8);
        end
        
        temporal_roi = [srate*1.0+1:srate*2.0];
        
        for ch = 1:length(mch_data{isub})
            for tr = 1:n_trials

                bs_estimated_y2(:,tr) = nph_button_data(:,ch,tr);
                bs_estimated_y3(:,tr) = npo_button_data(:,ch,tr);
            end
            
            bs_estimated_y2 = baselineCorS(bs_estimated_y2',m_event,[-1400 -900],srate)';
            bs_estimated_y3 = baselineCorS(bs_estimated_y3',m_event,[-1400 -900],srate)';          
 
                        
            corrected_data(:,:,ch) = bs_estimated_y2 - bs_estimated_y3;
            
            ch_corrected_erp(:,ch) = mean(corrected_data(:,:,ch),2);
            ch_corrected_erp(:,ch) = baselineCorS(ch_corrected_erp(:,ch)',m_event,[-1400 -900],srate)';
        end
        
        eeg_m_erps{isub} = ch_corrected_erp;
    end
    
end

%%
save no_AofB_effect_ch_final_400hz eeg_a_erps eeg_m_erps 


