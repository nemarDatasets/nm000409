function [] = figure5_P200()

srate =400;

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

load no_lf_effect_ch_final_400hz.mat
for isub = 1:8
    A_ERP{2,isub} = eeg_a_erps{isub};
    M_ERP{2,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{2,isub} = zeros(size(m_event))';
    end
end

load no_phase_erp_3_hz_ch_final_400hz.mat
% load no_hg_effect_on_lf
for isub = 1:8
    A_ERP{3,isub} = eeg_a_erps{isub};
    M_ERP{3,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{3,isub} = zeros(size(m_event))';
    end
end

load no_AofB_effect_ch_final_400hz.mat
for isub = 1:8
    A_ERP{4,isub} = eeg_a_erps{isub};
    M_ERP{4,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{4,isub} = zeros(size(m_event))';
    end
end

load no_lf_ch_final.mat
for isub = 1:8
    A_ERP{5,isub} = eeg_a_erps{isub};
    M_ERP{5,isub} = eeg_m_erps{isub};
    if isub == 5
        M_ERP{5,isub} = zeros(size(m_event))';
    end
end


%% 5 x 1
clear m_a_erps m_m_erps m_low_a_erps

yrange = [0 120];
xrange = [0.5 2.5];
m_time_roi = [floor(srate*1.0):floor(srate*2)];
ylabels = {'Orig. signal', 'A', 'B', 'C', 'A + B + C'};

% tps = [.068 .073 .099 .081 .078 .058 .091 .088];
tps = [.201 .119 .223 .176 .151 .104 .181 .154];

figure('position',[10 50 300 750]);
cnt = 1;
for i = 1:4
    positionvector1 = [ 0.25 0.7-0.33*(cnt-1) 0.5 0.21  ];  
    
    clear values_a values_m
    for isub = 1:8
        m_a_erps{i,isub} = baselineCorS(A_ERP{i,isub}',a_event,[-500 0],srate)';
        m_m_erps{i,isub} = baselineCorS(M_ERP{i,isub}',m_event,[-1400 -900],srate)';
        m_low_a_erps{i,isub} = baselineCorS(A_ERP{5,isub}',a_event,[-500 0],srate)';
    
        tp = tps(isub);
        pre = 1.0 + tp - 0.05;
        post = 1.0 + tp + 0.05;
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
%     [h,p_m(i)] = ttest(prtl_m_val{1}([1:4 6:8]),prtl_m_val{i}([1:4 6:8]),'tail','right');
    
    normcdf_p(i) = normcdf(100, mean(prtl_a_val{i}), std(prtl_a_val{i}), 'upper');
    
    m_pdata = [mean(prtl_a)];
    s_pdata = [std(prtl_a)/(length(prtl_a).^0.5)];
    
    if i > 1
        subplot('position', positionvector1);
        h=bar(1,m_pdata(1),'FaceColor',[.9 0.2 0.2]);
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
        
      
        
        hline(100);
        if normcdf_p(i) < 0.005
            text(1,101,['***'],'fontsize', 15, 'HorizontalAlignment', 'center');
        elseif normcdf_p(i) < 0.01
            text(1,101,['**'],'fontsize', 15, 'HorizontalAlignment', 'center');
        elseif normcdf_p(i) < 0.05
            text(1,101,['*'],'fontsize', 15, 'HorizontalAlignment', 'center');
        end

        cnt = cnt + 1;
    end
end


