function RunObj = preprocess(RunObj)

disp(sprintf ( 'Generating dataset splits \n') )

if (RunObj.params.L2NORM)
    RunObj.data.data=RunObj.data.data';
    normX = sqrt(sum(RunObj.data.data.^2, 1));
    RunObj.data.data = bsxfun(@rdivide, RunObj.data.data, normX);
    RunObj.data.data=RunObj.data.data';
end

data = RunObj.data.data;
data(isnan(data))=0;

% center the data, VERY IMPORTANT
sampleMean = mean(data,1);
RunObj.data.data = data - repmat(sampleMean,size(data,1),1);

dataValid=RunObj.data.data([RunObj.data.affinityInd,RunObj.data.validInd,RunObj.data.validTrainInd],:);

chunkSize=floor(size(dataValid,1)/RunObj.params.NCHUNK);
dataValidParFor={};
for i=1:RunObj.params.NCHUNK-1
    dataValidParFor{i}=dataValid(1+((i-1)*chunkSize):(i*chunkSize),:);
end
dataValidParFor{RunObj.params.NCHUNK}=dataValid(1+((RunObj.params.NCHUNK-1)*chunkSize):(size(dataValid,1)),:);
RunObj.data.dataValidParFor=dataValidParFor;

RunObj.data.dataValid=dataValid;

chunkSize=floor(size(RunObj.data.data,1)/RunObj.params.NCHUNK);
dataParFor={};
for i=1:RunObj.params.NCHUNK-1
    dataParFor{i}=RunObj.data.data(1+((i-1)*chunkSize):(i*chunkSize),:);
end
dataParFor{RunObj.params.NCHUNK}=RunObj.data.data(1+((RunObj.params.NCHUNK-1)*chunkSize):(size(RunObj.data.data,1)),:);

RunObj.data.dataParFor=dataParFor;