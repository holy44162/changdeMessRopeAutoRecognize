function [F1,tp,fp,indMess,indFn,indFp] = testGMM(dataML,GMModel,i)

% pval = mahal(GMModel,dataML.Xval(:,i)); % hided by Holy 1811251401
pval = pdf(GMModel,dataML.Xval(:,i)); % added by Holy 1811251401
[epsilon, ~] = selectThreshold(dataML.yval, pval);

% ptest = mahal(GMModel,dataML.Xtest(:,i)); % hided by Holy 1811251402
ptest = pdf(GMModel,dataML.Xtest(:,i)); % added by Holy 1811251402

indMess = find(ptest < epsilon);

testPredictions = (ptest < epsilon);
tp = sum((testPredictions == 1) & (dataML.ytest == 1));
fp = sum((testPredictions == 1) & (dataML.ytest == 0));
fn = sum((testPredictions == 0) & (dataML.ytest == 1));

fnTest = (testPredictions == 0) & (dataML.ytest == 1);
indFn = find(fnTest == 1);

fpTest = (testPredictions == 1) & (dataML.ytest == 0);
indFp = find(fpTest == 1);

prec = tp/(tp+fp);
rec = tp/(tp+fn);
F1 = 2*prec*rec/(prec+rec);
end