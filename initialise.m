function RunObj = initialise()

disp(sprintf ( 'Initalising \n') )

%%%%%%%%%%%%%%%%
NAFFINITY_ARRAY=[1000];
NAFFINITY=1000;       % Number of pairs to use for training
IS_DATABASE=0;        % 1=Use train/test/database split
DATA_NAME='CIFAR';  % Dataset name
NBITS_ARRAY=[16];              % Number of bits
NBITS=64;
PROJ_TYPE='LSH';

if (ispc)
    RES_DIR_ROOT='C:\Users\Sean\Documents\results\';
    DATA_ROOT_DIR='C:\Users\Sean\Documents\data\unimodal\';
else
    RES_DIR_ROOT='/Users/seanmoran/Desktop/sigir2015/';
    DATA_ROOT_DIR='/Users/seanmoran/Documents/Work/PhD/code/data/unimodal/';
end

NRUNS=10;
NTEST=1000;         % Test queries
NVALIDTEST=1000;    % Validation queries
NVALIDTRAIN=10000;   % Training set for the validation queries. 
NITER=1;
ALPHA=1;
C=1;
KERNEL=2;  % 1=Linear, 2=RBF, 3=Landmark RBF
SIGMA=1;
NCHUNK=4;
NLANDMARKS=300;
L2NORM=0;

%%%%%%%%%%%%%%%
mAPGRHs=[];
mAPSBQs=[];
mAPLSHs=[];

mAPGRH=0;
mAPSBQ=0;
mAPLSH=0;

mAPSBQAvg=0;
mAPGRHAvg=0;
mAPLSHAvg=0;

pAtR2GRHs=[];
pAtR2SBQs=[];
pAtR2LSHs=[];

pAtR2GRH=0;
pAtR2SBQ=0;
pAtR2LSH=0;

pAtR2GRHAvg=0;
pAtR2SBQAvg=0;

RunObj=struct(...
     'data', ...
     struct('affinityClaas',[],'dataProjAffinity', [],'dataParFor', {{}},'dataValidParFor', {{}}, 'affinityInd',[],'data',[],'affinity',[], ...
     'testInd',[],'trainInd',[],'validInd',[],'dataProj',[], 'dataValidProj',[]), ...
     'results',struct('pAtR2GRHAvg', pAtR2GRHAvg, 'pAtR2GRHs', ...
      pAtR2GRHs, 'pAtR2SBQAvg', pAtR2SBQAvg, 'pAtR2SBQs', pAtR2SBQs, 'pAtR2LSHs', pAtR2LSHs,  ...
     'pAtR2LSH',pAtR2LSH, ...
     'pAtR2SBQ',pAtR2SBQ, 'pAtR2GRH', pAtR2GRH, 'mAPGRHs', mAPGRHs,...
     'mAPLSHs', mAPLSHs, 'mAPLSH', mAPLSH,...
     'mAPSBQs', mAPSBQs, 'mAPGRH', mAPGRH, 'mAPSBQ', mAPSBQ, 'mAPSBQAvg', ...
      mAPSBQAvg, 'mAPGRHAvg', mAPGRHAvg, 'mAPLSHAvg', mAPLSHAvg), ...
     'params',struct('L2NORM',L2NORM,'NLANDMARKS',NLANDMARKS,'NCHUNK',NCHUNK,'SIGMA',SIGMA,'ALPHA',ALPHA,'C',C,'NITER',NITER, ...
     'KERNEL',KERNEL,'modelsToRun',[], ...
     'NAFFINITY_ARRAY',NAFFINITY_ARRAY,'NBITS_ARRAY', ...
     NBITS_ARRAY,'DATA_ROOT_DIR',DATA_ROOT_DIR,...
     'RES_DIR_FP','','NVALIDTEST',NVALIDTEST,'NVALIDTRAIN',NVALIDTRAIN, 'NTEST',NTEST, 'IS_DATABASE', ...
     IS_DATABASE,'NRUNS',NRUNS,'NBITS',...
     NBITS,'PROJ_TYPE',PROJ_TYPE,'RES_DIR_ROOT',RES_DIR_ROOT, ...
     'DATA_NAME',DATA_NAME,...
     'NAFFINITY',NAFFINITY));
 
%%%%%%%%%%%%%%%
disp(['******************']);
disp(['Parameters are:';]);
disp(['******************']);
disp(['NAFFINITY: ', int2str(NAFFINITY)])
disp(['NBITS: ', int2str(NBITS_ARRAY)]);
disp(['PROJ_TYPE: ', PROJ_TYPE]);
disp(['NTEST: ', int2str(NTEST)]);
disp(['NVALIDTEST: ', int2str(NVALIDTEST)]);
disp(['NVALIDTRAIN: ', int2str(NVALIDTRAIN)]);
disp(['NRUNS: ', int2str(NRUNS)]);
disp(['IS_DATABASE: ', int2str(IS_DATABASE)]);
disp(['NITER: ', int2str(NITER)]);
disp(['KERNEL: ', int2str(KERNEL)]);
disp(['C: ', int2str(C)]);
disp(['SIGMA: ', int2str(SIGMA)]);
disp(['NRUNS: ', int2str(NRUNS)]);
disp(['ALPHA: ', int2str(ALPHA)]);
disp(['NCHUNK: ', int2str(NCHUNK)]);
disp(['NLANDMARKS: ', int2str(NLANDMARKS)]);
disp(['L2NORM: ', int2str(L2NORM)]);
disp(['******************']);

disp(sprintf ( '\n') )
%%%%%%%%%%%%%%%%

    
