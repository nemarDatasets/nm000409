clear
clc;

load ach_data_final.mat
load mch_data_final.mat
hemi = [1 -1 1 -1 -1 1 1 -1];

isub = 3;

%% Figure 3A - topo plot
p_value = 0;
n_ch = length(p_value);
topo_vector = zeros(n_ch,1);
right_hemi = hemi(isub);
topo_info = load_topo_info(isub);

topo_info.tala.activations(1:n_ch,:) = topo_vector;

topo_info.cmapstruct.cmin = 0;
topo_info.cmapstruct.cmax = 1;

figure();
ecog_topo_plot(topo_info,right_hemi);
%     plotBalls(topo_info.tala.trielectrodes, 'k', 2);
zoom(1.2);

plotBalls(topo_info.tala.trielectrodes, 'k', 1);
plotBalls(topo_info.tala.trielectrodes(ach_data{isub},:), 'r', 5);
plotBalls(topo_info.tala.trielectrodes(mch_data{isub},:), 'g', 5);
colorbar off

%% Figure 3B - raw signals



load(['s' num2str(isub) '_auditory_ds.mat']);
srate = ecog.srate;
atimes = linspace(-1,1.5,srate*2.5);
mtimes = linspace(-1.5,1.5,srate*3);
n_trials = ecog.n_trials;
n_ch = size(ecog.rest_data,2);

rest_data = reformsig(ecog.rest_data, n_trials);
stim_data = reformsig(ecog.stim_data, n_trials);
button_data = reformsig(ecog.button_data,n_trials);

for tr = 1:n_trials
    for ch = 1:n_ch
        auditory_raw_data(:,tr,ch) = stim_data(:,ch,tr);
        motor_raw_data(:,tr,ch) = button_data(:,ch,tr);
    end
    
    auditory_low_data(:,tr,:) = butter_lowpass_filtering(stim_data(:,:,tr),srate,3,6);
    %     auditory_low_data(:,tr,:) = fft_bandpass_filtering(stim_data(:,:,tr),srate,[0 3]);
    motor_low_data(:,tr,:) = butter_lowpass_filtering(button_data(:,:,tr),srate,3,6);
    %     motor_low_data(:,tr,:) = fft_bandpass_filtering(button_data(:,:,tr),srate,[0 3]);
    
    auditory_high_data(:,tr,:) = butter_bandpass_filtering(stim_data(:,:,tr),srate,[4 30],6);
    motor_high_data(:,tr,:) = butter_bandpass_filtering(button_data(:,:,tr),srate,[4 30],6);
    
end

%
eegplot_custom(auditory_raw_data(:,:,ach_data{isub}(1)), srate, 4, atimes, [-200 0], [-0.5 1], 'r');
eegplot_custom(motor_raw_data(:,:,mch_data{isub}(1)), srate, 4, mtimes, [-1000 -500], [-.75 .75],'g');

%% Figure 3C ERP from different channels

eegplot_custom_ERPs(mean(stim_data(:,ach_data{isub},:),3), srate, length(ach_data{isub}), atimes, [-200 0], [-0.5 1], 'r');
eegplot_custom_ERPs(mean(button_data(:,mch_data{isub},:),3), srate, length(mch_data{isub}), mtimes, [-1000 -500], [-.75 .75],'g');


%% Figure 3D plot time temporal frequency chararcteristic

low_aud_erp = mean(auditory_low_data(:,:,ach_data{isub}(1)),2);
high_aud_erp = mean(auditory_high_data(:,:,ach_data{isub}(1)),2);
org_aud_erp = mean(auditory_raw_data(:,:,ach_data{isub}(1)),2);

plotdata = [  org_aud_erp high_aud_erp low_aud_erp];

m_amp = mean(abs(plotdata(:)))*20;

hFig = figure('position',[10 50 400 550]);
for i = 1:3
    plot(atimes,plotdata(:,i) + m_amp*(i-1), 'r', 'linewidth', 4);
    hold on;
    xlim([-0.5 1]);
    %     ylim([-300 300]);
end
set(gca,'Visible','off');
h = vline(0,'k:');
set(h,'linewidth',4);
h = hline(0,'k:');
set(h,'linewidth',4);
uistack(h,'bottom');

%
low_motor_erp = mean(motor_low_data(:,:,mch_data{isub}(1)),2);
high_motor_erp = mean(motor_high_data(:,:,mch_data{isub}(1)),2);
org_motor_erp = mean(motor_raw_data(:,:,mch_data{isub}(1)),2);

plotdata = [  org_motor_erp high_motor_erp low_motor_erp];

hFig = figure('position',[10 50 400 550]);
for i = 1:3
    plot(mtimes,plotdata(:,i) + m_amp*(i-1), 'g', 'linewidth', 4);
    hold on;
    xlim([-0.75 .75]);
end
set(gca,'Visible','off');
h = vline(0,'k:');
set(h,'linewidth',4);
h = hline(0,'k:');
set(h,'linewidth',4);
uistack(h,'bottom');

%% Figure 3E

load figure3E_auditory_40hz.mat

% ongoing power spectrum

linew = 4;
fcnt = 2

mdata = mean([ong_low_freq(:,fcnt) ong_high_freq(:,fcnt)]);
sdata = std([ong_low_freq(:,fcnt) ong_high_freq(:,fcnt)])/(8)^0.5;

[v1 v2 ci stats] = ttest(ong_low_freq(:,fcnt), ong_high_freq(:,fcnt));

figure('position',[10 10 400 400]);
h = bar(mdata*100);
hold on;
for i = 1:2
    line([i i],[mdata(i)-sdata(i) mdata(i)+sdata(i)]*100,'color','k','linewidth',3);
    line([i-0.1 i+0.1],[mdata(i)+sdata(i) mdata(i)+sdata(i)]*100,'color','k','linewidth',3);
    line([i-0.1 i+0.1],[mdata(i)-sdata(i) mdata(i)-sdata(i)]*100,'color','k','linewidth',3);
end

line([1 2],[.9 .9]*100,'color','k','linewidth',3);
line([1 1],[.9 .85]*100,'color','k','linewidth',3);
line([2 2],[.9 .85]*100,'color','k','linewidth',3);

if v2 < 0.01
    text(1.5,92,'***', 'HorizontalAlignment','center', 'fontsize',30);
end

set(gca, 'xtick', [1 2], 'xticklabel', {'<3Hz', '3-40Hz'});
set(gca, 'ytick', [0 50 100]);
set(gca, 'fontsize', 20);
set(gca, 'linewidth', 3);
set(h,'linewidth',3);

ylim([0 100]);
title('Auditory');
set(h,'FaceColor', 'r');
ylabel('%');


% AEP power 
figure3E_P100_for_no_freqband();
figure3E_N100_for_no_freqband();
figure3E_P200_for_no_freqband();


% ongoing power spectrum
load figure3E_motor_40hz.mat

linew = 4;

mdata = mean([ong_low_freq(:,fcnt) ong_high_freq(:,fcnt)]);
sdata = std([ong_low_freq(:,fcnt) ong_high_freq(:,fcnt)])/(8)^0.5;

[v1 v2 ci stats] = ttest(ong_low_freq(:,fcnt), ong_high_freq(:,fcnt));

figure('position',[10 10 400 400]);
h = bar(mdata*100);
hold on;
for i = 1:2
    line([i i],[mdata(i)-sdata(i) mdata(i)+sdata(i)]*100,'color','k','linewidth',3);
    line([i-0.1 i+0.1],[mdata(i)+sdata(i) mdata(i)+sdata(i)]*100,'color','k','linewidth',3);
    line([i-0.1 i+0.1],[mdata(i)-sdata(i) mdata(i)-sdata(i)]*100,'color','k','linewidth',3);
end

line([1 2],[.9 .9]*100,'color','k','linewidth',3);
line([1 1],[.9 .85]*100,'color','k','linewidth',3);
line([2 2],[.9 .85]*100,'color','k','linewidth',3);

if v2 < 0.01
    text(1.5,92,'***', 'HorizontalAlignment','center', 'fontsize',30);
end

set(gca, 'xtick', [1 2], 'xticklabel', {'<3Hz', '3-40Hz'});
set(gca, 'ytick', [0 50 100]);
set(gca, 'fontsize', 20);
set(gca, 'linewidth', 3);
set(h,'linewidth',3);

ylim([0 100]);
title('Motor');
set(h,'FaceColor', 'g');
ylabel('%');


% ERP power spectrum




mdata = mean([motor_low_freq(:,fcnt) motor_high_freq(:,fcnt)]);
sdata = std([motor_low_freq(:,fcnt) motor_high_freq(:,fcnt)])/(8)^0.5;

[v1 v2 ci stats] = ttest(motor_low_freq(:,fcnt), motor_high_freq(:,fcnt));

figure('position',[10 10 400 400]);
h = bar(mdata*100);
hold on;
for i = 1:2
    line([i i],[mdata(i)-sdata(i) mdata(i)+sdata(i)]*100,'color','k','linewidth',3);
    line([i-0.1 i+0.1],[mdata(i)+sdata(i) mdata(i)+sdata(i)]*100,'color','k','linewidth',3);
    line([i-0.1 i+0.1],[mdata(i)-sdata(i) mdata(i)-sdata(i)]*100,'color','k','linewidth',3);
end

line([1 2],[.9 .9]*100,'color','k','linewidth',3);
line([1 1],[.9 .85]*100,'color','k','linewidth',3);
line([2 2],[.9 .85]*100,'color','k','linewidth',3);

if v2 < 0.01
    text(1.5,92,'***', 'HorizontalAlignment','center', 'fontsize',30);
end

set(gca, 'xtick', [1 2], 'xticklabel', {'<3Hz', '3-40Hz'});
set(gca, 'ytick', [0 50 100]);
set(gca, 'fontsize', 20);
set(gca, 'linewidth', 3);
set(h,'linewidth',3);

ylim([0 100]);
title('Motor');
set(h,'FaceColor', 'g');
ylabel('%');




%% Figure 3F
load auditory_top_bot_ong_effect
load ach_data_final.mat
load mch_data_final.mat
srate = 400;

a_timex = linspace(-1,1.5,srate*2.5);
m_timex = linspace(-1.5,1.5,srate*3);
n_tp_a = size(a_timex,1);
n_tp_b = size(m_timex,1);
a_event = zeros(1,n_tp_a);
a_event(srate*1.0+1) = 1;
m_event = zeros(1,n_tp_b);
m_event(srate*1.5+1) = 1;

% gather all erps
all_a_erps = [];
time_roi = srate*0.1:srate;
cnt = 1;
for isub = 1:8
    for ch = 1:length(ach_data{isub})
        n_tr = size(eeg_a_erps_top{isub},2);
        for tr = 1:n_tr
            all_a_erps_top(:,cnt) = eeg_a_erps_top{isub}(:,tr,ch);
            all_a_erps_bot(:,cnt) = eeg_a_erps_bot{isub}(:,tr,ch);
            
            all_a_hg_top(:,cnt) = eeg_a_hg_top{isub}(:,tr,ch);
            all_a_hg_bot(:,cnt) = eeg_a_hg_bot{isub}(:,tr,ch);
            
            all_a_bp_top(:,cnt) = eeg_a_bp_top{isub}(:,tr,ch);
            all_a_bp_bot(:,cnt) = eeg_a_bp_bot{isub}(:,tr,ch);
            
            %
            all_a_amp_top(:,cnt) = sum(abs(eeg_a_erps_top{isub}(time_roi,tr,ch)));
            all_a_amp_bot(:,cnt) = sum(abs(eeg_a_erps_bot{isub}(time_roi,tr,ch)));
            
            all_a_prbp_top(:,cnt) = sum(eeg_a_bp_top{isub}(time_roi,tr,ch));
            all_a_prbp_bot(:,cnt) = sum(eeg_a_bp_bot{isub}(time_roi,tr,ch));

            
            cnt = cnt + 1;
        end
    end
end
disp(cnt);

%
% figure();
% scatter(all_a_prbp_top,all_a_amp_top);
% hold on;
% scatter(all_a_prbp_bot,all_a_amp_bot);

%

all_a_erps_top = baselineCorS(all_a_erps_top', a_event, [-100 0], srate)';
all_a_erps_bot = baselineCorS(all_a_erps_bot', a_event, [-100 0], srate)';

%
data_linewidth = 4;
line_width = 3;
xrange = [-.25 .50];
yrange = [-5 10000];
m_ticklength = 5;
figure();
subplot(2,1,1);
h1 = plot(a_timex,mean(all_a_bp_top,2),'r', 'linewidth', data_linewidth,'color',[0.5 .1 0.1]);
hold on;
h2 = plot(a_timex,mean(all_a_bp_bot,2),'r:', 'linewidth', data_linewidth,'color',[0.5 .1 0.1]);

hl=line([-0.25 -0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.25 0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.5 0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([.75 .75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

hl=line([-.01 .01],[yrange(1)  yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-.01 .01],[yrange(2)  yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
  

xlim(xrange);
% ylim(yrange);
h3 = vline(0,'k');
h4 = hline(0,'k');
set(h3,'linewidth',3);
set(h4,'linewidth',3);


set(gca, 'visible', 'off');
uistack(h3,'top');
uistack(h4,'top');
uistack(h1,'top');
uistack(h2,'top');

subplot(2,1,2);
yrange = [-60 40];

data1 = mean(all_a_erps_top,2);
data1 = baselineCorS(data1', a_event, [-250 0], srate)';

data2 = mean(all_a_erps_bot,2);
data2 = baselineCorS(data2', a_event, [-250 0], srate)';

h1 = plot(a_timex,data1,'r', 'linewidth', data_linewidth);
hold on;
h2 = plot(a_timex,data2,'r:', 'linewidth', data_linewidth);
h3 = vline(0,'k');
h4 = hline(0,'k');
set(h3,'linewidth',3);
set(h4,'linewidth',3);

hl=line([-0.25 -0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.25 0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.5 0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([.75 .75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

hl=line([-.01 .01],[yrange(1)  yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-.01 .01],[yrange(2)  yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
  
      
xlim(xrange);
ylim(yrange);
pvals = [];
for tp = 1:srate*2.5
    [h pvals(tp)] = ttest2(all_a_erps_top(tp,:),all_a_erps_bot(tp,:));
%     [ pvals(tp) h ] = ranksum(all_a_erps_top(tp,:),all_a_erps_bot(tp,:));
end
y = fdr0(pvals, 0.05);
y(1:srate*1.0) = 0;
sig_idx = y==1;
hsig = vline(a_timex(sig_idx),'c');
% set(hsig,'color',[1 0 0]);
set(hsig,'color',[1 0.8 0.8]);
uistack(h3,'top');
uistack(h4,'top');
uistack(h1,'top');
uistack(h2,'top');
uistack(hsig,'bottom');
set(gca, 'visible', 'off');



%% Figure 3G

clc
load motor_ong_top_bot_effect.mat
load ach_data_final.mat
load mch_data_final.mat
srate = 400;

a_timex = linspace(-1,1.5,srate*2.5);
m_timex = linspace(-1.5,1.5,srate*3);
n_tp_a = size(a_timex,1);
n_tp_b = size(m_timex,1);
a_event = zeros(1,n_tp_a);
a_event(srate*1.0+1) = 1;
m_event = zeros(1,n_tp_b);
m_event(srate*1.5+1) = 1;

% gather all erps
all_a_erps = [];
clear all_a_erps_top all_a_erps_bot all_a_bp_top all_a_bp_bot
cnt = 1;
for isub =  [1:4 6:8]
    for ch = 1:length(mch_data{isub})
        n_tr = size(eeg_a_erps_top{isub},2);
        for tr = 1:n_tr
            all_a_erps_top(:,cnt) = eeg_a_erps_top{isub}(:,tr,ch);
            all_a_erps_bot(:,cnt) = eeg_a_erps_bot{isub}(:,tr,ch);
            
            
            all_a_bp_top(:,cnt) = eeg_a_bp_top{isub}(:,tr,ch);
            all_a_bp_bot(:,cnt) = eeg_a_bp_bot{isub}(:,tr,ch);
            
            cnt = cnt + 1;
        end
    end
end
disp(cnt);

%

data_linewidth = 4;
line_width = 3;
xrange = [-.25 .75];
yrange = [-5 15000];
m_ticklength = 5;
figure();
subplot(2,1,1);

data1 = mean(all_a_bp_top,2);
% data1 = baselineCorS(data1', m_event, [-500 -250], srate)';

data2 = mean(all_a_bp_bot,2);
% data2 = baselineCorS(data2', m_event, [-500 -00], srate)';

h1 = plot(a_timex,mean(data1,2),'r', 'linewidth', data_linewidth,'color',[0.1 .5 0.1]);
hold on;
h2 = plot(a_timex,mean(data2,2),'r:', 'linewidth', data_linewidth,'color',[0.1 .5 0.1]);

hl=line([-0.25 -0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.25 0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.5 0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([.75 .75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

hl=line([-.01 .01],[yrange(1)  yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-.01 .01],[yrange(2)  yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');


xlim(xrange);
ylim(yrange);
h3 = vline(0,'k');
h4 = hline(0,'k');
set(h3,'linewidth',3);
set(h4,'linewidth',3);


set(gca, 'visible', 'off');
uistack(h3,'top');
uistack(h4,'top');
uistack(h1,'top');
uistack(h2,'top');

subplot(2,1,2);
yrange = [-70 40];
xrange = [-.5 .5];

data1 = (all_a_erps_top);
data1 = baselineCorS(data1', m_event, [-500 -250], srate)';

data2 = (all_a_erps_bot);
data2 = baselineCorS(data2', m_event, [-500 -250], srate)';


h1 = plot(m_timex,mean(data1,2),'g', 'linewidth', data_linewidth);
hold on;
h2 = plot(m_timex,mean(data2,2),'g:', 'linewidth', data_linewidth);
h3 = vline(0,'k');
h4 = hline(0,'k');
set(h3,'linewidth',3);
set(h4,'linewidth',3);

hl=line([-0.25 -0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.25 0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.5 0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([.75 .75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

hl=line([-.01 .01],[yrange(1)  yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-.01 .01],[yrange(2)  yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

xlim(xrange);
ylim(yrange);
h3 = vline(0,'k');
h4 = hline(0,'k');
set(h3,'linewidth',3);
set(h4,'linewidth',3);

pvals = [];
for tp = 1:srate*3
    [h pvals(tp)] = ttest2(data1(tp,:),data2(tp,:));
end
y = fdr0(pvals, 0.01);
y(1:srate*1.25) = 0;
sig_idx = find(y==1);

uistack(h3,'top');
uistack(h4,'top');
uistack(h1,'top');
uistack(h2,'top');

set(gca, 'visible', 'off');

if ~isempty(sig_idx)
    hsig = vline(m_timex(sig_idx),'c');
    set(hsig,'color',[1 0.9 0.9]);
    uistack(hsig,'bottom');
end



