function [RunObj,pAtR2GRH,mAPGRH] = run_grh(RunObj, bitsSBQ, nRun, fp)

affinity=norm_affinity(RunObj);
bitsSBQ(bitsSBQ<=0)=-1;

if (nRun==1)
    
   if (RunObj.params.KERNEL==2 || RunObj.params.KERNEL==3)     % RBF - initial estimate of SIGMA
       [RunObj]=run_rbf_kernel_cval_sigma(RunObj, affinity, bitsSBQ, fp);
   end
    
   RunObj=get_best_alpha(RunObj, affinity, bitsSBQ, fp);
    
    if (RunObj.params.KERNEL==2 || RunObj.params.KERNEL==3)     % RBF - find best SIGMA
        
        [RunObj]=run_rbf_kernel_cval(RunObj, affinity, bitsSBQ, fp);
        
    else
        
        [RunObj]=run_linear_kernel_cval(RunObj, affinity, bitsSBQ, fp);
    end
end

[RunObj,pAtR2GRH,mAPGRH]=run_grh_test(RunObj, affinity, bitsSBQ, fp);
