function [F1,tp,fp,indMess,indFn,indFp] = fun_testGMM(dataML,GMModel,epsilon)

Xtest = dataML.Xtest;
ytest = dataML.ytest;

ptest = pdf(GMModel,Xtest);

indMess = find(ptest < epsilon);

testPredictions = (ptest < epsilon);
tp = sum((testPredictions == 1) & (ytest == 1));
fp = sum((testPredictions == 1) & (ytest == 0));
fn = sum((testPredictions == 0) & (ytest == 1));

fnTest = (testPredictions == 0) & (ytest == 1);
indFn = find(fnTest == 1);

fpTest = (testPredictions == 1) & (ytest == 0);
indFp = find(fpTest == 1);

prec = tp/(tp+fp);
rec = tp/(tp+fn);
F1 = 2*prec*rec/(prec+rec);
end