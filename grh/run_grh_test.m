function [RunObj,pAtR2GRH,mAPGRH] = run_grh_test(RunObj,affinity, bitsSBQ, fp)

nIter=RunObj.params.NITER;

svmModel={};

for i=1:nIter 

    if (i==1)
        bitsGRH=bitsSBQ(RunObj.data.affinityInd,:);
    else
        bitsGRH=bitsGRH(1:RunObj.params.NAFFINITY,:);
    end
    
    [bitsGRH, mAPGRHValid, svmModel] = learn_grh(RunObj, affinity, bitsGRH, bitsSBQ);
    
    fprintf(fp, '%s\n', '******************');
    fprintf(fp, '%s\t%.5f\n', 'NITER', nIter);
    fprintf(fp, '%s\t%.5f\n', 'C', RunObj.params.C);
    fprintf(fp, '%s\t%.5f\n', 'SIGMA', RunObj.params.SIGMA);
    fprintf(fp, '%s\t%.5f\n', 'mAP (Valid)', mAPGRHValid);

    fprintf(fp, '%s\n', '******************');
    
end

%%%%% Predict on the test queries

data=RunObj.data.dataParFor;

bitsGRH=[];
dataProj=[];
predictedScores={};
predictedLabels={};

for k=1:RunObj.params.NBITS
    
    predictedLabels={};
    
    if (RunObj.params.KERNEL==3)        
        parfor m=1:RunObj.params.NCHUNK
            [errorRate{m}, predictedLabels{m}, predictedScores{m}] = budgetedsvm_predict(ones(size(data{m},1),1), data{m}, svmModel{k});
        end
    elseif (RunObj.params.KERNEL==2)
        
        parfor m=1:RunObj.params.NCHUNK
            [predictedLabels{m}, accuracy{m}, predictedScores{m}]=svmpredict(ones(size(data{m},1),1), data{m}, svmModel{k});
        end
        
    else
        
        parfor m=1:RunObj.params.NCHUNK
            [predictedLabels{m}, accuracy{m}, predictedScores{m}]=predict(ones(size(data{m},1),1), sparse(data{m}), svmModel{k});
        end
        
    end
    
    bitsGRHTemp=[];
    
    for m=1:RunObj.params.NCHUNK
        bitsGRHTemp=[bitsGRHTemp;predictedLabels{m}];
    end
    
    bitsGRH=[bitsGRH,bitsGRHTemp];
    
    dataProjTemp=[];
    
    for m=1:RunObj.params.NCHUNK
        dataProjTemp=[dataProjTemp;predictedScores{m}];
    end
    
    dataProj=[dataProj,dataProjTemp];
end

RunObj.data.dataProj=dataProj;
RunObj.data.dataValidProj=dataProj([RunObj.data.affinityInd,RunObj.data.validInd,RunObj.data.validTrainInd],:);

% Quantise projections
bitsGRH(bitsGRH>0)=1;
bitsGRH(bitsGRH<=0)=0;

[RunObj,pAtR2GRH, mAPGRH]=eval_bits(RunObj, bitsGRH, 0);