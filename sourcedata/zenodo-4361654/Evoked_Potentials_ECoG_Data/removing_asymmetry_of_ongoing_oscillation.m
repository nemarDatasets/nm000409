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
    
    for tr = 1:n_trials
        raw_stim_data(:,tr,:) = stim_data(:,ach_data{isub},tr);
        tmp_raw_data = butter_lowpass_filtering(stim_data(:,ach_data{isub},tr),srate,3,8);
        lp_stim_data(:,tr,:) = tmp_raw_data;
        bp_stim_data(:,tr,:) = butter_bandpass_filtering(stim_data(:,ach_data{isub},tr),srate,[3 30],6);
        for ch = 1:length(ach_data{isub})
            env_stim_data(:,tr,ch) = abs(hilbert(bp_stim_data(:,tr,ch)));
        end
        
        raw_button_data(:,tr,:) = button_data(:,mch_data{isub},tr);
        tmp_raw_data = butter_lowpass_filtering(button_data(:,mch_data{isub},tr),srate,3,8);
        lp_button_data(:,tr,:) = tmp_raw_data;
        bp_button_data(:,tr,:) = butter_bandpass_filtering(button_data(:,mch_data{isub},tr),srate,[3 30],6);
        for ch = 1:length(mch_data{isub})
            env_button_data(:,tr,ch) = abs(hilbert(bp_button_data(:,tr,ch)));
        end
    end
    
    %% removing asymmetric amplitude for auditory responses
    clear raw_data estimated_bias corrected_data
    for ch = 1:length(ach_data{isub})
        %% normalization
        % get maximum raw amplitude for roi channels and trials
        tp1 = floor(srate*0.2)+1;
        tp2 = floor(srate*2.3);
        
        all_stim_data = raw_stim_data(tp1:tp2,:,ch);
        abs_all_stim_data = abs(all_stim_data(:));
        max_raw_val = prctile(abs_all_stim_data,98);
        
        all_env_data = env_stim_data(tp1:tp2,:,ch);
        abs_all_env_data = abs(all_env_data(:));
        max_hg_power = prctile(abs_all_env_data,98);
        
        norm_stim_data = raw_stim_data(tp1:tp2,:,ch)/max_raw_val;
        norm_env_stim_data = env_stim_data(tp1:tp2,:,ch)/max_hg_power;
        
        %%
        pks_env_val = [];
        pks_raw_val = [];
        trgh_env_val = [];
        trgh_raw_val = [];
        
        for tr = 1:n_trials
            raw_tmp_data = raw_stim_data(tp1:tp2,tr,ch);
            bp_tmp_data = bp_stim_data(tp1:tp2,tr,ch);
            env_tmp_data = env_stim_data(tp1:tp2,tr,ch);
            % find peak positions
            tmp_data_for_peak = bp_tmp_data - env_tmp_data;
            MPH = -10^.10;
            [pks_v,pks_locs] = findpeaks(tmp_data_for_peak,'MinPeakHeight',MPH);
            % find trough positions
            tmp_data_for_trough = -(bp_tmp_data + env_tmp_data);
            [trgh_v,trgh_locs] = findpeaks(tmp_data_for_trough,'MinPeakHeight',MPH);
            
            pks_env_val = [pks_env_val; env_tmp_data(pks_locs)/max_hg_power];
            pks_raw_val = [pks_raw_val; raw_tmp_data(pks_locs)/max_raw_val];
            
            trgh_env_val = [trgh_env_val; env_tmp_data(trgh_locs)/max_hg_power];
            trgh_raw_val = [trgh_raw_val; raw_tmp_data(trgh_locs)/max_raw_val];
        end
        
        
        %%
        clear m_pks_bins m_trgh_bins
        edges = 0:.01:1;
        values = edges(2:end);
        allocated_pks = discretize(pks_env_val(:),edges,values);
        allocated_trgh = discretize(trgh_env_val(:),edges,values);
        norm_pks_amp = pks_raw_val(:);
        norm_trgh_amp = trgh_raw_val(:);
        
        for ival = 1:length(values)
            val_idx = find(allocated_pks == values(ival));
            m_pks_bins(ival) = mean(norm_pks_amp(val_idx)); %% mean? median?
            
            val_idx = find(allocated_trgh == values(ival));
            m_trgh_bins(ival) = mean(norm_trgh_amp(val_idx)); %% mean? median?
        end
        
        subject_pks_bins(:,isub) = m_pks_bins;
        subject_trgh_bins(:,isub) = m_trgh_bins;
        
        %% peaks
        empty_idx = find(isnan(m_pks_bins));
        exist_idx = setdiff(1:length(values),empty_idx);
        
        pks_line_coeff = polyfit(values(exist_idx),m_pks_bins(exist_idx),1);
        pks_regression_line= pks_line_coeff(1)*values + pks_line_coeff(2);
        
        empty_idx = find(isnan(m_trgh_bins));
        exist_idx = setdiff(1:length(values),empty_idx);
        
        trgh_line_coeff = polyfit(values(exist_idx),m_trgh_bins(exist_idx),1);
        trgh_regression_line= trgh_line_coeff(1)*values + trgh_line_coeff(2);
        
        bias_regression_line = (pks_regression_line+trgh_regression_line)/2;
        
       
        %% estimate the bias
        for tr = 1:n_trials
            raw_data(:,tr,ch) = raw_stim_data(:,tr,ch);
            hg_data = env_stim_data(:,tr,ch);
            norm_hg_data = hg_data/max_hg_power;
            allocated_tr_data = discretize(norm_hg_data,edges,values);
            for tp = 1:n_tp_a
                g_idx = find(values == allocated_tr_data(tp));
                if isempty(g_idx)
                    estimated_bias(tp,tr,ch) = 0;
                else
                    estimated_bias(tp,tr,ch) = bias_regression_line(g_idx);
                end
            end
            
            tmp_estimated_bias = estimated_bias(:,tr,ch);
%             tmp_estimated_bias = baselineCorS(tmp_estimated_bias',a_event,[-500 0],srate)';
            
            corrected_data(:,ch,tr) = raw_data(:,tr,ch) - tmp_estimated_bias*max_raw_val;
        end
    end
    corr_erps = mean(corrected_data,3);
    corr_erps = baselineCorS(corr_erps',a_event,[-500 0],srate)';
    eeg_a_erps{1,isub} = corr_erps;
    
    %% removing asymmetric amplitude for button responses
    if isub ~= 5
        clear  raw_data estimated_bias corrected_data
        for ch = 1:length(mch_data{isub})
            %% normalization
            % get maximum raw amplitude for roi channels and trials
            tp1 = floor(srate*0.5)+1;
            tp2 = floor(srate*2.5);
            
            all_button_data = raw_button_data(tp1:tp2,:,ch);
            abs_all_button_data = abs(all_button_data(:));
            max_raw_val = prctile(abs_all_button_data,98);
            
            all_env_data = env_button_data(tp1:tp2,:,ch);
            abs_all_env_data = abs(all_env_data(:));
            max_hg_power = prctile(abs_all_env_data,98);
            
            norm_button_data = button_data(tp1:tp2,:,ch)/max_raw_val;
            norm_env_button_data = env_button_data(tp1:tp2,:,ch)/max_hg_power;
            
            %%
            pks_env_val = [];
            pks_raw_val = [];
            trgh_env_val = [];
            trgh_raw_val = [];
            raw_buf_data = [];
            
            for tr = 1:n_trials
                raw_tmp_data = raw_button_data(tp1:tp2,tr,ch);
                bp_tmp_data = bp_button_data(tp1:tp2,tr,ch);
                env_tmp_data = env_button_data(tp1:tp2,tr,ch);
                % find peak positions
                tmp_data_for_peak = bp_tmp_data - env_tmp_data;
                MPH = -10^.10;
                [pks_v,pks_locs] = findpeaks(tmp_data_for_peak,'MinPeakHeight',MPH);
                % find trough positions
                tmp_data_for_trough = -(bp_tmp_data + env_tmp_data);
                [trgh_v,trgh_locs] = findpeaks(tmp_data_for_trough,'MinPeakHeight',MPH);
                
                pks_env_val = [pks_env_val; env_tmp_data(pks_locs)/max_hg_power];
                pks_raw_val = [pks_raw_val; raw_tmp_data(pks_locs)/max_raw_val];
                
                trgh_env_val = [trgh_env_val; env_tmp_data(trgh_locs)/max_hg_power];
                trgh_raw_val = [trgh_raw_val; raw_tmp_data(trgh_locs)/max_raw_val];
                
                raw_buf_data(:,tr) = raw_button_data(:,tr,ch);
                
            end
             
            %%
            clear m_pks_bins m_trgh_bins
            edges = 0:.01:1;
            values = edges(2:end);
            allocated_pks = discretize(pks_env_val(:),edges,values);
            allocated_trgh = discretize(trgh_env_val(:),edges,values);
            norm_pks_amp = pks_raw_val(:);
            norm_trgh_amp = trgh_raw_val(:);
            
            for ival = 1:length(values)
                val_idx = find(allocated_pks == values(ival));
                m_pks_bins(ival) = mean(norm_pks_amp(val_idx)); %% mean? median?
                
                val_idx = find(allocated_trgh == values(ival));
                m_trgh_bins(ival) = mean(norm_trgh_amp(val_idx)); %% mean? median?
            end
            
%             subject_pks_bins(:,isub) = m_pks_bins;
%             subject_trgh_bins(:,isub) = m_trgh_bins;

            
            %% peaks
            empty_idx = find(isnan(m_pks_bins));
            exist_idx = setdiff(1:length(values),empty_idx);
            
            pks_line_coeff = polyfit(values(exist_idx),m_pks_bins(exist_idx),1);
            pks_regression_line= pks_line_coeff(1)*values + pks_line_coeff(2);
            
            empty_idx = find(isnan(m_trgh_bins));
            exist_idx = setdiff(1:length(values),empty_idx);
            
            trgh_line_coeff = polyfit(values(exist_idx),m_trgh_bins(exist_idx),1);
            trgh_regression_line= trgh_line_coeff(1)*values + trgh_line_coeff(2);
            
            bias_regression_line = (pks_regression_line+trgh_regression_line)/2;
            

            
            %% estimate the bias
            for tr = 1:n_trials
                raw_data(:,tr,ch) = raw_button_data(:,tr,ch);
                hg_data = env_button_data(:,tr,ch);
                norm_hg_data = hg_data/max_hg_power;
                allocated_tr_data = discretize(norm_hg_data,edges,values);
                for tp = 1:n_tp_b
                    g_idx = find(values == allocated_tr_data(tp));
                    if isempty(g_idx)
                        estimated_bias(tp,tr,ch) = 0;
                    else
                        estimated_bias(tp,tr,ch) = bias_regression_line(g_idx);
                    end
                end
                
                tmp_estimated_bias = estimated_bias(:,tr,ch);
                event = zeros(1,n_tp_b);
                event(srate*1.5+1) = 1;
%                 tmp_estimated_bias = baselineCorS(tmp_estimated_bias',event,[-1400 -900],srate)';
                
                corrected_data(:,ch,tr) = raw_data(:,tr,ch) - tmp_estimated_bias*max_raw_val;
                %%

                bias_mat(:,tr) = tmp_estimated_bias;
            end
        end
        
        %%
        corr_erps = mean(corrected_data,3);
        corr_erps = baselineCorS(corr_erps',m_event,[-1400 -900],srate)';
        eeg_m_erps{1,isub} = corr_erps;
    else
        eeg_m_erps{1,isub} = nan;
    end
    
end

%%
save no_ongoing_asym_erp_final_ch_400hz eeg_a_erps eeg_m_erps



