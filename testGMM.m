function [F1,tp,fp,indMess,indFn,indFp] = testGMM(dataML,dimInd,gaussianPara)
%  Loads the dataset. You should now have the
%  variables X, Xval, yval, Xtest, ytest in your environment
% hided by Holy 1808071110
% dataMLFileName = 'dataML.mat';
% if exist(dataMLFileName, 'file') == 2
%     load(dataMLFileName);
% else
%     disp('You should build dataML.mat first.');
%     return;
% end
% 
% gaussianParaFileName = 'gaussianPara.mat';
% if exist(gaussianParaFileName, 'file') == 2
%     load(gaussianParaFileName);
% else
%     disp('You should train Gaussian model first.');
%     return;
% end
% end of hide 1808071110

%  test set
% Xtest = Xtest(:,1:numDim); % hided by Holy 1807301554
% Xtest = Xtest(:,dimInd); % added by Holy 1807301554 % hided by Holy 1808071113
% added by Holy 1808071112
Xtest = dataML.Xtest(:,dimInd);
ytest = dataML.ytest;
% hided by Holy 1809271351
% detSigma = gaussianPara.detSigma;
% invSigma = gaussianPara.invSigma;
% end of hide 1809271351
epsilon = gaussianPara.epsilon;
muValue = gaussianPara.muValue;
% end of addition 1808071112
% ptest = multivariateGaussianFast(Xtest, muValue, detSigma, invSigma); % hided by Holy 1809271145
ptest = multiplyGaussian(Xtest, muValue, gaussianPara.sigma2); % added by Holy 1809271145

% numMess = sum(ptest < epsilon);
% indMess = find(ptest < epsilon)+1;
indMess = find(ptest < epsilon);

testPredictions = (ptest < epsilon);
tp = sum((testPredictions == 1) & (ytest == 1));
fp = sum((testPredictions == 1) & (ytest == 0));
fn = sum((testPredictions == 0) & (ytest == 1));

% added by Holy 1809051333
fnTest = (testPredictions == 0) & (ytest == 1);
indFn = find(fnTest == 1);
% end of addition 1809051333

% added by Holy 1809191508
fpTest = (testPredictions == 1) & (ytest == 0);
indFp = find(fpTest == 1);
% end of addition 1809191508

prec = tp/(tp+fp);
rec = tp/(tp+fn);
F1 = 2*prec*rec/(prec+rec);

% hided by Holy 1808071130
% disp(['The total number of mess frames is: ' num2str(numMess)]);
% disp(['The indices of mess frames are: ' num2str(indMess')]);
% disp(['tp is: ' num2str(tp)]);
% disp(['fn is: ' num2str(fn)]);
% disp(['fp is: ' num2str(fp)]);
% disp(['The F1 score is: ' num2str(F1)]);
% 
% f = fopen('log.txt', 'a');
% fprintf(f, 'tp = %d, fp =  %d, F1 =  %d\r\n\r\n',tp, fp, F1);
% fclose(f);
% end of hide 1808071130
end