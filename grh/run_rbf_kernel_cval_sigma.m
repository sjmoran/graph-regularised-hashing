function [RunObj] = run_rbf_kernel_cval_sigma(RunObj, affinity, bitsSBQ, fp)

sigmasArray=[0.001,0.01,0.1,1,10,100,1000];

mAPMaxValid=0;
svmModel={};

for i=1:size(sigmasArray,2)  % Pick best ALPHA for constant SIGMA
    
    RunObj.params.SIGMA=sigmasArray(1,i);
    
    disp(['Cross validating for sigma=',num2str(RunObj.params.SIGMA)])
    
    bitsGRH=bitsSBQ(RunObj.data.affinityInd,:);
    
    [bitsGRH, mAPGRHValid, svmModel] = learn_grh(RunObj, affinity, bitsGRH, bitsSBQ);
    
    if (mAPGRHValid>mAPMaxValid)
        mAPMaxValid=mAPGRHValid;
        maxSigma=RunObj.params.SIGMA;
    end
    
    fprintf(fp, '%s\n', '******************');
    fprintf(fp, '%s\t%.5f\n', 'SIGMA', RunObj.params.SIGMA);
    fprintf(fp, '%s\t%.5f\n', 'mAP (Valid)', mAPGRHValid);
    fprintf(fp, '%s\n', '******************');
end

disp(sprintf('%s\t%.5f\n', 'Best SIGMA', maxSigma))
disp(sprintf('%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid))

fprintf(fp, '%s\n', '******************');

fprintf(fp, '%s\t%.5f\n', 'Best SIGMA', maxSigma);
fprintf(fp, '%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid);

fprintf(fp, '%s\n', '******************');

RunObj.params.SIGMA=maxSigma;