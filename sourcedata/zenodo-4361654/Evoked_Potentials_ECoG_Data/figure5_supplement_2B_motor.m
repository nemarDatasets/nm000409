%%
clear;
clc;

load ch_erp_powers_motor

load ach_data_final.mat
load mch_data_final.mat

srate = 400;
a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;

m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;

atimes = linspace(-1000,1500,srate*2.5);
mtimes = linspace(-1500,1500,srate*3);

cnt = 0;
for isub = [1:4 6:8]
    for ch = 1:length(mch_data{isub})
        all_ecog_erps(:,cnt+1) = ecog_erps{isub}(ch,:);
        all_ecog_ong_envelops(:,cnt+1) = ecog_ong_envelops{isub}(ch,:);
        cnt = cnt + 1;
    end
end

disp(cnt);

%
% idx = [2 15 6];
idx = [2 15 4];

figure;
for iter = 1:3
    subplot(3,1,iter);
    pdata = zscore([all_ecog_erps(:,idx(iter)) all_ecog_ong_envelops(:,idx(iter))])';
    pdata = baselineCorS(pdata,m_event,[-1400 -900],srate);
    plot(mtimes,pdata(1,:), 'g');
    hold on;
    plot(mtimes,pdata(2,:), 'b');
    
    min_val = min(pdata(:));
    max_val = max(pdata(:));
    
    xlim([-750 750]);
    ylim([min_val max_val]);
    hh = hline(0,'k');
    vh = vline(0,'k');
    set(gca,'Visible','off');
end
