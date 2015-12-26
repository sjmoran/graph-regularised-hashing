function RunObj = compute_sbq(RunObj, bitsSBQ)

disp(sprintf ( 'Running SBQ \n') )

bitsSBQ(bitsSBQ>0)=1;
bitsSBQ(bitsSBQ<=0)=0;

[RunObj,pAtR2SBQ,mAPSBQ]=eval_bits(RunObj, bitsSBQ, 0);

disp(sprintf('%s\t%f\n','mAPSBQ: ',mAPSBQ))
disp(sprintf('%s\t%f\n','pAtR2SBQ: ',full(pAtR2SBQ)))

RunObj.results.mAPSBQAvg=RunObj.results.mAPSBQAvg+mAPSBQ;
RunObj.results.mAPSBQs=[RunObj.results.mAPSBQs;mAPSBQ];

RunObj.results.pAtR2SBQAvg=RunObj.results.pAtR2SBQAvg+pAtR2SBQ;
RunObj.results.pAtR2SBQs=[RunObj.results.pAtR2SBQs;pAtR2SBQ];