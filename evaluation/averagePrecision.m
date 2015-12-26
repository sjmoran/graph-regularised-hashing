function ap = averagePrecision(trueY, predictedY, rankings) 
% Compute the average precision of a set of true and predicted labels.
%
% Usage: ap = averagePrecision(trueY, predictedY, rankings) 
% Inputs/Outputs: 
%   trueY - a column vector of binary labels 
%   predictedY - a column vector of predicted labels 
%   rankings - rankings of predicted labels (higher is more
%   confident)
%
%   ap - the average precision
%
% Copyright (C) 2006 Charanpal Dhanjal 

% This library is free software; you can redistribute it and/or
% modify it under the terms of the GNU Lesser General Public
% License as published by the Free Software Foundation; either
% version 2.1 of the License, or (at your option) any later version.
% 
% This library is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public
% License along with this library; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
% USA

if (nargin ~= 3)
    fprintf('%s\n', help('averagePrecision'));
    error('Incorrect number of inputs - see above usage instructions.');
end

numExamples = length(trueY);
numPositiveLabels = sum(trueY == 1);

tempMatrix = [-rankings, trueY , predictedY]; 
tempMatrix = sortrows(tempMatrix,1);  %Sorts labels with lowest rank first 

relevantLabels =((tempMatrix(:, 3) == 1) == tempMatrix(:, 2)); 
cumulativeSum = cumsum(relevantLabels); 
indices = (1:numExamples)';

if numPositiveLabels ~= 0 
    ap = sum((cumulativeSum .* relevantLabels) ./ indices)/numPositiveLabels; 
else 
    ap = 0; 
end

