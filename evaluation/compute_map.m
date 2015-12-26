function [RunObj, mAP]=compute_map(RunObj,groundTruth, distHamm)

avgP=[];
distHamm=double(distHamm);
for i=1:size(distHamm)
    ap = apcal(distHamm(i,:),groundTruth(i,:), 1);
    avgP(i,1)=ap;
end
avgP(isnan(avgP))=0;
mAP=mean(avgP);