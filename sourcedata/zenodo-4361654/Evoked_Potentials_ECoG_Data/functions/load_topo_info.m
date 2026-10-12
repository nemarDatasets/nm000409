function [ topo_info ] = load_topo_info( subject_number )
%LOAD_TOPO_INGO 이 함수의 요약 설명 위치
%   자세한 설명 위치
load(['s' num2str(subject_number) '_brain.mat']);

topo_info.cmapstruct = cmapstruct;
topo_info.cortex = cortex;
topo_info.tala = tala;
topo_info.vcontribs = vcontribs;
topo_info.viewstruct = viewstruct;
topo_info.ix = ix;
end

