clear;
clc;

load ach_data_final.mat
load mch_data_final.mat
hemi = [1 -1 1 -1 -1 1 1 -1];

%% task relevant channels for each subject
for isub = 1:8
    p_value =0;
    n_ch = length(p_value);
    topo_vector = zeros(n_ch,1);
    right_hemi = hemi(isub);
    topo_info = load_topo_info(isub);
    
    topo_info.tala.activations(1:n_ch,:) = topo_vector;
    
    
    topo_info.cmapstruct.cmin = 0;
    topo_info.cmapstruct.cmax = 1;
    
    figure();
    ecog_topo_plot(topo_info,right_hemi);
%     plotBalls(topo_info.tala.trielectrodes, 'k', 2);
    zoom(1.0);

    plotBalls(topo_info.tala.trielectrodes, 'k', 1);
    plotBalls(topo_info.tala.trielectrodes(ach_data{isub},:), 'r', 5);    
    plotBalls(topo_info.tala.trielectrodes(mch_data{isub},:), 'g', 5);    
    colorbar off
end