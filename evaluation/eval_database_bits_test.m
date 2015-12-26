function [RunObj, recall,precision,pAtR2, auprc, mAP, precisionBucket, recallBucket, f1AvgBucket] = eval_database_bits_test(RunObj, bitsData, encoding)

bitsDatabaseData = bitsData(RunObj.data.databaseInd,:);
bitsTestData = bitsData(RunObj.data.testInd,:);

precisionBucket=0;
recallBucket=0;
f1AvgBucket=[];

if (encoding==0)
   
    %[precisionBucket, recallBucket, f1AvgBucket]=bucket_eval(RunObj, bitsTestData, bitsDatabaseData, RunObj.data.testGroundTruth);
    
    bitsTestData=compactbit(bitsTestData>0);
    bitsDatabaseData=compactbit(bitsDatabaseData>0);

    distHammTestDatabase = hammingDist(bitsTestData, bitsDatabaseData);
else
    distHammTestDatabase = slmetric_pw(bitsTestData', bitsDatabaseData', 'cityblk');
end

[recall, precision, rate] = recall_precision(full(RunObj.data.testGroundTruth), distHammTestDatabase);
[RunObj,mAP]=compute_map(RunObj, full(RunObj.data.testGroundTruth),distHammTestDatabase);
[pAtR2]=recall_precision_atM(RunObj.data.testGroundTruth, distHammTestDatabase);

precision(isnan(precision))=0;
recall(isnan(recall))=0;

assert(sum(isnan(precision))==0);
assert(sum(isnan(recall))==0);

auprc=trapz(recall,precision,1);
