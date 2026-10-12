clear;
clc;
hemi = [1 -1 1 -1 -1 1 1 -1];
subjects=[38 40 41 45 56 57 58 71];
srate = 400;
a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;

m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;

atimes = linspace(-1000,1500,srate*2.5);
mtimes = linspace(-1500,1500,srate*3);
load ach_data_final.mat
load mch_data_final.mat

all_div_data{1} = [];
all_div_data{2} = [];
all_div_data{3} = [];
all_div_data{4} = [];
norm_all_div_data = all_div_data;
%%
for isub = [1:4 6:8]
    load(['s' num2str(isub) '_auditory_ds.mat']);
    
    n_trials = ecog.n_trials;
    n_ch = size(ecog.rest_data,2);
    %%
    rest_data = reformsig(ecog.rest_data,n_trials);
    stim_data = reformsig(ecog.stim_data,n_trials);
    button_data = reformsig(ecog.button_data,n_trials);

    
    disp('start');
    clear raw_data bandpassed_data power_data base_power_data norm_base_power_data
    for ch = 1:length(mch_data{isub})
        for tr = 1:n_trials
            raw_data(:,ch,tr) = stim_data(:,mch_data{isub}(ch),tr);
            [power_spectrum(:,ch,tr), f] = fft_spectrum(raw_data(1:srate*1,ch,tr), srate); 
%             [power_spectrum(:,ch,tr),f] = pwelch(raw_data(1:srate*1,ch,tr),[],[],1:200,srate);
            
            %%
            [tmp lower_freq_idx] = min(abs(f-1));
            [tmp upper_freq_idx] = min(abs(f-50));

            x = f(lower_freq_idx:upper_freq_idx)';
            y = log(power_spectrum(lower_freq_idx:upper_freq_idx,ch,tr));
            [fitobject,gof,output] = fit(x,y,'(a/x)^b', 'lower',[0 0], 'StartPoint',[1 1]);
            a = fitobject.a;
            b = fitobject.b;
            yval = (a./x).^b;
            
%             [fitobject,gof,output] = fit(x,y,'(a/x)', 'lower',[0], 'StartPoint',[1]);
%             a = fitobject.a;
%             b = 1;
%             yval = (a./x).^b;
            
            z = y-yval;
            std_z = std(z);
            osc_idx = find(y > yval+std_z);
            
            non_osc_idx = setdiff(1:length(x),osc_idx);
            z(non_osc_idx) = 0;
            final_osc_freq = f(osc_idx+lower_freq_idx-1);
            final_osc_idx = osc_idx+lower_freq_idx-1;

            idx_sets = isolating_consecutive_numbers(final_osc_idx);
            n_sets = length(idx_sets);
            freq_sets = cell(1,n_sets);
            for fi = 1:n_sets
                freq_sets{fi} = f(idx_sets{fi});
            end
            final_freq_collections{ch,tr} = freq_sets;
            fprintf('.');
            pxx(:,tr,ch) = y;
            fit_pxx(:,tr,ch) = yval;
            
        end
        fprintf('\n');
        
        %%
%         tr = 89;
%         figure();
%         plot(x,mean(pxx(:,tr,ch),2));
%         hold on;
%         plot(x,mean(fit_pxx(:,tr,ch),2));
       
        
    end
    
    %%
    disp('start');
    all_freqs = cell(1,length(mch_data{isub}));
    for ch = 1:length(mch_data{isub})
        
        for tr = 1:n_trials
            iter_sets = final_freq_collections{ch,tr};
            n_sets = length(iter_sets);
            for si = 1:n_sets
                if length(iter_sets{si}) > 1
                    all_freqs{ch} = [all_freqs{ch} (iter_sets{si})];
                end
            end
            
            fprintf('.');
        end
        fprintf('\n');
    end
    

%     figure();
    [counts centers] = hist([all_freqs{1} all_freqs{1}],0:50);
%     plot(centers,counts);
%     xlim([0 50]);
%     xlabel('Hz');
%     ylabel('Number of detected frequecy comp.');
    
    subject_results(isub,:) = counts;
          
end

save ong_band_results_motor.mat subject_results centers

%%
load ong_band_results_motor.mat
figure();
plot(0:50,subject_results,'Color',[0,0.7,0]);
hold on;
plot(0:50,mean(subject_results,1),'Color',[0,0.7,0],'linewidth', 3);
xlim([0 50]);
xlabel('Hz');
ylabel('Number of detected frequecy comp.');
vline([3 40]);

%

%             fout = fit(x,y,'(a/x)^b','Lower',[0 0]);
%             fout = fitdist(y,'Exponential');
%             ypdf = pdf(fout,x);
%             factor_y = max(x)/max(y);
%             yfit = ypdf*factor_y/2;
%             figure();
% %             plot(x,y);
%             hold on;
%             plot(x,ypdf);