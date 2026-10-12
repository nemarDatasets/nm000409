function [ output_args, avg_amps ] = remove_signal_power_changes( input_data, input_scale_factor )
%REMOVE_SIGNAL_POWER_CHANGES 이 함수의 요약 설명 위치
%   자세한 설명 위치
% input_data: time x channel

n_ch = size(input_data,2);

for ch = 1:n_ch
    tmp_data =  hilbert(input_data(:,ch));
    if isempty(input_scale_factor)
        amplitude = abs(tmp_data);
        scale_factor = median(amplitude(1:20));
    else
        scale_factor = input_scale_factor(ch);
    end    
    angle_data = angle(tmp_data);
    
    pdata = cos(angle_data)*scale_factor;
    
    output_args(:,ch) = pdata;
    avg_amps(ch) = scale_factor;
end


end

