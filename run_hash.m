clear all;

rng(12345);

disp(sprintf ( 'Starting run \n') )

RunObj=initialise();                       % Initialise parameters for run
RunObj.params.modelsToRun=[1];

for i=1:size(RunObj.params.NBITS_ARRAY,2)
    
    for j=1:size(RunObj.params.NAFFINITY_ARRAY,2)
        
        RunObj.params.NAFFINITY=RunObj.params.NAFFINITY_ARRAY(:,j);
        
        RunObj=clear_results(RunObj);
        
        RunObj.params.NBITS=RunObj.params.NBITS_ARRAY(:,i);
        RunObj=make_res_dir(RunObj);

        resFileName = [RunObj.params.resDirFilePath,'grh_cross_valid.txt'];
        fp = fopen(resFileName, 'a');
        
        for k=1:RunObj.params.NRUNS
                    
            RunObj=load_data(RunObj);  % Load the object representing the run configuration
            RunObj=preprocess(RunObj);
            [RunObj, bitsSBQ] = get_baseline(RunObj);

            RunObj=compute_sbq(RunObj,bitsSBQ);

            %%%%%% GRH Hash baseline
            if ~isempty(find(RunObj.params.modelsToRun==1))
                RunObj.params.METHOD=5;
                RunObj = compute_grh(RunObj, bitsSBQ, k, fp);  
            end            
              
        end
        
        save_results(RunObj);
        fclose(fp);
    end
end