function [pAtR2]=recall_precision_atM(groundTruth, distHamm)

for i = 1:size(distHamm,1)
    [ph2] = prcal(distHamm(i,:),groundTruth(i,:));
    ph2_all(i,:)=ph2;
end

pAtR2=mean(ph2_all,1);


