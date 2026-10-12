clear;
clc;

srate = 400;
a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;

m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;

atimes = linspace(-1000,1500,srate*2.5);
mtimes = linspace(-1500,1500,srate*3);


load ch_erp_powers_auditory

load ach_data_final.mat
load mch_data_final.mat

clear all_ecog_erps  all_ecog_ong_envelops
cnt = 0;
for isub = 1:8
    for ch = 1:length(ach_data{isub})
        all_ecog_erps(:,cnt+1) = ecog_erps{isub}(ch,:);
        all_ecog_ong_envelops(:,cnt+1) = ecog_ong_envelops{isub}(ch,:);
        cnt = cnt + 1;
    end
end

disp(cnt);

idx = [22 18 3];

figure;
for iter = 1:3
    subplot(3,1,iter);
    pdata = zscore([all_ecog_erps(:,idx(iter)) all_ecog_ong_envelops(:,idx(iter))])';
    pdata = baselineCorS(pdata,a_event,[-500 0],srate);
    plot(atimes,pdata(1,:), 'r');
    hold on;
    plot(atimes,pdata(2,:), 'b');
    
    min_val = min(pdata(:));
    max_val = max(pdata(:));
    
    xlim([-500 1000]);
    ylim([min_val max_val]);
    hh = hline(0,'k');
    vh = vline(0,'k');
    set(gca,'Visible','off');
end


