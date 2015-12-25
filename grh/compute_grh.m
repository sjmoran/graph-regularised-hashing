function RunObj = compute_grh(RunObj, bitsSBQ, nRun, fp)

disp(sprintf ( 'Running GRH \n') )

[RunObj,pAtR2GRH, mAPGRH]=run_grh(RunObj, bitsSBQ, nRun, fp);

disp(sprintf('%s\t%f\n','mAPGRH: ',mAPGRH))
disp(sprintf('%s\t%f\n','pAtR2GRH: ',full(pAtR2GRH)))

RunObj.results.mAPGRHAvg=RunObj.results.mAPGRHAvg+mAPGRH;
RunObj.results.mAPGRHs=[RunObj.results.mAPGRHs;mAPGRH];

RunObj.results.pAtR2GRHAvg=RunObj.results.pAtR2GRHAvg+pAtR2GRH;
RunObj.results.pAtR2GRHs=[RunObj.results.pAtR2GRHs;pAtR2GRH];