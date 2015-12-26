function RunObj = save_results(RunObj)

%%%%% LSH
RunObj.results.pAtR2LSHAvg=RunObj.results.pAtR2LSHAvg/RunObj.params.NRUNS;
RunObj.results.mAPLSHAvg=RunObj.results.mAPLSHAvg/RunObj.params.NRUNS;

disp(sprintf('%s\t%f\n','mAPLSHAvg: ',RunObj.results.mAPLSHAvg))

%%%%% GRH
RunObj.results.pAtR2GRHAvg=RunObj.results.pAtR2GRHAvg/RunObj.params.NRUNS;
RunObj.results.mAPGRHAvg=RunObj.results.mAPGRHAvg/RunObj.params.NRUNS;

disp(sprintf('%s\t%f\n','mAPGRHAvg: ',RunObj.results.mAPGRHAvg))

%%%%%%%%%%%%%%%%%%

resFileName = [RunObj.params.resDirFilePath,'results.txt'];
fp = fopen(resFileName, 'a');

fprintf(fp, '%s\n', '******************');

fprintf(fp, '%s\t%.5f\n', 'mAP (GRH)', RunObj.results.mAPGRHAvg);
fprintf(fp, '%s\t%.5f\n', 'mAP (LSH)', RunObj.results.mAPLSHAvg);

fprintf(fp, '%s\n', '******************');
fprintf(fp, '%s\t%.5f\n', 'PREC@2 (GRH)', RunObj.results.pAtR2GRHAvg);
fprintf(fp, '%s\t%.5f\n', 'PREC@2 (LSH)', RunObj.results.pAtR2LSHAvg);

fprintf(fp, '%s\n', '******************');

fclose(fp);

%%%%%%%%%%%%%%%%%%

resFileName = [RunObj.params.resDirFilePath,'stat_tests.txt'];
fp = fopen(resFileName, 'a');

fprintf(fp, '%s\n', '******************');

[h,p]=ttest(RunObj.results.mAPGRHs,RunObj.results.mAPLSHs,0.05);
fprintf(fp, '%s\t%.15f\t%.5f\n', 'mAP GRH vs LSH (ttest, 5%)', p, h);
[h,p]=ttest(RunObj.results.mAPGRHs,RunObj.results.mAPLSHs,0.01);
fprintf(fp, '%s\t%.15f\t%.5f\n', 'mAP GRH vs LSH (ttest, 1%)', p, h);
[p,h]=signtest(RunObj.results.mAPGRHs,RunObj.results.mAPLSHs, 'alpha',0.05);
fprintf(fp, '%s\t%.15f\t%.5f\n', 'mAP GRH vs LSH (signtest 5%)',p, h);
[p,h]=signtest(RunObj.results.mAPGRHs,RunObj.results.mAPLSHs, 'alpha',0.01);
fprintf(fp, '%s\t%.15f\t%.5f\n', 'mAP GRH vs LSH (signtest 1%)',p, h);
[p,h]=signrank(RunObj.results.mAPGRHs,RunObj.results.mAPLSHs, 'alpha', 0.05);
fprintf(fp, '%s\t%.15f\t%.5f\n', 'mAP GRH vs LSH (signrank, 5%)', p, h);
[p,h]=signrank(RunObj.results.mAPGRHs,RunObj.results.mAPLSHs, 'alpha', 0.01);
fprintf(fp, '%s\t%.15f\t%.5f\n', 'mAP GRH vs LSH (signrank 1%)', p, h);

fprintf(fp, '%s\n', '******************');
fclose(fp);


%%%%%%%%%%%%%%%%%%

paramsFileName = [RunObj.params.resDirFilePath,'params.txt'];
fp = fopen(paramsFileName, 'a');

fprintf(fp, '%s\t%.5f\n', 'SIGMA', RunObj.params.SIGMA);
fprintf(fp, '%s\t%.5f\n', 'ALPHA', RunObj.params.ALPHA);
fprintf(fp, '%s\t%.5f\n', 'C', RunObj.params.C);
fprintf(fp, '%s\t%.1f\n', 'NUM_RUNS', RunObj.params.NRUNS);
fprintf(fp, '%s\t%.1f\n', 'NUM_BITS', RunObj.params.NBITS);
fprintf(fp, '%s\t%s\n', 'DATA NAME', RunObj.params.DATA_NAME);
fprintf(fp, '%s\t%s\n', 'PROJ_TYPE', RunObj.params.PROJ_TYPE);
fprintf(fp, '%s\t%.1f\n', 'NAFFINITY', RunObj.params.NAFFINITY);
fprintf(fp, '%s\t%.1f\n', 'IS_DATABASE', RunObj.params.IS_DATABASE);
fprintf(fp, '%s\t%.1f\n', 'NTEST', RunObj.params.NTEST);
fprintf(fp, '%s\t%.1f\n', 'NVALIDTEST', RunObj.params.NVALIDTEST);
fprintf(fp, '%s\t%.1f\n', 'NVALIDTRAIN', RunObj.params.NVALIDTRAIN);
fprintf(fp, '%s\t%.1f\n', 'NDATABASE', RunObj.params.NDATABASE);
fprintf(fp, '%s\t%.1f\n', 'NITER', RunObj.params.NITER);
fprintf(fp, '%s\t%.1f\n', 'ALPHA', RunObj.params.ALPHA);
fprintf(fp, '%s\t%.1f\n', 'KERNEL', RunObj.params.KERNEL);
fprintf(fp, '%s\t%.1f\n', 'NCHUNK', RunObj.params.NCHUNK);
fprintf(fp, '%s\t%.1f\n', 'NLANDMARKS', RunObj.params.NLANDMARKS);
fprintf(fp, '%s\t%.1f\n', 'L2NORM', RunObj.params.L2NORM);

nOfModels = size(RunObj.params.modelsToRun,2);
fprintf(fp,['%s\t' repmat('%g\t',1,nOfModels-1) '%g\n'],'MODELS',RunObj.params.modelsToRun.');

fclose(fp);

%%%%%%%%%%%%%%%%%%
resFileName = [RunObj.params.resDirFilePath,'mAPLSHs.csv'];
csvwrite(resFileName,RunObj.results.mAPLSHs);

resFileName = [RunObj.params.resDirFilePath,'mAPGRHs.csv'];
csvwrite(resFileName,RunObj.results.mAPGRHs);
