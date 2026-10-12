function tTarget_data = baselineCorS(data, trigger, frame, srate)
%function tTarget_data = baselineCorS(data, trigger, frame, srate)
%
%*** INPUT ***
% data : signal [chan   by   time]
% trigger : trigger signal  [ 1 by time]    same length with data
% frame : frame region to be baseline
%          ex) [-1000 -500]
% srate : sampling rate
%
%*** OUTPUT ***
% tTarget_data : signal after baseline correction
%
%*** USAGE ***
%baselineCorS(data, trigger, frame, srate)
%-> baseline : frame region
%
%baselineCorS(data, trigger)
%-> baseline : before onset region 
%
%baselineCorS(data)
%-> baseline : whole region
%
%----------------------------------------------------------------
% Minkyu Ahn        frerap@gist.ac.kr
% http://biocomput.gist.ac.kr


if(exist('frame', 'var'))
    start_sam = int32(srate*frame(1) / 1000);
    end_sam = int32(srate*frame(2) /1000);
    start_sam = start_sam + 1;
    
    ind = find(trigger>0);
        
    kind = [];
    for kk=1:length(ind)
       temp = (ind(kk)+start_sam):(ind(kk)+end_sam);
       kind = [kind temp]; 
    end

    
elseif(exist('trigger', 'var'))
    ind = find(trigger>0);
    kind = [];
    prefactor = ind(1) - 1;
    
    for kk=1:length(ind)
       temp = (ind(kk)-prefactor):(ind(kk));
       kind = [kind temp]; 
    end
    
else
    kind = 1:size(data,2);
    
end


tempd = data(:, kind);
aa = mean(tempd,2);
md = repmat(aa, 1, size(data,2));
tTarget_data = data - md;
    
return;
