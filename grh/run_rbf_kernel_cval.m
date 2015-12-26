function [RunObj] = run_rbf_kernel_cval(RunObj,affinity, bitsSBQ, fp)

sigmasArray=[0.001,0.01,0.1,1,10,100,1000];
cArray=[0.001,0.01,0.1,1,10,100,1000];

mAPMaxValid=0;

svmModel={};
nIter=RunObj.params.NITER;

for i=1:size(sigmasArray,2)  % Pick best ALPHA for constant SIGMA
    
    for j=1:size(cArray,2)   % Pick best C for constant SIGMA,ALPHA
        
        RunObj.params.SIGMA=sigmasArray(1,i);
        RunObj.params.C=cArray(1,j);
        
        disp(['Cross validating for sigma=',num2str(RunObj.params.SIGMA)])
        disp(['Cross validating for C=',num2str(RunObj.params.C)])
        
        for k=1:nIter
            
            if (k==1)
                bitsGRH=bitsSBQ(RunObj.data.affinityInd,:);
            else
                bitsGRH=bitsGRH(1:RunObj.params.NAFFINITY,:);
            end
            
            [bitsGRH, mAPGRHValid, svmModel] = learn_grh(RunObj, affinity, bitsGRH, bitsSBQ);
            
        end
        
        if (mAPGRHValid>mAPMaxValid)
            mAPMaxValid=mAPGRHValid;
            maxSigma=RunObj.params.SIGMA;
            maxC=RunObj.params.C;
        end
        
        fprintf(fp, '%s\n', '******************');
        fprintf(fp, '%s\t%.5f\n', 'NITER', RunObj.params.NITER);
        fprintf(fp, '%s\t%.5f\n', 'C', RunObj.params.C);
        fprintf(fp, '%s\t%.5f\n', 'SIGMA', RunObj.params.SIGMA);
        fprintf(fp, '%s\t%.5f\n', 'mAP (Valid)', mAPGRHValid);
        fprintf(fp, '%s\n', '******************');
    end
end

disp(sprintf('%s\t%.5f\n', 'Best C', maxC))
disp(sprintf('%s\t%.5f\n', 'Best ALPHA', RunObj.params.ALPHA))
disp(sprintf('%s\t%.5f\n', 'Best NITER', RunObj.params.NITER))
disp(sprintf('%s\t%.5f\n', 'Best SIGMA', maxSigma))
disp(sprintf('%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid))

fprintf(fp, '%s\n', '******************');

fprintf(fp, '%s\t%.5f\n', 'Best C', maxC);
fprintf(fp, '%s\t%.5f\n', 'Best SIGMA', maxSigma);
fprintf(fp, '%s\t%.5f\n', 'Best ALPHA', RunObj.params.ALPHA);
fprintf(fp, '%s\t%.5f\n', 'Best NITER', RunObj.params.NITER);
fprintf(fp, '%s\t%.5f\n', 'Best mAP (Valid)', mAPMaxValid);

fprintf(fp, '%s\n', '******************');

RunObj.params.C=maxC;
RunObj.params.SIGMA=maxSigma;