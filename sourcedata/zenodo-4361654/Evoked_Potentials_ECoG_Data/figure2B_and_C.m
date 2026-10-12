clear;
clc;


%% Grand averaged ERP from all subjects
load original_erp_final

srate = 400;
a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;

m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;

for isub = 1:8
    eeg_a_erps(:,:,isub) = zscore(eeg_a_erps(:,:,isub));
    eeg_m_erps(:,:,isub) = zscore(eeg_m_erps(:,:,isub));
end

eeg_a_erp = baselineCorS(mean(eeg_a_erps,3)',a_event,[-500 0],srate)';
eeg_m_erp = baselineCorS(mean(eeg_m_erps,3,'omitnan' )',m_event,[-1400 -900],srate)';

m_ticklength = 2;
line_width = 3;
data_line_width = 4;

a_yrange = [-3 3];
m_yrange = [-3 3];
a_timex = linspace(-1,1.5,srate*2.5);
m_timex = linspace(-1.5,1.5,srate*3);
hg_color = [0.5 .1 0.1];
numgum_length = [-0.2 0.2];

figure('position', [10 10 400 600]);
subplot(2,1,2);
h=plot(a_timex,eeg_a_erp, 'r');
hold on;
set(h, 'linewidth', data_line_width);

xlim([-.5 1]);
ylim(a_yrange);
hl = hline(0, 'k');
set(hl,'linewidth',line_width);
vl = vline(0, 'k');
set(vl,'linewidth',line_width);

set(gca,'Visible','off');
hl=line([-.5 -.5],numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-0.25 -0.25],numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.25 0.25],numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.5 0.5],numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.75 0.75],numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([1 1],numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

hl=line([-.02 .02],[a_yrange(1)  a_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-.02 .02],[a_yrange(2)  a_yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

text(.70, numgum_length(1)-0.3, '0.75 sec', 'fontsize', 15);
text(-.58, numgum_length(1)-0.3, '-0.5', 'fontsize', 15);


uistack(h,'top');


%
hg_color = [0.1 .5 0.1];
bar_color = [0 0.8 0];
subplot(2,1,1);
h=plot(m_timex,eeg_m_erp, 'color', bar_color);
set(h, 'linewidth', data_line_width);
hold on;


ylim(m_yrange);
hl = hline(0, 'k');
set(hl,'linewidth',line_width);
vl = vline(0, 'k');
set(vl,'linewidth',line_width);
title('Motor', 'fontsize', 20);
xlim([-.75 .75]);

hl=line([-1 -1], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-0.75 -0.75], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-0.5 -0.5], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-0.25 -0.25], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.25 0.25], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([0.5 0.5], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([.75 .75], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([1 1], numgum_length);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

hl=line([-.02 .02],[m_yrange(1)  m_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
hl=line([-.02 .02],[m_yrange(2)  m_yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');

set(gca, 'visible','off');
uistack(h,'top');



