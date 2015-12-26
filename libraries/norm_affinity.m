function affinity = norm_affinity(RunObj)

affinity=RunObj.data.affinity*spdiags(1./sum(RunObj.data.affinity,1).',0,size(RunObj.data.affinity,1),size(RunObj.data.affinity,1));
affinity=affinity';