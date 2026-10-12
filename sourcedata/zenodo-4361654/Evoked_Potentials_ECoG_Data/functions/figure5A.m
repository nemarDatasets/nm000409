function [] = figure5A()
%%
load original_erp_final.mat
A_ERP{1} = eeg_a_erps;
M_ERP{1} = eeg_m_erps;

load no_lf_effect_final.mat
A_ERP{2} = eeg_a_erps;
M_ERP{2} = eeg_m_erps;

load no_phase_erp_3_hz_final.mat
A_ERP{3} = eeg_a_erps;
M_ERP{3} = eeg_m_erps;

load no_AofB_effect_final.mat
A_ERP{4} = eeg_a_erps;
M_ERP{4} = eeg_m_erps;

% plot ERPs
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

ylabels = {'Orig. signal', '1', '2', '1+2'};

hFig = figure('position',[10 50 900 750]);
cnt = 0;
for i = 1:4
    positionvector1 = [ 0.1 0.7-0.33*cnt 0.4 0.25  ];
    positionvector2 = [ 0.55 0.7-0.33*cnt 0.4 0.25 ];
    if i == 1
        % auditory
        m_a_erp{i} = baselineCorS(mean(A_ERP{i},3)',a_event,[-500 0],srate)';
        
        % motor
        m_m_erp{i} = baselineCorS(mean(M_ERP{i},3,'omitnan')',m_event,[-1400 -900],srate)';
        
    elseif i <5
        % auditory
        subplot('position',positionvector1);
        m_a_erp{i} = baselineCorS(mean(A_ERP{i},3)',a_event,[-500 0],srate)';
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
        m_m_erp{i} = baselineCorS(mean(M_ERP{i},3,'omitnan')',m_event,[-1400 -900],srate)';
        
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
        m_a_erp{i} = baselineCorS(mean(A_ERP{i},3)',a_event,[-500 0],srate)';
        
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
        m_m_erp{i} = baselineCorS(mean(M_ERP{i},3,'omitnan')',m_event,[-1400 -900],srate)';
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





