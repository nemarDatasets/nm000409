function [ output_args ] = my_errorbar( m_pdata,s_pdata, h_length )
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
n_data = length(m_pdata);

for it = 1:n_data
    %vertical line
    line([it it],[m_pdata(it)-s_pdata(it) m_pdata(it)+s_pdata(it)], 'linewidth', 1, 'color' ,'k');
    %horizontl top
    line([it-h_length it+h_length],[m_pdata(it)+s_pdata(it) m_pdata(it)+s_pdata(it)], 'linewidth', 1, 'color' ,'k');
    %horizontl bottom
    line([it-h_length it+h_length],[m_pdata(it)-s_pdata(it) m_pdata(it)-s_pdata(it)], 'linewidth', 1, 'color' ,'k');
end

end

