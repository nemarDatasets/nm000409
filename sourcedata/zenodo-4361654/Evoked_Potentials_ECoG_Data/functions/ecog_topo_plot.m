function [ ] = ecog_topo_plot(topo_info,right_hemi)

cmapstruct = topo_info.cmapstruct;
cortex = topo_info.cortex;
tala = topo_info.tala;
vcontribs = topo_info.vcontribs;
viewstruct = topo_info.viewstruct;
ix = topo_info.ix;

%% Use activate brain package
if right_hemi > 0
    viewstruct.viewvect = [-90 0];
    viewstruct.lightpos = [-200,0,0];
else
    viewstruct.viewvect = [90 0];
    viewstruct.lightpos = [200,0,0];
end

viewstruct.what2view = {'brain' 'activations'};

activateBrain(cortex, vcontribs, tala, ix, cmapstruct, viewstruct);
% NeuralAct(cortex, vcontribs, tala, 1, cmapstruct, viewstruct);

