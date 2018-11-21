function [F1,tp,fp,indMess,indFn,indFp] = fun_testScriptWithPara(bestParaMat,trainFolderName,CVFolderName,testFolderName,heightBias,widthBias,featureType)
load(bestParaMat,'bestPara');

hogFeatureType = 'hogOnly';
gaborMaxFeatureType = 'gaborMax';
gaborBWHogFeatureType = 'gaborBWHog'; % added by Holy 1809111558
gaborBWHogNumFeatureType = 'gaborBWNum'; % added by Holy 1811011338
gaborSpecificFeatureType = 'gaborSpecific';
gaborsBinHogFeatureType = 'gaborsBinHog'; % added by Holy 1811081435

if contains(featureType, hogFeatureType,'IgnoreCase',true)
    dimInd = bestPara{1, 4};    
end

if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
    dimInd = 1;    
end

if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
    dimInd = bestPara{1, 4};    
end

% added by Holy 1811011344
if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
    dimInd = bestPara{1, 4};    
end
% end of addition 1811011344

% added by Holy 1811071621
if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
    dimInd = bestPara{1, 4};    
end
% end of addition 1811071621

% added by Holy 1811081444
if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
    dimInd = bestPara{1, 4};    
end
% end of addition 1811081444

hogSize = bestPara{1, 5};
imgEdge = bestPara{1, 6};
heightImgEdge = round(heightBias + imgEdge);
widthImgEdge = round(widthBias + imgEdge);

dataML = realWindingFeatureDataGen(trainFolderName,hogSize,heightImgEdge,widthImgEdge,featureType);
dataML = realWindingFeatureDataGen(CVFolderName,hogSize,heightImgEdge,widthImgEdge,featureType,dataML);
dataML = realWindingFeatureDataGen(testFolderName,hogSize,heightImgEdge,widthImgEdge,featureType,dataML);

% hided by Holy 1809271357
% gaussianPara = fun_trainGaussian(dataML,dimInd);
% [F1,tp,fp,indMess,indFn,indFp] = fun_testGaussian(dataML,dimInd,gaussianPara);
% end of hide 1809271357

% added by Holy 1811011544
if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
    numDim = size(dataML.X,2);
    dimInd = [dimInd numDim];
end
% end of addition 1811011544

% added by Holy 1809271357
gaussianPara = fun_trainMultiplyGaussian(dataML,dimInd);
[F1,tp,fp,indMess,indFn,indFp] = fun_testMultiplyGaussian(dataML,dimInd,gaussianPara);
% end of addition 1809271357

end