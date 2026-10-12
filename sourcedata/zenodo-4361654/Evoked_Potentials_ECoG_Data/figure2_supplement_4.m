clear;
clc;

srate = 400;
a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;

m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;


%%
atimex = linspace(-1000,1500,srate*2.5);
mtimex = linspace(-1500,1500,srate*3);

load original_erp_eeg.mat

%% plot individual auditory responses
ch = 11;
figure('position',[10 10 400 1000]);
for isub = 1:7
%     positionvector1 = [ 0.1 0.80-0.12*isub 0.4 0.21  ];
    
    subplot(8,1,isub);
%     subplot('position',positionvector1);
    tdata = eeg_a_erps(:,ch,isub);
    if isub == 6
        tdata = butter_lowpass_filtering(tdata,srate,30,8);
    end
    
    pdata = (tdata);
    pdata = baselineCorS(pdata',a_event,[-500 0],srate)';
    dh = plot(atimex,pdata, 'r', 'linewidth', 3);
    
    min_val = min(pdata);
    max_val = max(pdata);
    
    xlim([-500 1000]);
    ylim([min_val max_val]);
    hh = hline(0,'k');
    vh = vline(0,'k');
    set(gca,'Visible','off');
    
    uistack(dh,'top');
end

avg_pdata = mean(eeg_a_erps(:,ch,:),3);

avg_pdata = baselineCorS(avg_pdata',a_event,[-500 0],srate)';

subplot(8,1,8);
dh = plot(atimex,avg_pdata, 'r', 'linewidth', 3);

min_val = min(avg_pdata);
max_val = max(avg_pdata);

xlim([-500 1000]);
ylim([min_val max_val]);
hh = hline(0,'k');
vh = vline(0,'k');
set(gca,'Visible','off');

uistack(dh,'top');

%% plot individual button responses
mtimex = linspace(-1500,1500,srate*3);
ch = 9;
figure('position',[10 10 400 1000]);
for isub = 1:7
%     positionvector1 = [ 0.1 0.80-0.12*isub 0.4 0.21  ];
    
    subplot(8,1,isub);
%     subplot('position',positionvector1);
    tdata = eeg_m_erps(:,ch,isub);   
    pdata = (tdata);
    pdata = baselineCorS(pdata',m_event,[-1000 -500],srate)';
    dh = plot(mtimex,pdata, 'g', 'linewidth', 3);
    
    min_val = min(pdata);
    max_val = max(pdata);
    
    xlim([-750 750]);
    ylim([min_val max_val]);
    hh = hline(0,'k');
    vh = vline(0,'k');
    set(gca,'Visible','off');
    
    uistack(dh,'top');
end

avg_pdata = mean(eeg_m_erps(:,ch,:),3,'omitnan');

avg_pdata = baselineCorS(avg_pdata',m_event,[-1500 -500],srate)';

subplot(8,1,8);
dh = plot(mtimex,avg_pdata, 'g', 'linewidth', 3);

min_val = min(avg_pdata);
max_val = max(avg_pdata);

xlim([-750 750]);
if isub ~= 5
    ylim([min_val max_val]);
end
hh = hline(0,'k');
vh = vline(0,'k');
set(gca,'Visible','off');

uistack(dh,'top');