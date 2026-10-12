clear;
clc;

srate = 400;

a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;
m_event = zeros(1,srate*3);
m_event(srate*1.5+1) = 1;

%%
load original_erp_ch_final.mat
for isub = 1:8
    A_ERP{1,isub} = eeg_a_erps{isub};        
    M_ERP{1,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{1,isub} = zeros(size(m_event))';
    end
end

load no_power_erp_3Hz_ch_final_400hz.mat
for isub = 1:8
    A_ERP{2,isub} = eeg_a_erps{isub};
    M_ERP{2,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{2,isub} = zeros(size(m_event))';
    end
end

load no_ongoing_asym_erp_final_ch_400hz.mat
% load no_hg_effect_on_lf
for isub = 1:8
    A_ERP{3,isub} = eeg_a_erps{isub};
    M_ERP{3,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{3,isub} = zeros(size(m_event))';
    end
end

%%
figure();
for isub = 1:8
    subplot(8,1,isub);
    o_data(:,isub) = mean(M_ERP{1,isub},2);
    p_data(:,isub) = mean(M_ERP{3,isub},2);
    o_data(:,isub) = baselineCorS(o_data(:,isub)',m_event,[-1400 -900],srate)';
    p_data(:,isub) = baselineCorS(p_data(:,isub)',m_event,[-1400 -900],srate)';
    plot(o_data(:,isub), 'b');
    hold on;
    plot(p_data(:,isub), 'r');
end


figure();
    plot(mean(o_data,2), 'b');
    hold on;
    plot(mean(p_data,2), 'r');
%%
% cnt = 1;
% 
% for isub = 1:8
%     
%     n_ch = size(M_ERP{1,isub},2);
%     figure();
%     for ich = 1:n_ch
%         subplot(n_ch,1,ich);
%         o_data = baselineCorS(M_ERP{1,isub}(:,ich)',m_event,[-1400 -900],srate)';
%         p_data = baselineCorS(M_ERP{3,isub}(:,ich)',m_event,[-1400 -900],srate)';
%         plot(o_data,'r');
%         hold on;
%         plot(p_data,'b');
%         cnt = cnt + 1;
%     end
% end

%% 5 x 1
clear m_a_erps m_m_erps m_low_a_erps

yrange = [0 120];
xrange = [0.5 2.5];
m_time_roi = [floor(srate*1.0):floor(srate*2)];
ylabels = {'Orig. signal', 'A', 'B', 'C', 'A + B + C'};

% tps = [.068 .073 .099 .081 .078 .058 .091 .088];
tps = [.201 .119 .223 .176 .151 .104 .181 .154];

figure('position',[10 50 300 750]);
cnt = 0;
for i = 1:3
    positionvector1 = [ 0.25 0.7-0.33*(cnt) 0.5 0.21  ];  
    
    clear values_a values_m
    for isub = 1:8
        m_a_erps{i,isub} = baselineCorS(A_ERP{i,isub}',a_event,[-500 0],srate)';
        m_m_erps{i,isub} = baselineCorS(M_ERP{i,isub}',m_event,[-1400 -900],srate)';
%         m_low_a_erps{i,isub} = baselineCorS(A_ERP{5,isub}',a_event,[-500 0],srate)';
    
        pre = 1.0;
        post = 1.0 + .5;
        a_time_roi = [floor(srate*pre):floor(srate*post)];
        
        % auditory
        n_a_ch = size(m_a_erps{i,isub},2);
        for ich = 1:n_a_ch
            values_a{isub}(ich) = mean((m_a_erps{i,isub}(a_time_roi,ich)).^2);
        end          
        
        % motor
        n_m_ch = size(m_m_erps{i,isub},2);
        for ich = 1:n_m_ch
            values_m{isub}(ich) = mean((m_m_erps{i,isub}(m_time_roi,ich)).^2,1,'omitnan');
        end        
        
    end
    
    
    cnt_a = 1;
    cnt_m = 1;
    for isub = 1:8
        n_a_ch = length(values_a{isub});
        n_m_ch = length(values_m{isub});
        for ich = 1:n_a_ch
            var_a{i}(cnt_a) = values_a{isub}(ich);
            cnt_a = cnt_a + 1;
        end
        
        for ich = 1:n_m_ch
            var_m{i}(cnt_m) = values_m{isub}(ich);
            cnt_m = cnt_m + 1;
        end
    end
    
    prtl_a = var_a{i}./var_a{1}*100;
    prtl_m = var_m{i}./var_m{1}*100;
    
    prtl_a_val{i} = var_a{i}./var_a{1}*100;
    prtl_m_val{i} = var_m{i}./var_m{1}*100;    
   
%     [h,p_a(i)] = ttest(prtl_a_val{1},prtl_a_val{i},'tail','right');
%     [h,p_m(i)] = ttest(prtl_m_val{1}([1:9 11:end]),prtl_m_val{i}([1:9 11:end]),'tail','right');
    p_a(i) = normcdf(100, mean(prtl_a_val{i}), std(prtl_a_val{i}), 'upper');
    p_m(i) = normcdf(100, mean(prtl_m_val{i}([1:4 6:8])), std(prtl_m_val{i}([1:4 6:8])), 'upper');
    
    m_pdata = [mean(prtl_a) mean(prtl_m,'omitnan')];
    s_pdata = [std(prtl_a)/(length(prtl_a).^0.5) std(prtl_m','omitnan')/(length(prtl_m).^0.5)];
    
    if i > 1
        subplot('position', positionvector1);
        h=bar(1,m_pdata(1),'FaceColor',[.9 0.2 0.2]);
        hold on;
        h=bar(2,m_pdata(2),'FaceColor',[0.2 .9 0.2]);
        my_errorbar(m_pdata,s_pdata, 0.1);
        
        ylim(yrange);
        xlim(xrange);
        set(gca, 'xticklabel', {});
        set(gca, 'fontsize', 20);
        set(gca, 'visible', 'off');
        %         ylabel(ylabels{i}, 'fontsize', 20);
        line([.5 .5],[0 100], 'linewidth', 1, 'color' ,'k');
        line([.5 2.5],[0 0], 'linewidth', 1, 'color' ,'k');
        
%         line([.4 .6],[100 100], 'linewidth', 1, 'color' ,'k');
        
        if m_pdata(1) > 50
            text(1, m_pdata(1)-s_pdata(1)-15, [num2str(round(m_pdata(1))) '%'],'fontsize', 15, 'HorizontalAlignment', 'center','color', 'w');
        else
            text(1, m_pdata(1)+s_pdata(1)+15, [num2str(round(m_pdata(1))) '%'],'fontsize', 15, 'HorizontalAlignment', 'center','color', 'k');
        end
        
        if m_pdata(2) > 50
            text(2, m_pdata(2)-s_pdata(2)-15, [num2str(round(m_pdata(2))) '%'],'fontsize', 15, 'HorizontalAlignment', 'center','color', 'k');
        else
            text(2, m_pdata(2)+s_pdata(2)+15, [num2str(round(m_pdata(2))) '%'],'fontsize', 15, 'HorizontalAlignment', 'center','color', 'k');
        end
        
        
        hline(100);
        if p_a(i) < 0.001
            text(1,101,['***'],'fontsize', 15, 'HorizontalAlignment', 'center');
        elseif p_a(i) < 0.01
            text(1,101,['**'],'fontsize', 15, 'HorizontalAlignment', 'center');
        elseif p_a(i) < 0.05
            text(1,101,['*'],'fontsize', 15, 'HorizontalAlignment', 'center');
        end
        if p_m(i) < 0.001
            text(2,101,['***'],'fontsize', 15, 'HorizontalAlignment', 'center');
        elseif p_m(i) < 0.01
            text(2,101,['**'],'fontsize', 15, 'HorizontalAlignment', 'center');
        elseif p_m(i) < 0.05
            text(2,101,['*'],'fontsize', 15, 'HorizontalAlignment', 'center');
        end
        cnt = cnt + 1;
    end
end
set(gca, 'xticklabel', {'Auditory', 'Motor'});
% ylabel('%');
set(gca, 'fontsize', 20);
text(0.5, 100, '100%', 'fontsize' ,15, 'HorizontalAlignment', 'right');
text(0.5, 0, '0%', 'fontsize' ,15, 'HorizontalAlignment', 'right');


%%
for i = 1:3
    for isub = 1:8
        a_data(:,isub) = mean(A_ERP{i,isub},2);
        a_data(:,isub) = baselineCorS(a_data(:,isub)',a_event,[-500 0],srate)';
        m_data(:,isub) = mean(M_ERP{i,isub},2);
        m_data(:,isub) = baselineCorS(m_data(:,isub)',m_event,[-1400 -900],srate)';
        AA_ERP{i}(:,1,isub) = a_data(:,isub);
        MM_ERP{i}(:,1,isub) = m_data(:,isub);
    end
end



%% 5 x 3
srate = 400;
atimex = linspace(-1,1.5,srate*2.5);
mtimex = linspace(-1.5,1.5,srate*3);
a_yrange = [-70 40];
m_yrange = [-70 40];
m_ticklength = 2;

line_width = 3;
data_line_width = 4;

a_event = zeros(1,srate*2.5);
a_event(srate+1) = 1;
m_event = zeros(1,srate*3);
m_event(srate*1.5) = 1;

ylabels = {'Orig. signal', 'A', 'B', 'C', 'A+B'};

hFig = figure('position',[1000 50 900 950]);
cnt = 0;
for i = 1:3 
    positionvector1 = [ 0.1 0.75-0.33*cnt 0.4 0.21  ];
    positionvector2 = [ 0.55 0.75-0.33*cnt 0.4 0.21 ];
    if i == 1
        % auditory
        m_a_erp{i} = baselineCorS(mean(AA_ERP{i},3)',a_event,[-500 0],srate)';
        
        % motor
        m_m_erp{i} = baselineCorS(mean(MM_ERP{i},3,'omitnan')',m_event,[-1400 -900],srate)';
        
    elseif i <5
        % auditory
        subplot('position',positionvector1);
        m_a_erp{i} = baselineCorS(mean(AA_ERP{i},3)',a_event,[-500 0],srate)';
        h = plot(atimex,m_a_erp{1}, 'r:', 'linewidth', data_line_width);
        hold on;
        set(gca, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
        set(gca,'Visible','off');
        xlim([-.25 .75]);
        ylim(a_yrange);
        hl = hline(0, 'k');
        set(hl,'linewidth',line_width);
        vl = vline(0, 'k');
        set(vl,'linewidth',line_width);
        
        text(-0.4, 20, ylabels{i}, 'fontsize', 30);
        hl=line([-.5 -.5],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.25 -0.25],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.25 0.25],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
%         hl=line([0.5 0.5],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.75 0.75],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([1 1],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        
        hl=line([-.01 .01],[a_yrange(1)  a_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-.01 .01],[a_yrange(2)  a_yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        
        h = plot(atimex,m_a_erp{i}, 'r');
        set(h, 'linewidth', data_line_width);
        
        % motor
        subplot('position',positionvector2);
        m_m_erp{i} = baselineCorS(mean(MM_ERP{i},3,'omitnan')',m_event,[-1400 -900],srate)';
        
        h = plot(mtimex,m_m_erp{1}, 'g:', 'linewidth', data_line_width);
        hold on;
        set(gca, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[]);
        set(gca,'Visible','off');
        xlim([-.5 .5]);
        ylim(m_yrange);
        hl = hline(0, 'k');
        set(hl,'linewidth',line_width);
        vl = vline(0, 'k');
        set(vl,'linewidth',line_width);
        hl=line([-1 -1],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.75 -0.75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.5 -0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.25 -0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.25 0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.5 0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([.75 .75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([1 1],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        h = plot(mtimex,m_m_erp{i}, 'g');
        set(h, 'linewidth', data_line_width);
        hl=line([-.01 .01],[m_yrange(1)  m_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-.01 .01],[m_yrange(2)  m_yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        
        cnt = cnt + 1;
    else
        % auditory
        subplot('position',positionvector1);
        m_a_erp{i} = baselineCorS(mean(AA_ERP{i},3)',a_event,[-500 0],srate)';
        
        h=plot(atimex,m_a_erp{1}, 'r:', 'linewidth', data_line_width);
        hold on;
        xlim([-.25 .75]);
        ylim(a_yrange);
        hl = hline(0, 'k');
        set(hl,'linewidth',line_width);
        vl = vline(0, 'k');
        set(vl,'linewidth',line_width);
        text(-0.4, 20, ylabels{i}, 'fontsize', 30);
%         text(-0.15, a_yrange(1), num2str(a_yrange(1)), 'fontsize', 15);
%         text(-0.115, a_yrange(2), num2str(a_yrange(2)), 'fontsize', 15);
%         text(0, a_yrange(2), ' \muV', 'fontsize', 15);
        set(gca,'Visible','off');
        hl=line([-.5 -.5],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.25 -0.25],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.25 0.25],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.5 0.5],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.75 0.75],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([1 1],[-2 2]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        h=plot(atimex,m_a_erp{i}, 'r');
        set(h, 'linewidth', data_line_width);
%         text(.5, -8, '0.5', 'fontsize', 15);
%         text(-.6, -8, '-0.5', 'fontsize', 15);
        hl=line([-.01 .01],[a_yrange(1)  a_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-.01 .01],[a_yrange(2)  a_yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        
%         hl=line([0.8 0.8],[a_yrange(1)  a_yrange(1)+20]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
%         hl=line([0.8-0.01 0.8+0.01],[a_yrange(1)  a_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
%         hl=line([0.8-0.01 0.8+0.01],[a_yrange(1)+20  a_yrange(1)+20]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
%         
%         text(0.81, a_yrange(1)+10, ' 20\muV', 'fontsize', 15);
        
        % motor
        subplot('position',positionvector2);
        m_m_erp{i} = baselineCorS(mean(MM_ERP{i},3,'omitnan')',m_event,[-1400 -900],srate)';
        h=plot(mtimex,m_m_erp{1}, 'g:', 'linewidth', data_line_width);
        hold on;
        set(gca,'Visible','off');
        xlim([-.5 .5]);
        ylim(m_yrange);
        hl = hline(0, 'k');
        set(hl,'linewidth',line_width);
        vl = vline(0, 'k');
        set(vl,'linewidth',line_width);
        
        hl=line([-1 -1],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.75 -0.75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.5 -0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-0.25 -0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.25 0.25],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.5 0.5],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([.75 .75],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([1 1],[-m_ticklength m_ticklength]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        h=plot(mtimex,m_m_erp{i}, 'g');
        set(h, 'linewidth',data_line_width);
%         text(-0.2, m_yrange(1), num2str(m_yrange(1)), 'fontsize', 15);
%         text(-0.15, m_yrange(2), num2str(m_yrange(2)), 'fontsize', 15);
%         text(0, m_yrange(2), ' \muV', 'fontsize', 15);
        text(.4, -10, '0.5 sec', 'fontsize', 15);
        text(-.55, -10, '-0.5', 'fontsize', 15);
        
        hl=line([-.01 .01],[m_yrange(1)  m_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([-.01 .01],[m_yrange(2)  m_yrange(2)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        
        hl=line([0.4 0.4],[m_yrange(1)  m_yrange(1)+20]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.4-0.01 0.4+0.01],[m_yrange(1)  m_yrange(1)]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        hl=line([0.4-0.01 0.4+0.01],[m_yrange(1)+20  m_yrange(1)+20]);         set(hl, 'linewidth', line_width);         set(hl, 'color', 'k');
        
        text(0.41, m_yrange(1)+10, ' 20\muV', 'fontsize', 15);
                
        cnt = cnt + 1;
    end

end