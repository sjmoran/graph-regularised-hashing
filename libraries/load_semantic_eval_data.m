function RunObj=load_semantic_eval_data(RunObj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T % V  % A  % ValidTrain% Database  %
% e % a  % f  %           %           %
% s % l  % f  %           %           %
% t % i  % i  %           %           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% T % V  % A  %    ValidTrain         %
% e % a  % f  %                       %
% s % l  % f  %                       %
% t % i  % i  %                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   %                                 %
%   %           Train                 %
%   %                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (strcmp(RunObj.params.DATA_NAME,'CIFAR'))
    
    NCLASSES=10;
    
    data=load([RunObj.params.DATA_ROOT_DIR,'Gist512CIFAR10.mat']);
    dataFea=data.X;
    
    % Create an affinity matrix for the entire dataset
    dataClass=data.X_class;
    
    dataClassTemp=double(dataClass);
    testDataPointsInd=[];
    for i=1:NCLASSES
        testDataPointsIndTemp=find(dataClassTemp(1,:)==i-1);
        testDataPointsIndTemp=testDataPointsIndTemp(:,randperm(size(testDataPointsIndTemp,2)));
        testDataPointsIndTemp=testDataPointsIndTemp(:,1:RunObj.params.NTEST/NCLASSES);
        dataClassTemp(:,testDataPointsIndTemp)=Inf;
        testDataPointsInd=[testDataPointsInd,testDataPointsIndTemp];
    end
    
    testDataPointsInd=testDataPointsInd(:,randperm(size(testDataPointsInd,2)));
    
    % Create training dataset
    trainDataPointsInd=find(dataClassTemp(1,:)~=Inf);
    trainDataPointsInd=trainDataPointsInd(:,randperm(size(trainDataPointsInd,2)));
    
    % Sample validation dataset test data points
    validDataPointsInd=[];
    for i=1:NCLASSES
        validDataPointsIndTemp=find(dataClassTemp(1,:)==i-1);
        validDataPointsIndTemp=validDataPointsIndTemp(:,randperm(size(validDataPointsIndTemp,2)));
        validDataPointsIndTemp=validDataPointsIndTemp(:,1:RunObj.params.NVALIDTEST/NCLASSES);
        dataClassTemp(:,validDataPointsIndTemp)=Inf;
        validDataPointsInd=[validDataPointsInd,validDataPointsIndTemp];
    end
    
    validDataPointsInd=validDataPointsInd(:,randperm(size(validDataPointsInd,2)));
    dataClassTemp(:,validDataPointsInd)=Inf;
    
    affinityDataPointsInd=[];
    for i=1:NCLASSES
        affinityDataPointsIndTemp=find(dataClassTemp(1,:)==i-1);
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,find(affinityDataPointsIndTemp~=Inf));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,randperm(size(affinityDataPointsIndTemp,2)));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,1:RunObj.params.NAFFINITY/NCLASSES);
        dataClassTemp(:,affinityDataPointsIndTemp)=Inf;
        affinityDataPointsInd=[affinityDataPointsInd,affinityDataPointsIndTemp];
    end
    
    % Sample validation dataset training data points
    validTrainDataPointsInd=find(dataClassTemp(1,:)~=Inf);
    validTrainDataPointsInd=validTrainDataPointsInd(:,randperm(size(validTrainDataPointsInd,2)));
    validTrainDataPointsInd=validTrainDataPointsInd(:,1:RunObj.params.NVALIDTRAIN);
    dataClassTemp(:,validTrainDataPointsInd)=Inf;
    
    % Database which we evaluate the test queries (if IS_DATABASE is true)
    databaseInd=find(dataClassTemp(1,:)~=Inf);
    RunObj.params.NDATABASE=size(databaseInd,2);
    dataClassTemp(:,databaseInd)=Inf;
    
    RunObj.data.data=dataFea;
    RunObj.data.dataClass=dataClass;
    
    if (RunObj.params.IS_DATABASE==0)
        testData=dataClass(:,testDataPointsInd);
        testDataMat=[];
        for i=1:size(testData,2)
            testDataMat(i,testData(:,i)+1)=1;
        end
        testTrainData=dataClass(:,trainDataPointsInd);
        testTrainDataMat=[];
        for i=1:size(testTrainData,2)
            testTrainDataMat(i,testTrainData(:,i)+1)=1;
        end
        testAffinity=(testDataMat*testTrainDataMat')>0;
    else
        testData=dataClass(:,testDataPointsInd);
        testDataMat=[];
        for i=1:size(testData,2)
            testDataMat(i,testData(:,i)+1)=1;
        end
        testTrainData=dataClass(:,databaseInd);
        testTrainDataMat=[];
        for i=1:size(testTrainData,2)
            testTrainDataMat(i,testTrainData(:,i)+1)=1;
        end
        testAffinity=(testDataMat*testTrainDataMat')>0;
    end
    
    validData=dataClass(:,validDataPointsInd);
    validDataMat=[];
    for i=1:size(validData,2)
        validDataMat(i,validData(:,i)+1)=1;
    end
    validTrainData=dataClass(:,validTrainDataPointsInd);
    validTrainDataMat=[];
    for i=1:size(validTrainData,2)
        validTrainDataMat(i,validTrainData(:,i)+1)=1;
    end
    validAffinity=(validDataMat*validTrainDataMat')>0;
    
    RunObj.data.validGroundTruth = validAffinity;
    RunObj.data.testGroundTruth = testAffinity;
    
    clear testAffinity;
    clear validAffinity;
    
    RunObj.data.trainInd=trainDataPointsInd;
    RunObj.data.affinityInd=affinityDataPointsInd;
    RunObj.data.testInd=testDataPointsInd;
    RunObj.data.databaseInd=databaseInd;
    
    affinityData=dataClass(:,affinityDataPointsInd);
    affinityDataMat=[];
    for i=1:size(affinityData,2)
        affinityDataMat(i,affinityData(:,i)+1)=1;
    end
    affinity=(affinityDataMat*affinityDataMat')>0;
    
    RunObj.data.affinity=affinity;
    
    shuffleInd=randperm(size(RunObj.data.affinity,1));
    RunObj.data.affinityClass=dataClass(:,affinityDataPointsInd);
    RunObj.data.affinity=RunObj.data.affinity(shuffleInd,shuffleInd);
    RunObj.data.affinityInd= RunObj.data.affinityInd(:,shuffleInd);
    RunObj.data.validInd=validDataPointsInd;
    RunObj.data.validTrainInd=validTrainDataPointsInd;
    
elseif(strcmp(RunObj.params.DATA_NAME,'NUSWIDE'))
    
    NCLASSES=21;
    
    data=load([RunObj.params.DATA_ROOT_DIR,'/nus_data.mat',]);
    dataFea=double(data.dataFea);
    
    dataClass=load([RunObj.params.DATA_ROOT_DIR,'/nus_gt.mat']);
    dataClass=dataClass.dataClass;
    
    [classFreq,classFreqInd]=sort(sum(dataClass,1),2,'descend');
    dataClass=dataClass(:,classFreqInd(:,1:NCLASSES));
    imToKeepInd=sum(dataClass,2)>0;
    dataClass=dataClass(imToKeepInd,:);
    dataFea=dataFea(imToKeepInd,:);
    
    dataClassTemp=dataClass;
    testDataPointsInd=[];
    for i=1:NCLASSES
        testDataPointsIndTemp=find(dataClassTemp(:,i)==1)';
        testDataPointsIndTemp=testDataPointsIndTemp(:,randperm(size(testDataPointsIndTemp,2)));
        testDataPointsIndTemp=testDataPointsIndTemp(:,1:RunObj.params.NTEST/NCLASSES);
        dataClassTemp(testDataPointsIndTemp,:)=Inf;
        testDataPointsInd=[testDataPointsInd,testDataPointsIndTemp];
    end
    
    testDataPointsInd=testDataPointsInd(:,randperm(size(testDataPointsInd,2)));
    dataClassTemp(testDataPointsInd,:)=Inf;
    
    % Create training dataset
    trainDataPointsInd=find(dataClassTemp(:,1)~=Inf)';
    trainDataPointsInd=trainDataPointsInd(:,randperm(size(trainDataPointsInd,2)));
    
    % Sample validation dataset test data points
    validDataPointsInd=[];
    for i=1:NCLASSES
        validDataPointsIndTemp=find(dataClassTemp(:,i)==1)';
        validDataPointsIndTemp=validDataPointsIndTemp(:,randperm(size(validDataPointsIndTemp,2)));
        validDataPointsIndTemp=validDataPointsIndTemp(:,1:RunObj.params.NVALIDTEST/NCLASSES);
        dataClassTemp(validDataPointsIndTemp,:)=Inf;
        validDataPointsInd=[validDataPointsInd,validDataPointsIndTemp];
    end
    
    validDataPointsInd=validDataPointsInd(:,randperm(size(validDataPointsInd,2)));
    dataClassTemp(validDataPointsInd,:)=Inf;
    
    affinityDataPointsInd=[];
    for i=1:NCLASSES
        affinityDataPointsIndTemp=find(dataClassTemp(:,i)==1)';
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,find(affinityDataPointsIndTemp~=Inf));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,randperm(size(affinityDataPointsIndTemp,2)));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,1:RunObj.params.NAFFINITY/NCLASSES);
        dataClassTemp(affinityDataPointsIndTemp,:)=Inf;
        affinityDataPointsInd=[affinityDataPointsInd,affinityDataPointsIndTemp];
    end
    
    % Sample validation dataset training data points
    validTrainDataPointsInd=find(dataClassTemp(:,1)~=Inf)';
    validTrainDataPointsInd=validTrainDataPointsInd(:,randperm(size(validTrainDataPointsInd,2)));
    validTrainDataPointsInd=validTrainDataPointsInd(:,1:RunObj.params.NVALIDTRAIN);
    dataClassTemp(validTrainDataPointsInd,:)=Inf;
    
    % Database which we evaluate the test queries (if IS_DATABASE is true)
    databaseInd=find(dataClassTemp(:,1)~=Inf)';
    dataClassTemp(databaseInd,:)=Inf;
    
    RunObj.data.data=dataFea;
    RunObj.data.dataClass=dataClass;
    
    testData=dataClass(testDataPointsInd,:);
    testTrainData=dataClass(trainDataPointsInd,:);
    testDatabaseData=dataClass(databaseInd,:);
    
    if (RunObj.params.IS_DATABASE==1)
        testAffinity=(testData*testDatabaseData')>0;
    else
        testAffinity=(testData*testTrainData')>0;
    end
    
    validData=dataClass(validDataPointsInd,:);
    validTrainData=dataClass(validTrainDataPointsInd,:);
    validAffinity=(validData*validTrainData')>0;
    
    RunObj.data.validGroundTruth = validAffinity;
    RunObj.data.testGroundTruth = testAffinity;
    
    clear testAffinity;
    clear validAffinity;
    
    RunObj.data.trainInd=trainDataPointsInd;
    RunObj.data.affinityInd=affinityDataPointsInd;
    RunObj.data.testInd=testDataPointsInd;
    RunObj.data.databaseInd=databaseInd;
    
    affinityData=dataClass(affinityDataPointsInd,:);
    affinity=(affinityData*affinityData')>0;
    
    RunObj.data.affinity=affinity;
    
    shuffleInd=randperm(size(RunObj.data.affinity,1));
    RunObj.data.affinity=RunObj.data.affinity(shuffleInd,shuffleInd);
    RunObj.data.affinityInd= RunObj.data.affinityInd(:,shuffleInd);
    RunObj.data.validInd=validDataPointsInd;
    RunObj.data.validTrainInd=validTrainDataPointsInd;
    
elseif(strcmp(RunObj.params.DATA_NAME,'MNIST'))
    
    NCLASSES=10;
    
    dataFea=load([RunObj.params.DATA_ROOT_DIR,'/MNIST_gnd_release.mat',]);
    trainData=dataFea.MNIST_trndata;
    testData=dataFea.MNIST_tstdata;
    dataFeaTmp=[trainData;testData];
    trainLabel=dataFea.MNIST_trnlabel;
    testLabel=dataFea.MNIST_tstlabel;
    dataClass=[trainLabel,testLabel];
    RunObj.data.dataClass=dataClass;
    dataFea=dataFeaTmp;
    
    dataClassTemp=double(dataClass);
    testDataPointsInd=[];
    for i=1:NCLASSES
        testDataPointsIndTemp=find(dataClassTemp(1,:)==i-1);
        testDataPointsIndTemp=testDataPointsIndTemp(:,randperm(size(testDataPointsIndTemp,2)));
        testDataPointsIndTemp=testDataPointsIndTemp(:,1:RunObj.params.NTEST/NCLASSES);
        dataClassTemp(:,testDataPointsIndTemp)=Inf;
        testDataPointsInd=[testDataPointsInd,testDataPointsIndTemp];
    end
    
    testDataPointsInd=testDataPointsInd(:,randperm(size(testDataPointsInd,2)));
    
    % Create training dataset
    trainDataPointsInd=find(dataClassTemp(1,:)~=Inf);
    trainDataPointsInd=trainDataPointsInd(:,randperm(size(trainDataPointsInd,2)));
    
    % Sample validation dataset test data points
    validDataPointsInd=[];
    for i=1:NCLASSES
        validDataPointsIndTemp=find(dataClassTemp(1,:)==i-1);
        validDataPointsIndTemp=validDataPointsIndTemp(:,randperm(size(validDataPointsIndTemp,2)));
        validDataPointsIndTemp=validDataPointsIndTemp(:,1:RunObj.params.NVALIDTEST/NCLASSES);
        dataClassTemp(:,validDataPointsIndTemp)=Inf;
        validDataPointsInd=[validDataPointsInd,validDataPointsIndTemp];
    end
    
    validDataPointsInd=validDataPointsInd(:,randperm(size(validDataPointsInd,2)));
    dataClassTemp(:,validDataPointsInd)=Inf;
    
    affinityDataPointsInd=[];
    for i=1:NCLASSES
        affinityDataPointsIndTemp=find(dataClassTemp(1,:)==i-1);
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,find(affinityDataPointsIndTemp~=Inf));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,randperm(size(affinityDataPointsIndTemp,2)));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,1:RunObj.params.NAFFINITY/NCLASSES);
        dataClassTemp(:,affinityDataPointsIndTemp)=Inf;
        affinityDataPointsInd=[affinityDataPointsInd,affinityDataPointsIndTemp];
    end
    
    % Sample validation dataset training data points
    validTrainDataPointsInd=find(dataClassTemp(1,:)~=Inf);
    validTrainDataPointsInd=validTrainDataPointsInd(:,randperm(size(validTrainDataPointsInd,2)));
    validTrainDataPointsInd=validTrainDataPointsInd(:,1:RunObj.params.NVALIDTRAIN);
    dataClassTemp(:,validTrainDataPointsInd)=Inf;
    
    % Database which we evaluate the test queries (if IS_DATABASE is true)
    databaseInd=find(dataClassTemp(1,:)~=Inf);
    RunObj.params.NDATABASE=size(databaseInd,2);
    dataClassTemp(:,databaseInd)=Inf;
    
    RunObj.data.data=dataFea;
    RunObj.data.dataClass=dataClass;
    
    if (RunObj.params.IS_DATABASE==0)
        testData=dataClass(:,testDataPointsInd);
        testDataMat=[];
        for i=1:size(testData,2)
            testDataMat(i,testData(:,i)+1)=1;
        end
        testTrainData=dataClass(:,trainDataPointsInd);
        testTrainDataMat=[];
        for i=1:size(testTrainData,2)
            testTrainDataMat(i,testTrainData(:,i)+1)=1;
        end
        testAffinity=(testDataMat*testTrainDataMat')>0;
    else
        testData=dataClass(:,testDataPointsInd);
        testDataMat=[];
        for i=1:size(testData,2)
            testDataMat(i,testData(:,i)+1)=1;
        end
        testTrainData=dataClass(:,databaseInd);
        testTrainDataMat=[];
        for i=1:size(testTrainData,2)
            testTrainDataMat(i,testTrainData(:,i)+1)=1;
        end
        testAffinity=(testDataMat*testTrainDataMat')>0;
    end
    
    validData=dataClass(:,validDataPointsInd);
    validDataMat=[];
    for i=1:size(validData,2)
        validDataMat(i,validData(:,i)+1)=1;
    end
    validTrainData=dataClass(:,validTrainDataPointsInd);
    validTrainDataMat=[];
    for i=1:size(validTrainData,2)
        validTrainDataMat(i,validTrainData(:,i)+1)=1;
    end
    validAffinity=(validDataMat*validTrainDataMat')>0;
    
    RunObj.data.validGroundTruth = validAffinity;
    RunObj.data.testGroundTruth = testAffinity;
    
    clear testAffinity;
    clear validAffinity;
    
    RunObj.data.trainInd=trainDataPointsInd;
    RunObj.data.affinityInd=affinityDataPointsInd;
    RunObj.data.testInd=testDataPointsInd;
    RunObj.data.databaseInd=databaseInd;
    
    affinityData=dataClass(:,affinityDataPointsInd);
    affinityDataMat=[];
    for i=1:size(affinityData,2)
        affinityDataMat(i,affinityData(:,i)+1)=1;
    end
    affinity=(affinityDataMat*affinityDataMat')>0;
    
    RunObj.data.affinity=affinity;
    
    shuffleInd=randperm(size(RunObj.data.affinity,1));
    RunObj.data.affinity=RunObj.data.affinity(shuffleInd,shuffleInd);
    RunObj.data.affinityInd= RunObj.data.affinityInd(:,shuffleInd);
    RunObj.data.validInd=validDataPointsInd;
    RunObj.data.validTrainInd=validTrainDataPointsInd;
    
    
elseif(strcmp(RunObj.params.DATA_NAME,'IMAGENET'))
    
    NCLASSES=1000;
    
    dataFea=load([RunObj.params.DATA_ROOT_DIR,'/ILSVRC2012_caffe_CNN_sean_mean.mat',]);
    dataFea=dataFea.dataFea;
    dataClass=load([RunObj.params.DATA_ROOT_DIR,'/ILSVRC2012_caffe_CNN_class.mat',]);
    dataClass=dataClass.dataClass;
    
    dataClassTemp=double(dataClass);
    testDataPointsInd=[];
    for i=1:NCLASSES
        testDataPointsIndTemp=find(dataClassTemp(1,:)==i);
        testDataPointsIndTemp=testDataPointsIndTemp(:,randperm(size(testDataPointsIndTemp,2)));
        testDataPointsIndTemp=testDataPointsIndTemp(:,1:RunObj.params.NTEST/NCLASSES);
        dataClassTemp(:,testDataPointsIndTemp)=Inf;
        testDataPointsInd=[testDataPointsInd,testDataPointsIndTemp];
    end
    
    testDataPointsInd=testDataPointsInd(:,randperm(size(testDataPointsInd,2)));
    
    % Create training dataset
    trainDataPointsInd=find(dataClassTemp(1,:)~=Inf);
    trainDataPointsInd=trainDataPointsInd(:,randperm(size(trainDataPointsInd,2)));
    
    % Sample validation dataset test data points
    validDataPointsInd=[];
    for i=1:NCLASSES
        validDataPointsIndTemp=find(dataClassTemp(1,:)==i);
        validDataPointsIndTemp=validDataPointsIndTemp(:,randperm(size(validDataPointsIndTemp,2)));
        validDataPointsIndTemp=validDataPointsIndTemp(:,1:RunObj.params.NVALIDTEST/NCLASSES);
        dataClassTemp(:,validDataPointsIndTemp)=Inf;
        validDataPointsInd=[validDataPointsInd,validDataPointsIndTemp];
    end
    
    validDataPointsInd=validDataPointsInd(:,randperm(size(validDataPointsInd,2)));
    dataClassTemp(:,validDataPointsInd)=Inf;
    
    affinityDataPointsInd=[];
    for i=1:NCLASSES
        affinityDataPointsIndTemp=find(dataClassTemp(1,:)==i);
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,find(affinityDataPointsIndTemp~=Inf));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,randperm(size(affinityDataPointsIndTemp,2)));
        affinityDataPointsIndTemp=affinityDataPointsIndTemp(:,1:RunObj.params.NAFFINITY/NCLASSES);
        dataClassTemp(:,affinityDataPointsIndTemp)=Inf;
        affinityDataPointsInd=[affinityDataPointsInd,affinityDataPointsIndTemp];
    end
    
    % Sample validation dataset training data points
    validTrainDataPointsInd=find(dataClassTemp(1,:)~=Inf);
    validTrainDataPointsInd=validTrainDataPointsInd(:,randperm(size(validTrainDataPointsInd,2)));
    validTrainDataPointsInd=validTrainDataPointsInd(:,1:RunObj.params.NVALIDTRAIN);
    dataClassTemp(:,validTrainDataPointsInd)=Inf;
    
    % Database which we evaluate the test queries (if IS_DATABASE is true)
    databaseInd=find(dataClassTemp(1,:)~=Inf);
    RunObj.params.NDATABASE=size(databaseInd,2);
    dataClassTemp(:,databaseInd)=Inf;
    
    RunObj.data.data=dataFea;
    RunObj.data.dataClass=dataClass;
    
    if (RunObj.params.IS_DATABASE==0)
        testData=dataClass(:,testDataPointsInd);
        testTrainData=dataClass(:,trainDataPointsInd);
        testDataMat=sparse(1:size(testData,2),testData,1);
        testTrainDataMat=sparse(1:size(testTrainData,2),testTrainData,1);
        testAffinity=(testDataMat*testTrainDataMat')>0;
    else
        testData=dataClass(:,testDataPointsInd);
        testTrainData=dataClass(:,databaseInd);
        testDataMat=sparse(1:size(testData,2),testData,1);
        testTrainDataMat=sparse(1:size(testTrainData,2),testTrainData,1);
        testAffinity=(testDataMat*testTrainDataMat')>0;
    end
    
    validData=dataClass(:,validDataPointsInd);
    validTrainData=dataClass(:,validTrainDataPointsInd);
    validDataMat=sparse(1:size(validData,2),validData,1);
    validTrainDataMat=sparse(1:size(validTrainData,2),validTrainData,1);
    validAffinity=(validDataMat*validTrainDataMat')>0;
    
    RunObj.data.validGroundTruth = validAffinity;
    RunObj.data.testGroundTruth = testAffinity;
    
    clear testAffinity;
    clear validAffinity;
    
    RunObj.data.trainInd=trainDataPointsInd;
    RunObj.data.affinityInd=affinityDataPointsInd;
    RunObj.data.testInd=testDataPointsInd;
    RunObj.data.databaseInd=databaseInd;
    
    affinityData=dataClass(:,affinityDataPointsInd);
    affinityDataMat=sparse(1:size(affinityData,2),affinityData,1);
    affinity=(affinityDataMat*affinityDataMat')>0;
    
    RunObj.data.affinity=affinity;
    
    shuffleInd=randperm(size(RunObj.data.affinity,1));
    RunObj.data.affinity=RunObj.data.affinity(shuffleInd,shuffleInd);
    RunObj.data.affinityInd= RunObj.data.affinityInd(:,shuffleInd);
    RunObj.data.validInd=validDataPointsInd;
    RunObj.data.validTrainInd=validTrainDataPointsInd;
    
end


% Check if no overlap between test queries and affinity/training sets
for i=1:size(RunObj.data.testInd,2)
    ind=RunObj.data.testInd(:,i);
    assert(isempty(find(RunObj.data.trainInd==ind)));
    assert(isempty(find(RunObj.data.validTrainInd==ind)));
    assert(isempty(find(RunObj.data.validInd==ind)));
    assert(isempty(find(RunObj.data.affinityInd==ind)));
    assert(isempty(find(RunObj.data.databaseInd==ind)));
end

if (~strcmp(RunObj.params.DATA_NAME,'IMAGENET'))
    % Check no overlap between valid queries and validation/affinity sets
    for i=1:size(RunObj.data.validInd,2)
        ind=RunObj.data.validInd(:,i);
        assert(isempty(find(RunObj.data.validTrainInd==ind)));
        assert(isempty(find(RunObj.data.testInd==ind)));
        assert(isempty(find(RunObj.data.affinityInd==ind)));
        assert(isempty(find(RunObj.data.databaseInd==ind)));
    end
    
    if (RunObj.params.IS_DATABASE)
        % Check no overlap between valid queries and validation/affinity sets
        for i=1:size(RunObj.data.databaseInd,2)
            ind=RunObj.data.databaseInd(:,i);
            assert(isempty(find(RunObj.data.validTrainInd==ind)));
            assert(isempty(find(RunObj.data.testInd==ind)));
            assert(isempty(find(RunObj.data.affinityInd==ind)));
            assert(isempty(find(RunObj.data.validInd==ind)));
        end
    end
end

if (RunObj.params.IS_DATABASE==1)
    RunObj.params.NTRAIN=RunObj.params.NVALIDTEST+RunObj.params.NVALIDTRAIN;
    RunObj.params.NDATABASE=size(dataFea,1)-RunObj.params.NTEST-RunObj.params.NTRAIN;
else
    RunObj.params.NDATABASE=size(dataFea,1)-RunObj.params.NTEST;
    RunObj.params.NTRAIN=RunObj.params.NDATABASE;
end

RunObj.data.data=dataFea;