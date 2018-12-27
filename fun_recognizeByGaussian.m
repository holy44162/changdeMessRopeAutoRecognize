function messTag = fun_recognizeByGaussian(featureData,GMModel,epsilon)

% featureData = featureData(:,dimInd);

% ptest = multiplyGaussianSingle(featureData, gaussianPara.muValue, gaussianPara.sigma2); % hided by Holy 1811301519
ptest = pdf(GMModel,featureData); % added by Holy 1811301519

% messTag = (ptest > gaussianPara.epsilon); % hided by Holy 1811301520
messTag = (ptest < epsilon); % hided by Holy 1811301521
end