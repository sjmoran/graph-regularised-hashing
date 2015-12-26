function [RunObj,pAtR2, mAP] = eval_bits(RunObj, bitsData, isValid)

disp(sprintf ( 'Evaluating retrieval... \n') )

if (RunObj.params.IS_DATABASE==1)
    if (isValid)
       [RunObj,pAtR2, mAP] = eval_database_bits_valid(RunObj, bitsData);
    else
       [RunObj,pAtR2, mAP] = eval_database_bits_test(RunObj, bitsData);        
    end
    
else
    if (isValid)
       [RunObj,pAtR2, mAP] = eval_train_bits_valid(RunObj, bitsData);
    else
       [RunObj,pAtR2, mAP] = eval_train_bits_test(RunObj, bitsData);        
    end
end
