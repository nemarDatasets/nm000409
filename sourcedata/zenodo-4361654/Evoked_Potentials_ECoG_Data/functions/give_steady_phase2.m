function [ output_args ] = give_steady_phase2( input_data, stim_onset )
%REMOVE_SIGNAL_POWER_CHANGES 이 함수의 요약 설명 위치
%   자세한 설명 위치
% input_data: time x channel

n_ch = size(input_data,2);
n_time = size(input_data,1);
factor = 20;

for ch = 1:n_ch  
        %%
%         figure();
%         timex = linspace(-1000,1500,n_time);
%         plot(timex,input_data(:,ch));
        %%
        % for data
        tmp_data =  hilbert(input_data(:,ch));
        ang_data = angle(tmp_data);
        
        % extract phase velocity from baseline data
        b_tmp_data = hilbert(stim_onset(:,ch));
        b_ang_data = angle(b_tmp_data);
        
        y = diff(b_ang_data);
        [idx] = find(abs(y)>6);
        corrected_y = y;
        corrected_y(idx) = y(idx) + 2*pi;       
        
        exp_b_v = median(corrected_y);
        
        tmp_ang_data(1) = ang_data(1);
        for tp = 2:n_time
            tmp_ang_data(tp) = tmp_ang_data(tp-1) + exp_b_v;
        end
%         tmp_ang_data1 = tmp_ang_data + 2*pi;
        
        pdata = cos(tmp_ang_data)';        
        amplitude = abs(tmp_data);
        output_args(:,ch) = pdata.*amplitude; 
end


end

