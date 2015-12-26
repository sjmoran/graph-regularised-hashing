function [RunObj,pAtR2, mAP] = eval_train_bits_test(RunObj, bitsData)

bitsTrainData = bitsData(RunObj.data.trainInd,:);
bitsTestData = bitsData(RunObj.data.testInd,:);

bitsTestData=compactbit(bitsTestData>0);
bitsTrainData=compactbit(bitsTrainData>0);

distHammTrainTest = hammingDist(bitsTestData, bitsTrainData);

[RunObj,mAP]=compute_map(RunObj, full(RunObj.data.testGroundTruth),distHammTrainTest);
[pAtR2]=recall_precision_atM(RunObj.data.testGroundTruth, distHammTrainTest);

