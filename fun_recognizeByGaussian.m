function messTag = fun_recognizeByGaussian(featureData,dimInd,gaussianPara)

featureData = featureData(:,dimInd);

ptest = multiplyGaussianSingle(featureData, gaussianPara.muValue, gaussianPara.sigma2);

messTag = (ptest > gaussianPara.epsilon);
end