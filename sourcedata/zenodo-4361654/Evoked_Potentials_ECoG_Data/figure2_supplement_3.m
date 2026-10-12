clear;
clc;


%% 
load original_erp_eeg.mat
n_subs = 7;
srate = 400;
a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;

m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;
subsub = [1:n_subs];

for isub = 1:n_subs
    eeg_a_erps(:,:,isub) = zscore(eeg_a_erps(:,:,isub));
    eeg_m_erps(:,:,isub) = zscore(eeg_m_erps(:,:,isub));
end

eeg_a_erp = baselineCorS(mean(eeg_a_erps(:,:,subsub),3, 'omitnan')',a_event,[-100 0],srate)';
eeg_m_erp = baselineCorS(mean(eeg_m_erps(:,:,subsub),3, 'omitnan')',m_event,[-1000 -500],srate)';

%% plot ERPs
ayrange = [-1 1]*4;
myrange = [-1 1]*4;

a_timex = linspace(-1.000,1.500,srate*2.5);
m_timex = linspace(-1.500,1.500,srate*3);

a_ch = [11];
m_ch = [9];

figure('position', [10 10 600 200]);
subplot(1,2,1);
h=plot(a_timex,mean(eeg_a_erp(:,a_ch),2), 'r');
set(h, 'linewidth', 3);
xlim([-.5 1]);
ylim(ayrange);
hline(0);
vline(0);
% title('Auditory', 'fontsize', 20);
title('Stim. onset', 'fontsize', 20);

subplot(1,2,2);
h=plot(m_timex,mean(eeg_m_erp(:,m_ch),2), 'g');
set(h, 'linewidth', 3);
ylim(myrange);
hline(0);
vline(0);
% title('Motor', 'fontsize', 20);
title('Button press onset', 'fontsize', 20);
xlim([-.75 .75]);

%% plot topographies
elocs = readlocs('elec_loc_64.xyz');
% vector = mean(eeg_a_erp(floor(srate*1.05):floor(srate*1.1),:));
% vector = (eeg_a_erp(floor(srate*1.1061),:));
vector = (eeg_a_erp(floor(srate*1.107),:));
% vector([1 29 35]) = median(vector);
[minval minidx]=max(abs(vector));

figure();
topoplot(vector, elocs, 'maplimits' , [-1 1]*4 ,'plotchans' ,[1:42, 45:63]);
title('Auditory response at 107ms');
ylim([-1 1]);

%%
% vector = mean(eeg_a_erp(floor(srate*1.0):floor(srate*1.4),:));
vector = (eeg_m_erp(floor(srate*(1.5-0.089)),:));
% vector([1 29 35]) = median(vector);
% pos_idx = find(vector>0);
% vector(pos_idx) =median(vector);
[minval minidx]=min((vector));
figure();
topoplot(vector, elocs, 'maplimits' , [-1 1]*4,'plotchans' ,[1:42, 45:63]);
ylim([-1 1]);
title('Motor activity at -89ms from button press onset');
