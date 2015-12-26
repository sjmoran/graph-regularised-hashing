function RunObj = clear_results(RunObj)

RunObj.results.auprcSBQs=[];
RunObj.results.auprcGRHs=[];
RunObj.results.auprcKSHs=[];
RunObj.results.auprcBREs=[];
RunObj.results.auprcSTHs=[];
RunObj.results.auprcAGHs=[];
RunObj.results.auprcISOGFs=[];
RunObj.results.auprcLSHs=[];
RunObj.results.auprcSKLSHs=[];

RunObj.results.f1BucketGRHs=[];
RunObj.results.f1BucketSBQs=[];
RunObj.results.f1BucketSTHs=[];
RunObj.results.f1BucketBREs=[];
RunObj.results.f1BucketKSHs=[];
RunObj.results.f1BucketAGHs=[];
RunObj.results.f1BucketLSHs=[];
RunObj.results.f1BucketSKLSHs=[];
RunObj.results.f1BucketISOGFs=[];

RunObj.results.mAPGRHs=[];
RunObj.results.mAPSBQs=[];
RunObj.results.mAPSTHs=[];
RunObj.results.mAPBREs=[];
RunObj.results.mAPKSHs=[];
RunObj.results.mAPAGHs=[];
RunObj.results.mAPISOGFs=[];
RunObj.results.mAPSKLSHs=[];
RunObj.results.mAPLSHs=[];

RunObj.results.auprcSBQ=0;
RunObj.results.auprcGRH=0;
RunObj.results.auprcSTH=0;
RunObj.results.auprcKSH=0;
RunObj.results.auprcBRE=0;
RunObj.results.auprcAGH=0;
RunObj.results.auprcLSH=0;
RunObj.results.auprcSKLSH=0;
RunObj.results.auprcISOGF=0;

RunObj.results.mAPGRH=0;
RunObj.results.mAPSBQ=0;
RunObj.results.mAPKSH=0;
RunObj.results.mAPBRE=0;
RunObj.results.mAPSTH=0;
RunObj.results.mAPAGH=0;
RunObj.results.mAPLSH=0;
RunObj.results.mAPSKLSH=0;
RunObj.results.mAPISOGF=0;

RunObj.results.auprcSBQAvg=0;
RunObj.results.auprcGRHAvg=0;
RunObj.results.auprcBREAvg=0;
RunObj.results.auprcSTHAvg=0;
RunObj.results.auprcKSHAvg=0;
RunObj.results.auprcAGHAvg=0;
RunObj.results.auprcLSHAvg=0;
RunObj.results.auprcSKLSHAvg=0;
RunObj.results.auprcISOGFAvg=0;

RunObj.results.mAPSBQAvg=0;
RunObj.results.mAPGRHAvg=0;
RunObj.results.mAPBREAvg=0;
RunObj.results.mAPKSHAvg=0;
RunObj.results.mAPSTHAvg=0;
RunObj.results.mAPAGHAvg=0;
RunObj.results.mAPLSHAvg=0;
RunObj.results.mAPSKLSHAvg=0;
RunObj.results.mAPISOGFAvg=0;

RunObj.results.pAtR2GRHs=[];
RunObj.results.pAtR2SBQs=[];
RunObj.results.pAtR2KSHs=[];
RunObj.results.pAtR2BREs=[];
RunObj.results.pAtR2STHs=[];
RunObj.results.pAtR2AGHs=[];
RunObj.results.pAtR2LSHs=[];
RunObj.results.pAtR2ISOGFs=[];
RunObj.results.pAtR2SKLSHs=[];

RunObj.results.pAtR2GRH=0;
RunObj.results.pAtR2SBQ=0;
RunObj.results.pAtR2KSH=0;
RunObj.results.pAtR2BRE=0;
RunObj.results.pAtR2STH=0;
RunObj.results.pAtR2AGH=0;
RunObj.results.pAtR2LSH=0;
RunObj.results.pAtR2SKLSH=0;
RunObj.results.pAtR2ISOGF=0;

RunObj.results.pAtR2GRHAvg=0;
RunObj.results.pAtR2SBQAvg=0;
RunObj.results.pAtR2STHAvg=0;
RunObj.results.pAtR2BREAvg=0;
RunObj.results.pAtR2KSHAvg=0;
RunObj.results.pAtR2AGHAvg=0;
RunObj.results.pAtR2LSHAvg=0;
RunObj.results.pAtR2ISOGFAvg=0;
RunObj.results.pAtR2SKLSHAvg=0;

RunObj.results.rISOGFAvg=zeros(1000,1);
RunObj.results.pISOGFAvg=zeros(1000,1);
RunObj.results.rISOGFAvgDiv=zeros(1000,1);
RunObj.results.pISOGFAvgDiv=zeros(1000,1);

RunObj.results.rSKLSHAvg=zeros(1000,1);
RunObj.results.pSKLSHAvg=zeros(1000,1);
RunObj.results.rSKLSHAvgDiv=zeros(1000,1);
RunObj.results.pSKLSHAvgDiv=zeros(1000,1);

RunObj.results.rGRHAvg=zeros(1000,1);
RunObj.results.pGRHAvg=zeros(1000,1);
RunObj.results.rGRHAvgDiv=zeros(1000,1);
RunObj.results.pGRHAvgDiv=zeros(1000,1);

RunObj.results.rLSHAvg=zeros(1000,1);
RunObj.results.pLSHAvg=zeros(1000,1);
RunObj.results.rLSHAvgDiv=zeros(1000,1);
RunObj.results.pLSHAvgDiv=zeros(1000,1);

RunObj.results.rGRHAvg=zeros(1000,1);
RunObj.results.pGRHAvg=zeros(1000,1);
RunObj.results.rGRHAvgDiv=zeros(1000,1);
RunObj.results.pGRHAvgDiv=zeros(1000,1);

RunObj.results.rAGHAvg=zeros(1000,1);
RunObj.results.pAGHAvg=zeros(1000,1);
RunObj.results.rAGHAvgDiv=zeros(1000,1);
RunObj.results.pAGHAvgDiv=zeros(1000,1);

RunObj.results.rSBQAvg=zeros(1000,1);
RunObj.results.pSBQAvg=zeros(1000,1);
RunObj.results.rSBQAvgDiv=zeros(1000,1);
RunObj.results.pSBQAvgDiv=zeros(1000,1);

RunObj.results.rKSHAvg=zeros(1000,1);
RunObj.results.pKSHAvg=zeros(1000,1);
RunObj.results.rKSHAvgDiv=zeros(1000,1);
RunObj.results.pKSHAvgDiv=zeros(1000,1);

RunObj.results.rSTHAvg=zeros(1000,1);
RunObj.results.pSTHAvg=zeros(1000,1);
RunObj.results.rSTHAvgDiv=zeros(1000,1);
RunObj.results.pSTHAvgDiv=zeros(1000,1);

RunObj.results.rBREAvg=zeros(1000,1);
RunObj.results.pBREAvg=zeros(1000,1);
RunObj.results.rBREAvgDiv=zeros(1000,1);
RunObj.results.pBREAvgDiv=zeros(1000,1);

RunObj.results.precisionBucketISOGFAvg=0;
RunObj.results.recallBucketISOGFAvg=0;
RunObj.results.f1BucketISOGFAvg=0;

RunObj.results.precisionBucketLSHAvg=0;
RunObj.results.recallBucketLSHAvg=0;
RunObj.results.f1BucketLSHAvg=0;

RunObj.results.precisionBucketSKLSHAvg=0;
RunObj.results.recallBucketSKLSHAvg=0;
RunObj.results.f1BucketSKLSHAvg=0;

RunObj.results.precisionBucketSBQAvg=0;
RunObj.results.recallBucketSBQAvg=0;
RunObj.results.f1BucketSBQAvg=0;

RunObj.results.precisionBucketSTHAvg=0;
RunObj.results.recallBucketSTHAvg=0;
RunObj.results.f1BucketSTHAvg=0;

RunObj.results.precisionBucketGRHAvg=0;
RunObj.results.recallBucketGRHAvg=0;
RunObj.results.f1BucketGRHAvg=0;

RunObj.results.precisionBucketKSHAvg=0;
RunObj.results.recallBucketKSHAvg=0;
RunObj.results.f1BucketKSHAvg=0;

RunObj.results.precisionBucketBREAvg=0;
RunObj.results.recallBucketBREAvg=0;
RunObj.results.f1BucketBREAvg=0;

RunObj.results.precisionBucketAGHAvg=0;
RunObj.results.recallBucketAGHAvg=0;
RunObj.results.f1BucketAGHAvg=0;