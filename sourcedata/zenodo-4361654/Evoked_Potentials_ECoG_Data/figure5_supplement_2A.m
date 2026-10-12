clear;
clc;
hemi = [1 -1 1 -1 -1 1 1 -1];

load ach_data_final.mat
load mch_data_final.mat

load similarity_power_reduction;


a_cnt = 1;
m_cnt = 1;
for isub = 1:8
    for ch = 1:length(ach_data{isub})
        a_sim_data(a_cnt) = a_sim_val{isub}(ch);
        a_corr_data(a_cnt) = a_corr_val{isub}(ch);
        a_pr_data(a_cnt) = 100-a_power_remained{isub}(ch);
        a_cnt = a_cnt + 1;
    end
end
for isub = [1:4 6:8]
    for ch = 1:length(mch_data{isub})
        m_sim_data(m_cnt) = m_sim_val{isub}(ch);
        m_corr_data(m_cnt) = m_corr_val{isub}(ch);
        m_pr_data(m_cnt) = 100-m_power_remained{isub}(ch);
        m_cnt = m_cnt + 1;
    end
end

%%
figure('position', [10 10 1000 350]);
subplot(1,2,1);
scatter(abs(a_corr_data),a_pr_data,'k');

xlim([0 1]);
ylim([-10 40]);
title('Auditory Channels');
xlabel('|Correlation|')
ylabel('Power Reduction(%)');
box on;

fitResults1 = polyfit(abs(a_corr_data), a_pr_data, 1);
xplot1 = linspace(-1, 1);
yplot1 = polyval(fitResults1, xplot1);

[v1 v2 ]=corr(abs(a_corr_data)', a_pr_data')

hold on;
fitLine1 = plot(xplot1,yplot1);


subplot(1,2,2);
scatter(abs(m_corr_data),m_pr_data,'k');
title('Motor Channels');
ylabel('Power Reduction(%)');
xlim([0 1]);
ylim([-10 40]);
xlabel('|Correlation|')
box on;

fitResults1 = polyfit(abs(m_corr_data), m_pr_data, 1);
xplot1 = linspace(-1, 1);
yplot1 = polyval(fitResults1, xplot1);
hold on;
fitLine1 = plot(xplot1,yplot1);

[v1 v2 ]=corr(abs(m_corr_data)', m_pr_data')

