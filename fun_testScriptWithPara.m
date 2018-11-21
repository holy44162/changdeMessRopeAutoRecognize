function [F1,tp,fp,indMess,indFn,indFp] = fun_testScriptWithPara(bestParaMat,testFolderName,heightBias,widthBias,featureType)
load(bestParaMat,'bestPara','gaussianParaOutput','dataMLOutput');

gaborsBinHogFeatureType = 'gaborsBinHog';

if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
    dimInd = bestPara{1, 4};    
end

hogSize = bestPara{1, 5};
imgEdge = bestPara{1, 6};
heightImgEdge = round(heightBias + imgEdge);
widthImgEdge = round(widthBias + imgEdge);

dataML = realWindingFeatureDataGen(testFolderName,hogSize,heightImgEdge,widthImgEdge,featureType,dataMLOutput);

[F1,tp,fp,indMess,indFn,indFp] = fun_testMultiplyGaussian(dataML,dimInd,gaussianParaOutput);
end