function [RunObj, bits] = get_baseline(RunObj)

disp(sprintf ( 'Getting baseline \n') )

data=RunObj.data.data;
dataValid=RunObj.data.dataValid;
dataAffinity=RunObj.data.data(RunObj.data.affinityInd,:);

switch(RunObj.params.PROJ_TYPE)
    
    % ITQ method proposed in our CVPR11 paper
    case 'ITQ'
        
        [pc, ~] = eigs(cov(data(RunObj.data.affinityInd,:)),RunObj.params.NBITS);
        dataProj = data * pc;
        
        [~, R] = ITQ(dataProj(RunObj.data.affinityInd,:),100);
        
        dataProj = dataProj*R;
        dataValidProj = dataValid * pc;
        dataAffinityProj = dataAffinity * pc;
        
        bits = zeros(size(dataProj));
        bits(dataProj>0)=1;
    
    case 'ITQ_CCA'
        
        [pc, l] = cca(data(RunObj.data.affinityInd,:),full(RunObj.data.affinity),0.0001);
        pc = pc(:,1:RunObj.params.NBITS)*diag(l(1:RunObj.params.NBITS)); % this performs a scaling using eigenvalues
        dataProj = data * pc;
         
        [Y, R] = ITQ(dataProj(RunObj.data.affinityInd,:),100);
        dataProj = dataProj*R;
        
        dataValidProj = (dataValid * pc)* R;
        dataAffinityProj = (dataAffinity * pc) * R;
       
        bits = zeros(size(dataProj));
        bits(dataProj>0)=1;
        
    case 'PCA'
        
        [pc, l] = eigs(cov(data(RunObj.data.affinityInd,:)),RunObj.params.NBITS);

        dataProj=data * pc;
        dataValidProj = dataValid * pc;
        dataAffinityProj = dataAffinity * pc;
   
        bits = zeros(size(dataProj));
        bits(dataProj>0)=1;
    
    % SKLSH
    % M. Raginsky, S. Lazebnik. Locality Sensitive Binary Codes from
    % Shift-Invariant Kernels. NIPS 2009.
    case 'SKLSH'
        
        RFparam.gamma = 1;
        RFparam.D = size(data,2);
        RFparam.M = RunObj.params.NBITS;
        RFparam = RF_train(RFparam);
        
        [~,dataProj] = RF_compress(data, RFparam);
        [~,dataValidProj] = RF_compress(dataValid, RFparam);
        [~,dataAffinityProj] = RF_compress(dataAffinity, RFparam);
        
        bits = zeros(size(dataProj));
        bits(dataProj>0)=1;
        
    % Locality sensitive hashing (LSH)
    case 'LSH'
        
        dataProj = data * randn(size(data,2),RunObj.params.NBITS);
        bits = zeros(size(dataProj));
        bits(dataProj>0)=1;
        
        dataValidProj = dataValid * randn(size(dataValid,2),RunObj.params.NBITS);
        dataAffinityProj = dataAffinity * randn(size(dataAffinity,2),RunObj.params.NBITS);

    case 'SH'
        
        SHparam.nbits = RunObj.params.NBITS; % number of bits to code each sample
        SHparam = trainSH(data(RunObj.data.affinityInd,:), SHparam);
        [~,dataProj] = compressSH(data, SHparam);
        
        dataValidProj = compressSH(dataValid, SHparam);
        dataAffinityProj = compressSH(dataAffinity, SHparam); 

        bits=zeros(size(dataProj));
        bits(dataProj>0)=1;
        
    case 'LSI'

        [U1,S,V] = svds(data(RunObj.data.affinityInd,:),RunObj.params.NBITS);
        invS = pinv(S);

        dataProj = data * V * invS;
        dataValidProj = dataValid * V * invS;
        dataAffinityProj = dataAffinity * V * invS;
     
        bits=zeros(size(dataProj));
        bits(data_proj>0)=1;
        
end

RunObj.data.dataProj = dataProj;
RunObj.data.dataValidProj=dataValidProj;
RunObj.data.dataAffinityProj=dataAffinityProj;