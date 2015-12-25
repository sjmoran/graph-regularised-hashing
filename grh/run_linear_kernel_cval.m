function [RunObj] = run_linear_kernel_cval(RunObj, affinity, bitsSBQ, fp)

cArray=[0.001,0.01,0.1,1.0,10,100,1000];

mAPMaxValid=0;
f1BucketMaxValid=0;
auprcMaxValid=0;

alpha=RunObj.params.ALPHA;
nIter=RunObj.params.NITER;

for i=1:size(cArray,2)   % Pick best C for constant ALPHA
    
    RunObj.params.C=cArray(1,i);
    
    disp(['Cross validating for C=',num2str(RunObj.params.C)])
    
    for j=1:nIter
        
        if (j==1)
            bitsGRH=bitsSBQ(RunObj.data.affinityInd,:);
        else
            bitsGRH=bitsGRH(1:RunObj.params.NAFFINITY,:);
        end
        
        [bitsGRH, mAPGRHValid, svmModel] = learn_grh(RunObj, affinity, bitsGRH, bitsSBQ);
    end
    
    if (mAPGRHValid>mAPMaxValid)
        mAPMaxValid=mAPGRHValid;
        maxC=RunObj.params.C;
    end
    
    fprintf(fp, '%s\n', '******************');
    fprintf(fp, '%s\t%.5f\n', 'NITER', RunObj.params.NITER);
    fprintf(fp, '%s\t%.5f\n', 'C', RunObj.params.C);
    fprintf(fp, '%s\t%.5f\n', 'mAP (Valid)', mAPGRHValid);

    fprintf(fp, '%s\n', '******************');
    
end

disp(sprintf('%s\t%.5f\n', 'Best C', maxC))
disp(sprintf('%s\t%.5f\n', 'Best ALPHA', alpha))
disp(sprintf('%s\t%.5f\n', 'Best NITER', nIter))
disp(sprintf('%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid))

fprintf(fp, '%s\n', '******************');

fprintf(fp, '%s\t%.5f\n', 'Best C', maxC);
fprintf(fp, '%s\t%.5f\n', 'Best ALPHA', alpha);
fprintf(fp, '%s\t%.5f\n', 'Best NITER', nIter);
fprintf(fp, '%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid);

fprintf(fp, '%s\n', '******************');

RunObj.params.C=maxC;