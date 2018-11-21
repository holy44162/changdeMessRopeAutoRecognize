function [bestPara,paraLog,dataMLOutput] = fun_testScript(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep,trainFolderName,CVFolderName,testFolderName,featureType)

minImgEdge = 0;


if numImgEdgeStep == 0
    imgEdgeSteps = 0;
else
    stepSizeImgEdge = (maxImgEdge - minImgEdge) / numImgEdgeStep;
    imgEdgeSteps = maxImgEdge:-stepSizeImgEdge:minImgEdge;
end

minHogSize = 2;


if numHogSizeStep == 0
    hogSizeSteps = maxHogSize;
else
    stepSizeHogSize = (maxHogSize - minHogSize) / numHogSizeStep;
    hogSizeSteps = maxHogSize:-stepSizeHogSize:minHogSize;
end

gaborsBinHogFeatureType = 'gaborsBinHog';

bestPara = num2cell(zeros(1,6));
paraLog = [];
iProgress = 1;

for imgEdge = imgEdgeSteps
    progressbar(iProgress,numImgEdgeStep+1);
    heightImgEdge = round(heightBias + imgEdge);
    widthImgEdge = round(widthBias + imgEdge);
    
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        for hogSize = hogSizeSteps
            hogSize1 = round(hogSize);
            % train
            dataML = realWindingFeatureDataGen(trainFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType);
            
            % CV
            dataML = realWindingFeatureDataGen(CVFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % test
            dataML = realWindingFeatureDataGen(testFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % get best parameters
            numDim = size(dataML.X,2);
            resultMatrix = zeros(numDim,4);
            for i = 1:numDim
                gaussianPara = fun_trainMultiplyGaussian(dataML,i);
                
                [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testMultiplyGaussian(dataML,i,gaussianPara);
                resultMatrix(i,4) = i;
            end
            sortedResult = sortrows(resultMatrix,'descend');
            
            % remove lines with nan elements
            nanTag = isnan(sortedResult);
            nanInd = any(nanTag,2);
            sortedResult(nanInd,:) = [];
            
            % perform feature selection
            maxF1Row = num2cell(sortedResult(1,:));
            maxF1Row = [maxF1Row {hogSize1} {imgEdge}];
            featureIDs = maxF1Row(4);
            resultCell = cell(1,4);
            selectedIDs = featureIDs;
            for i = 1:size(sortedResult,1)
                if i > 1
                    diff = length(featureIDs{1}) - length(selectedIDs{1});
                    if diff == 0
                        break;
                    else
                        selectedIDs = featureIDs;
                    end
                end
                for j = 1:size(sortedResult,1)
                    if sum(selectedIDs{1}==sortedResult(j,4)) == 1
                        continue;
                    end
                    dimIDs = [selectedIDs{1} sortedResult(j,4)];
                    gaussianPara = fun_trainMultiplyGaussian(dataML,dimIDs);
                    [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testMultiplyGaussian(dataML,dimIDs,gaussianPara);
                    resultCell{1,4} = dimIDs;
                    
                    if resultCell{1,1} == 1
                        bestPara = [bestPara;[resultCell {hogSize1} {imgEdge}]];
                    end
                                        
                    if resultCell{1,1} > maxF1Row{1}
                        maxF1Row(1:4) = resultCell;
                        featureIDs = maxF1Row(4);
                        
                        if maxF1Row{1} > bestPara{1,1}
                            bestPara = maxF1Row;
                            dataMLOutput = dataML;
                        end                        
                    end
                end
            end
            paraLog = [paraLog;maxF1Row];
        end
    end
    iProgress = iProgress + 1;
end
end