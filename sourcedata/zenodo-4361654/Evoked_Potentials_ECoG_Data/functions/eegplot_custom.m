function out = eegplot_custom(data,srate, n_tr, frame,base,window,linecolor)
out = [];
hFig = figure('position',[10 50 400 550]);

m_amp = mean(abs(data(:)))*8.5;

erp = mean(data,2);
event = zeros(1,length(erp));
[v zero_idx] = min(abs(frame));
zero_idx = zero_idx - 1;
event(zero_idx) = 1;
erp = baselineCorS(erp',event,base,srate)';

plot(frame,erp*2, linecolor, 'linewidth',4);

hold on;
tr_idx = [size(data,2) n_tr-1:-1:1];
for cnt = 1:n_tr
    plot(frame,data(:,tr_idx(cnt)) + m_amp*(cnt), linecolor, 'linewidth',4);    
%     h = hline(m_amp*(tr),'k:');
%     set(h,'linewidth',4);
end

set(gca,'Visible','off');

n_tr = n_tr + 1;
ylim([-m_amp*1. m_amp*(n_tr*0.9)]);
xlim(window);

h = vline(0,'k:');
set(h,'linewidth',4);
h = hline(0,'k:');
set(h,'linewidth',4);
uistack(h,'bottom');

% line([-10 10],[200 200]);
end