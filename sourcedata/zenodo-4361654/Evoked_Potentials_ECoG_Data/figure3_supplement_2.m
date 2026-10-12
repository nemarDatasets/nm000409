clc
clear;

load RT_auditory.mat
figure();
for di = 1:4
    mdata(di) = mean(norm_all_div_data{di});
    sdata(di) = std(norm_all_div_data{di})/length(norm_all_div_data{di})^0.5;
end
% bar(mdata);
% hold on;
errorbar(mdata,sdata,'.','CapSize',20);
hold on;
xlim([0.5 4.5]);

x1 = 1:4;
[P,S] = polyfit(x1,mdata,1);
% [V1 V2]=corrcoef(mdata,x1)
[RHO,PVAL] = corr(mdata',x1')
y1 = polyval(P,x1);
plot(x1,y1)
R2 = 1 - (S.normr/norm(mdata - mean(mdata)))^2;
xlabel('3-40 Hz Prestimulus Power Bins');
ylabel('Normalized Reaction Time');

[d1 d2] = ranksum(norm_all_div_data{1},norm_all_div_data{4})
ylim([-0.15 0.15]);

