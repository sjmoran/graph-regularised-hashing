function RunObj = get_best_alpha(RunObj, affinity, bitsSBQ, fp)

alphasArray=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
maxAlpha=0;
mAPMaxValid=0;
maxIter=0;

for i=1:size(alphasArray,2)  % Pick best ALPHA for constant SIGMA
    
    bitsGRH=bitsSBQ(RunObj.data.affinityInd,:);
    mAPGRHValidPrev=0;
    
    for j=1:1000  %Infinite
        
        RunObj.params.ALPHA=alphasArray(1,i);
        
        disp(['Cross validating for alpha=',num2str(RunObj.params.ALPHA)])
        
        [bitsGRH,mAPGRHValid, svmModel] = learn_grh(RunObj, affinity, bitsGRH, bitsSBQ);
        
        if (mAPGRHValid>mAPMaxValid)
            mAPMaxValid=mAPGRHValid;
            maxAlpha=RunObj.params.ALPHA;
            maxIter=j;
        end
        
        bitsGRH=bitsGRH(1:RunObj.params.NAFFINITY,:);  % the first NAFFINITY are the affinity points - see preprocess
        
        fprintf(fp, '%s\n', '******************');
        
        fprintf(fp, '%s\t%.5f\n', 'ALPHA', RunObj.params.ALPHA);
        fprintf(fp, '%s\t%.5f\n', 'mAP (Valid)', mAPGRHValid);
        fprintf(fp, '%s\t%.5f\n', 'ITERATION', j);
        
        fprintf(fp, '%s\n', '******************');
        if (mAPGRHValid <= mAPGRHValidPrev)
            break; % if mAP falls during iteration
        end
        mAPGRHValidPrev=mAPGRHValid;
    end
end

RunObj.params.ALPHA=maxAlpha;
RunObj.params.NITER=maxIter;

disp(sprintf('%s\t%.5f\n', 'Best nIter', maxIter))
disp(sprintf('%s\t%.5f\n', 'Best ALPHA', maxAlpha))
disp(sprintf('%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid))

fprintf(fp, '%s\n', '******************');

fprintf(fp, '%s\t%.5f\n', 'Best nIter', maxIter);
fprintf(fp, '%s\t%.5f\n', 'Best ALPHA', maxAlpha);
fprintf(fp, '%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid);

fprintf(fp, '%s\n', '******************');