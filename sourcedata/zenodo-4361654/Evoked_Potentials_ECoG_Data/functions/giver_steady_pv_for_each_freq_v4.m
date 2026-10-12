function [ output_args ] = giver_steady_pv_for_each_freq_v4(input_args, srate, base_data, fband)
%GIVER_STEADY_PV_FOR_EACH_FREQ 이 함수의 요약 설명 위치
%   자세한 설명 위치
% input_args: time x channel

n_tp = size(input_args,1);
n_ch = size(input_args,2);

for f_iter = 0:floor(srate/2)
% for f_iter = 6
    if f_iter == 0
        new_X = fft_bandpass_filtering(input_args,srate,[0 f_iter+0.5]);
        new_base_data = fft_bandpass_filtering(base_data,srate,[0 f_iter+0.5]);
    else        
        new_X = fft_bandpass_filtering(input_args,srate,[f_iter-0.5 f_iter+0.5]);
        new_base_data = fft_bandpass_filtering(base_data,srate,[f_iter-0.5 f_iter+0.5]);
    end
    if f_iter >= fband(1) && f_iter <= fband(2)
        new_X_no_pc(:,:,f_iter+1) = give_steady_phase2(new_X, new_base_data);
    else
        new_X_no_pc(:,:,f_iter+1) = new_X;
    end   
    

    
    
    %%
%     n_plots = 3;
%     a_timex = linspace(-1,1.5,srate*2.5);
%     
%     figure();
%     subplot(n_plots,1,1);
%     plot(a_timex,new_X,'r','linewidth',3);
% %     xlim([-.5 1.0]);
%     
%     subplot(n_plots,1,2);
%     plot(a_timex,new_X,'b','linewidth',1);
%     hold on;
%     plot(a_timex,new_X_no_pc(:,:,f_iter+1),'r','linewidth',3);
%     hold on;
% %     xlim([-.5 1.0]);
    
    
    
end

output_args = sum(new_X_no_pc,3);

    %%
%     n_plots = 3;
%     a_timex = linspace(-1,1.5,srate*2.5);
%     
%     figure();
%     subplot(n_plots,1,1);
%     plot(a_timex,input_args,'r','linewidth',3);
%     
%     subplot(n_plots,1,2);
%     plot(a_timex,input_args,'b','linewidth',1);
%     hold on;
%     plot(a_timex,output_args,'r','linewidth',3);

%     xlim([-.5 1.0]);
    
    
%     subplot(n_plots,1,1);
%     plot(a_timex,new_X);
%     
%     subplot(n_plots,1,2);
%     plot(a_timex,new_X_no_pc(:,:,f_iter+1),'r','linewidth',3);
%     hold on;
%     plot(a_timex,new_X);

%     subplot(n_plots,1,2);
%     plot(a_timex,new_X_no_pc(:,:,f_iter+1),'r','linewidth',3);
%     hold on;
%     plot(a_timex,new_X);



end

