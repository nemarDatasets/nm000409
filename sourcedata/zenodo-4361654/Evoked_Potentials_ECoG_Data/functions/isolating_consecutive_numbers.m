function [seq] = isolating_consecutive_numbers(A)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
A(end+1)=2;   % adds new endpoint to very end of A so code picks up end of last group of consecutive values
I_1=find(diff(A)~=1);  % finds where sequences of consecutive numbers end
[n]=length(I_1);   % finds dimensions of I_1 i.e. how many sequences of consecutive numbers you have
startpoint=1;    % sets start index at the first value in your array
seq=cell(1,n);  % had to preallocate because without, it only saved last iteration of the for loop below
               % used n because this array is a row vector
for i=1:n
    End_Idx=I_1(i);   %set end index
    seq{i}=A(startpoint:End_Idx);  %finds sequences of consecutive numbers and assigns to cell array
    startpoint=End_Idx+1;   %update start index for the next consecutive sequence
end

end

