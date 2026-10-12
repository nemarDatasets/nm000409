clear;
clc;

load ach_data_final.mat
load mch_data_final.mat
hemi = [1 -1 1 -1 -1 1 1 -1];

for isub = 1
    filepath = ['.',filesep,'data',filesep, 'talairach_alignment',filesep, 's' num2str(isub)];
    load([filepath '/talairach_tal_brain_model.mat']);
    
    n_ch = length(tala.electrodes);
    topo_vector = zeros(n_ch,1);
    right_hemi = hemi(isub);
    
    topo_info.cmapstruct = cmapstruct;
    topo_info.cortex = cortex;
    topo_info.tala = tala;
    % topo_info.vcontribs = vcontribs;
    topo_info.viewstruct = viewstruct;
    topo_info.ix = ix;
    
    topo_info.tala.activations(1:n_ch,:) = topo_vector;
    
    
    topo_info.cmapstruct.cmin = 0;
    topo_info.cmapstruct.cmax = 1;
    
    figure();
    
    cmapstruct = topo_info.cmapstruct;
    cortex = topo_info.cortex;
    tala = topo_info.tala;
    % vcontribs = topo_info.vcontribs;
    viewstruct = topo_info.viewstruct;
    ix = topo_info.ix;
    
    % Use activate brain package
    viewstruct.viewvect = [-90 0];
    viewstruct.lightpos = [-200,0,0];
    
    viewstruct.what2view    = {'brain'};
    param.electrodes_pos = 'left';
    viewstruct.viewvect     = [270, 0];
    viewstruct.lightpos     = [-150, 0, 0];
    
    viewstruct.material     = 'dull';
    viewstruct.enablelight  = 1;
    viewstruct.enableaxis   = 0;
    viewstruct.lightingtype = 'gouraud';
    

%     if right_hemi > 0
%         viewstruct.viewvect = [-90 0];
%         viewstruct.lightpos = [-200,0,0];
%     else
%         viewstruct.viewvect = [90 0];
%         viewstruct.lightpos = [200,0,0];
%     end
    
    
    activateBrain(cortex, [], tala, ix, cmapstruct, viewstruct);
    %     plotBalls(topo_info.tala.trielectrodes, 'k', 2);
%     zoom(1.0);
    hold on;
    colorbar off;


end

%%
for isub = 1:8

    filepath = ['.',filesep,'data',filesep, 'talairach_alignment',filesep, 's' num2str(isub)];
    load([filepath '/talairach_tal_brain_model.mat']);
    
    n_ch = length(tala.electrodes);
    topo_vector = zeros(n_ch,1);
    right_hemi = hemi(isub);
    
    topo_info.cmapstruct = cmapstruct;
    topo_info.cortex = cortex;
    topo_info.tala = tala;
    % topo_info.vcontribs = vcontribs;
    topo_info.viewstruct = viewstruct;
    topo_info.ix = ix;
    
    topo_info.tala.activations(1:n_ch,:) = topo_vector;
    
    
    topo_info.cmapstruct.cmin = 0;
    topo_info.cmapstruct.cmax = 1;
    

    
    cmapstruct = topo_info.cmapstruct;
    cortex = topo_info.cortex;
    tala = topo_info.tala;
    % vcontribs = topo_info.vcontribs;
    viewstruct = topo_info.viewstruct;
    ix = topo_info.ix;
    
    %% Use activate brain package
    viewstruct.viewvect = [-90 0];
    viewstruct.lightpos = [-200,0,0];
    

%     if right_hemi > 0
%         viewstruct.viewvect = [-90 0];
%         viewstruct.lightpos = [-200,0,0];
%     else
%         viewstruct.viewvect = [90 0];
%         viewstruct.lightpos = [200,0,0];
%     end
    
    viewstruct.what2view = {'brain' 'activations'};
    
%     activateBrain(cortex, [], tala, ix, cmapstruct, viewstruct);
%     %     plotBalls(topo_info.tala.trielectrodes, 'k', 2);
%     zoom(1.0);
%     
    axis_idx = 1;
    if right_hemi < 0
        for ch = 1:n_ch
            topo_info.tala.electrodes(ch,axis_idx) = -topo_info.tala.electrodes(ch,axis_idx);
            topo_info.tala.electrodes(ch,axis_idx) = topo_info.tala.electrodes(ch,axis_idx) - 10;
%             topo_info.tala.electrodes(ch,1) = topo_info.tala.electrodes(ch,1)-10;
        end
    else
        for ch = 1:n_ch
            topo_info.tala.electrodes(ch,axis_idx) = topo_info.tala.electrodes(ch,axis_idx) - 10;
%             topo_info.tala.electrodes(ch,1) = topo_info.tala.electrodes(ch,1)-10;
        end
    end

    
    plotBalls(topo_info.tala.electrodes, 'k', 1);
%     plotBalls(topo_info.tala.electrodes(ach_data{isub},:), 'r', 2);
%     plotBalls(topo_info.tala.electrodes(mch_data{isub},:), 'g', 2);
    colorbar off


end

for isub = 1:8
    filepath = ['.',filesep,'data',filesep, 'talairach_alignment',filesep, 's' num2str(isub)];
    load([filepath '/talairach_tal_brain_model.mat']);
    
    n_ch = length(tala.electrodes);
    topo_vector = zeros(n_ch,1);
    right_hemi = hemi(isub);
    
    topo_info.cmapstruct = cmapstruct;
    topo_info.cortex = cortex;
    topo_info.tala = tala;
    % topo_info.vcontribs = vcontribs;
    topo_info.viewstruct = viewstruct;
    topo_info.ix = ix;
    
    topo_info.tala.activations(1:n_ch,:) = topo_vector;
    
    
    topo_info.cmapstruct.cmin = 0;
    topo_info.cmapstruct.cmax = 1;
    
    cmapstruct = topo_info.cmapstruct;
    cortex = topo_info.cortex;
    tala = topo_info.tala;
    % vcontribs = topo_info.vcontribs;
    viewstruct = topo_info.viewstruct;
    ix = topo_info.ix;
    
    %% Use activate brain package
    viewstruct.viewvect = [-90 0];
    viewstruct.lightpos = [-200,0,0];
    

%     if right_hemi > 0
%         viewstruct.viewvect = [-90 0];
%         viewstruct.lightpos = [-200,0,0];
%     else
%         viewstruct.viewvect = [90 0];
%         viewstruct.lightpos = [200,0,0];
%     end
    
    viewstruct.what2view = {'brain' 'activations'};
    
%     activateBrain(cortex, [], tala, ix, cmapstruct, viewstruct);
%     %     plotBalls(topo_info.tala.trielectrodes, 'k', 2);
%     zoom(1.0);
    
    axis_idx = 1;
    if right_hemi < 0
        for ch = 1:n_ch
            topo_info.tala.electrodes(ch,axis_idx) = -topo_info.tala.electrodes(ch,axis_idx);
            topo_info.tala.electrodes(ch,axis_idx) = topo_info.tala.electrodes(ch,axis_idx) - 10;
%             topo_info.tala.electrodes(ch,1) = topo_info.tala.electrodes(ch,1)-10;
        end
    else
        for ch = 1:n_ch
            topo_info.tala.electrodes(ch,axis_idx) = topo_info.tala.electrodes(ch,axis_idx) - 10;
%             topo_info.tala.electrodes(ch,1) = topo_info.tala.electrodes(ch,1)-10;
        end
    end

    
%     plotBalls(topo_info.tala.electrodes, 'k', 1);
    plotBalls(topo_info.tala.electrodes(ach_data{isub},:), 'r', 2);
    plotBalls(topo_info.tala.electrodes(mch_data{isub},:), 'g', 2);
    colorbar off

end