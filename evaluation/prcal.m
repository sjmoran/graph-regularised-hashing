function [ph2] = prcal(score,label)
% 
% Precision and Recall calculation for approximate nearest neighbor search 
% input: 
%  score - 1xn continuse real value 
%  label - 1xn discrete real value
%  labelvalue - value of true positives in the 'label' vector
%  p is the precision  
%  r is the recall
%  apM 
%%% Last update 
%%% Jan. 20, 2010
%%% Jun Wang (jwang@ee.columbia.edu)
if length(score)~=length(label)
    error('score and label must be equal length\n');
    pause;
end

hd2_ind=find(score<=2);
if isempty(hd2_ind)
    ph2=0;
else
    ph2=sum(label(hd2_ind))/length(hd2_ind);
end