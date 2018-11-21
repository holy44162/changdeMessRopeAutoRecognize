function messTag = fun_recognizeByGaussian(featureData,dimInd,gaussianPara)

featureData = featureData(:,dimInd);

ptest = multiplyGaussian(featureData, gaussianPara.muValue, gaussianPara.sigma2);

messTag = (ptest > gaussianPara.epsilon);
end