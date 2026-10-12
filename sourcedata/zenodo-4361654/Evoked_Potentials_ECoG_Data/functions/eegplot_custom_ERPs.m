function out = eegplot_custom_ERPs(data,srate, n_tr, frame,base,window,linecolor)
out = [];
hFig = figure('position',[10 50 400 550]);
scaling = 0.5;
n_ch = size(data,2);

m_amp = mean(abs(data(:)))*10;

erp = mean(data,2);
event = zeros(1,length(erp));
[v zero_idx] = min(abs(frame));
zero_idx = zero_idx - 1;
event(zero_idx) = 1;
erp = baselineCorS(erp',event,base,srate)';

plot(frame,erp*scaling, linecolor, 'linewidth',4);

if n_ch >1
    hold on;
    for tr = 1:n_tr
        pdata = data(:,tr);
        pdata = baselineCorS(pdata',event,base,srate)';
        plot(frame,pdata*scaling + m_amp*(tr), linecolor, 'linewidth',4);
        hlines(tr) = hline( m_amp*(tr),'k:');
        set(hlines(tr),'linewidth',4);
        uistack(hlines(tr),'bottom');
    end
end

set(gca,'Visible','off');

n_tr = n_tr + 1;
ylim([-m_amp*.7 m_amp*(n_tr*.9)]);
xlim(window);

h = vline(0,'k:');
set(h,'linewidth',4);
h = hline(0,'k:');
set(h,'linewidth',4);
uistack(h,'bottom');
end