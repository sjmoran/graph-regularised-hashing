function [RunObj,pAtR2, mAP] = eval_train_bits_valid(RunObj, bitsData)

bitsData(1:RunObj.params.NAFFINITY,:)=[];                 % Remove the affinity points - see preprocess
bitsValidData = bitsData(1:RunObj.params.NVALIDTEST,:);
bitsData(1:RunObj.params.NVALIDTEST,:)=[];
bitsTrainData = bitsData;

bitsValidData=compactbit(bitsValidData>0);
bitsTrainData=compactbit(bitsTrainData>0);

distHammTrainValid = hammingDist(bitsValidData, bitsTrainData);

[RunObj,mAP]=compute_map(RunObj, RunObj.data.validGroundTruth,distHammTrainValid);
[pAtR2]=recall_precision_atM(RunObj.data.validGroundTruth, distHammTrainValid);
