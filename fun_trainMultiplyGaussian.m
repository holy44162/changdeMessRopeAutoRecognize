function gaussianPara = fun_trainMultiplyGaussian(dataML,dimInd)
%  Apply the same steps to the larger dataset
% X = X(:,1:numDim); % hided by Holy 1807301553
% X = X(:,dimInd); % added by Holy 1807301553 % hided by Holy 1808071050
X = dataML.X(:,dimInd); % added by Holy 1808071049
[muValue, Sigma2] = estimateGaussian(X);

% hided by Holy 1809271347
% if (size(Sigma2, 2) == 1) || (size(Sigma2, 1) == 1)
%     Sigma2 = diag(Sigma2);
% end
% 
% detSigma = det(Sigma2) ^ (-0.5);
% invSigma = pinv(Sigma2);
% end of hide 1809271347

%  Cross-validation set
% pval = multivariateGaussian(Xval, mu, Sigma2);
% Xval = Xval(:,1:numDim); % hided by Holy 1807301554
% Xval = Xval(:,dimInd); % added by Holy 1807301554 % hided by Holy 1808071051
Xval = dataML.Xval(:,dimInd); % added by Holy 1808071051
yval = dataML.yval; % added by Holy 1808071051
% pval = multivariateGaussianFast(Xval, muValue, detSigma, invSigma); % hided by Holy 1809271142
pval = multiplyGaussian(Xval, muValue, Sigma2); % added by Holy 1809271143

%  Find the best threshold
[epsilon, ~] = selectThreshold(yval, pval);

% added by Holy 1808061548
% gaussianPara.detSigma = detSigma; % hided by Holy 1809271347
% gaussianPara.invSigma = invSigma; % hided by Holy 1809271347
gaussianPara.epsilon = epsilon;
gaussianPara.muValue = muValue;
% end of addition 1808061548

gaussianPara.sigma2 = Sigma2; % added by Holy 1809271350

% hided by Holy 1808071057
% gaussianParaFileName = 'gaussianPara.mat';
% save(gaussianParaFileName,'detSigma','invSigma','epsilon','muValue');
% 
% disp('Gaussian training completed.');
% end of hide 1808071057
end