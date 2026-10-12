function [ output_args ] = giver_steady_power_for_each_freq_v4(input_args, srate, base_data, fband)
%GIVER_STEADY_PV_FOR_EACH_FREQ 이 함수의 요약 설명 위치
%   자세한 설명 위치
% input_args: time x channel

n_tp = size(input_args,1);
n_ch = size(input_args,2);

for f_iter = 0:floor(srate/2)    
    
    if f_iter == 0
        new_X = fft_bandpass_filtering(input_args,srate,[0 f_iter+0.5]);
        new_base_data = fft_bandpass_filtering(base_data,srate,[0 f_iter+0.5]);
    else        
        new_X = fft_bandpass_filtering(input_args,srate,[f_iter-0.5 f_iter+0.5]);
        new_base_data = fft_bandpass_filtering(base_data,srate,[f_iter-0.5 f_iter+0.5]);
    end
    
    scale_factor = median(abs(hilbert(new_base_data(srate*.5:srate,:))));        
    
    if f_iter >= fband(1) && f_iter <= fband(2)
        new_X_no_pc(:,:,f_iter+1) = remove_signal_power_changes(new_X, scale_factor);
    else
        new_X_no_pc(:,:,f_iter+1) = new_X;
    end
end

output_args = sum(new_X_no_pc,3);

end

